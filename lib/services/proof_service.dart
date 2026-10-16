import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';
import '../features/gamification/data/repositories/gamification_repository.dart';
import '../features/schedule_study/data/models/proof_log_model.dart';
import '../features/settings_backup/data/repositories/settings_repository.dart';

class ProofVerificationResult {
  final bool isValid;
  final double confidence;
  final String reason;
  final String verdict; // 'approved', 'rejected', 'location_verified', 'duplicate', 'max_attempts_exceeded', 'offline_queued'
  final bool isOfflineQueued;

  const ProofVerificationResult({
    required this.isValid,
    this.confidence = 0.0,
    required this.reason,
    required this.verdict,
    this.isOfflineQueued = false,
  });
}

class ProofService {
  final SettingsRepository _settingsRepository;
  final Box _proofLogsBox;
  final Box _pendingProofBox;
  final GamificationRepository? _gamificationRepository;

  ProofService({
    required SettingsRepository settingsRepository,
    required Box proofLogsBox,
    required Box pendingProofBox,
    GamificationRepository? gamificationRepository,
  })  : _settingsRepository = settingsRepository,
        _proofLogsBox = proofLogsBox,
        _pendingProofBox = pendingProofBox,
        _gamificationRepository = gamificationRepository;

  /// Pure Haversine formula to compute distance in meters between two GPS coordinates
  static double calculateDistanceMeters(
    double lat1,
    double lon1,
    double lat2,
    double lon2,
  ) {
    const double earthRadiusMeters = 6371000;
    final dLat = (lat2 - lat1) * (pi / 180.0);
    final dLon = (lon2 - lon1) * (pi / 180.0);

    final a = sin(dLat / 2) * sin(dLat / 2) +
        cos(lat1 * (pi / 180.0)) *
            cos(lat2 * (pi / 180.0)) *
            sin(dLon / 2) *
            sin(dLon / 2);
    final c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return earthRadiusMeters * c;
  }

  /// Pure SHA-256 calculation for image bytes
  static String calculateSha256(List<int> bytes) {
    return sha256.convert(bytes).toString();
  }

  /// Pure parser for Gemini JSON response
  static Map<String, dynamic> parseGeminiResponse(String responseText) {
    try {
      // Find JSON block or parse directly
      String rawJson = responseText.trim();
      if (rawJson.contains('```json')) {
        rawJson = rawJson.split('```json')[1].split('```')[0].trim();
      } else if (rawJson.contains('```')) {
        rawJson = rawJson.split('```')[1].split('```')[0].trim();
      }

      final Map<String, dynamic> data = jsonDecode(rawJson) as Map<String, dynamic>;
      final bool valid = data['valid'] == true;
      final num conf = data['confidence'] as num? ?? (valid ? 1.0 : 0.0);
      final String reason = data['reason'] as String? ?? '';

      return {
        'valid': valid,
        'confidence': conf.toDouble(),
        'reason': reason,
      };
    } catch (e) {
      return {
        'valid': false,
        'confidence': 0.0,
        'reason': 'Malformed response from AI',
      };
    }
  }

  /// Checks if photo hash was previously submitted and approved
  bool isDuplicateHash(String hash) {
    final logs = getProofLogs();
    return logs.any((log) => log.photoHash == hash && (log.verdict == 'approved' || log.verdict == 'location_verified'));
  }

  /// Counts rejected attempts today for this targetId
  int getTodayFailedAttempts(String targetId) {
    final now = DateTime.now();
    final todayStr = '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
    final logs = getProofLogs();

    return logs.where((l) {
      final logDate = '${l.timestamp.year}-${l.timestamp.month.toString().padLeft(2, '0')}-${l.timestamp.day.toString().padLeft(2, '0')}';
      return l.targetId == targetId && logDate == todayStr && l.verdict == 'rejected';
    }).length;
  }

  /// Test Gemini API key with a minimal prompt
  Future<bool> testApiKey(String apiKey) async {
    if (apiKey.trim().isEmpty) return false;
    final url = Uri.parse(
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=${apiKey.trim()}',
    );

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'contents': [
            {
              'parts': [
                {'text': 'Ping'}
              ]
            }
          ]
        }),
      );
      return response.statusCode == 200;
    } catch (_) {
      return false;
    }
  }

  /// Verify University Attendance via Geofence
  ProofVerificationResult verifyAttendanceLocation({
    required double currentLat,
    required double currentLng,
  }) {
    final savedLat = _settingsRepository.getUniversityLatitude();
    final savedLng = _settingsRepository.getUniversityLongitude();
    final radius = _settingsRepository.getUniversityRadius();

    if (savedLat == null || savedLng == null) {
      return const ProofVerificationResult(
        isValid: false,
        confidence: 0.0,
        reason: 'University location not configured',
        verdict: 'location_mismatch',
      );
    }

    final distance = calculateDistanceMeters(currentLat, currentLng, savedLat, savedLng);

    if (distance <= radius) {
      return ProofVerificationResult(
        isValid: true,
        confidence: 1.0,
        reason: 'Verified attendance via location (${distance.toInt()}m from campus center)',
        verdict: 'location_verified',
      );
    } else {
      return ProofVerificationResult(
        isValid: false,
        confidence: 0.0,
        reason: 'Outside university campus (${distance.toInt()}m away, allowed: ${radius}m)',
        verdict: 'location_mismatch',
      );
    }
  }

  /// Verify Photo proof with Gemini Vision Flash
  Future<ProofVerificationResult> verifyPhotoProof({
    required List<int> imageBytes,
    required String type, // 'attendance' or 'study'
    required String targetId, // sessionId or subjectId
    String? subjectName,
    http.Client? httpClient,
  }) async {
    // 1. Max 3 attempts check
    final failedAttempts = getTodayFailedAttempts(targetId);
    if (failedAttempts >= 3) {
      final log = ProofLogModel(
        id: const Uuid().v4(),
        timestamp: DateTime.now(),
        type: type,
        targetId: targetId,
        verdict: 'rejected',
        reason: 'Maximum 3 verification attempts reached for today.',
      );
      await saveProofLog(log);

      return const ProofVerificationResult(
        isValid: false,
        confidence: 0.0,
        reason: 'Maximum 3 attempts reached for today. Block locked.',
        verdict: 'max_attempts_exceeded',
      );
    }

    // 2. Hash check (SHA-256 duplicate detection)
    final photoHash = calculateSha256(imageBytes);
    if (isDuplicateHash(photoHash)) {
      final log = ProofLogModel(
        id: const Uuid().v4(),
        timestamp: DateTime.now(),
        type: type,
        targetId: targetId,
        verdict: 'rejected',
        reason: 'This photo has already been used for proof.',
        photoHash: photoHash,
      );
      await saveProofLog(log);

      return const ProofVerificationResult(
        isValid: false,
        confidence: 0.0,
        reason: 'This photo has already been used for proof.',
        verdict: 'duplicate',
      );
    }

    // 3. Gemini Vision API call
    final apiKey = _settingsRepository.getGeminiApiKey();
    if (apiKey == null || apiKey.trim().isEmpty) {
      return const ProofVerificationResult(
        isValid: false,
        confidence: 0.0,
        reason: 'Gemini API key is not configured in Settings.',
        verdict: 'rejected',
      );
    }

    final prompt = type == 'attendance'
        ? 'Analyze this image. Does it show a university lecture hall, classroom, professor, whiteboard/screen with academic content, or university campus? Return JSON: {"valid": true/false, "confidence": 0.0-1.0, "reason": "short English description"}.'
        : 'Analyze this image. Does it show a study environment (notebook, textbook, laptop with study material${subjectName != null ? " related to $subjectName" : ""}, handwritten notes, desk)? Return JSON: {"valid": true/false, "confidence": 0.0-1.0, "reason": "short English description"}.';

    final base64Image = base64Encode(imageBytes);
    final url = Uri.parse(
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=${apiKey.trim()}',
    );

    final client = httpClient ?? http.Client();

    try {
      final response = await client.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'contents': [
            {
              'parts': [
                {'text': prompt},
                {
                  'inline_data': {
                    'mime_type': 'image/jpeg',
                    'data': base64Image,
                  }
                }
              ]
            }
          ]
        }),
      );

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body) as Map<String, dynamic>;
        final candidates = decoded['candidates'] as List?;
        if (candidates != null && candidates.isNotEmpty) {
          final content = candidates[0]['content'];
          final parts = content['parts'] as List?;
          if (parts != null && parts.isNotEmpty) {
            final text = parts[0]['text'] as String? ?? '';
            final parsed = parseGeminiResponse(text);

            final bool isValid = parsed['valid'] == true && (parsed['confidence'] as double) >= 0.7;
            final String verdict = isValid ? 'approved' : 'rejected';
            final String reason = parsed['reason'] as String;

            final log = ProofLogModel(
              id: const Uuid().v4(),
              timestamp: DateTime.now(),
              type: type,
              targetId: targetId,
              verdict: verdict,
              reason: reason,
              photoHash: photoHash,
            );
            await saveProofLog(log);

            return ProofVerificationResult(
              isValid: isValid,
              confidence: parsed['confidence'] as double,
              reason: reason,
              verdict: verdict,
            );
          }
        }
      }

      // API returned error or empty response
      return const ProofVerificationResult(
        isValid: false,
        confidence: 0.0,
        reason: 'AI verification could not process the photo. Please try again.',
        verdict: 'rejected',
      );
    } catch (e) {
      // Offline fallback: queue photo hash in pendingProofBox and award points provisionally
      final queueId = const Uuid().v4();
      await _pendingProofBox.put(queueId, {
        'id': queueId,
        'type': type,
        'targetId': targetId,
        'photoHash': photoHash,
        'timestamp': DateTime.now().toIso8601String(),
        'points': 10,
      });

      final log = ProofLogModel(
        id: queueId,
        timestamp: DateTime.now(),
        type: type,
        targetId: targetId,
        verdict: 'offline_queued',
        reason: 'Queued offline for verification when internet is available.',
        photoHash: photoHash,
      );
      await saveProofLog(log);

      return const ProofVerificationResult(
        isValid: true,
        confidence: 1.0,
        reason: 'No internet connection. Proof queued for verification.',
        verdict: 'offline_queued',
        isOfflineQueued: true,
      );
    }
  }

  /// Process offline pending proofs when connection returns
  Future<void> processPendingProofs() async {
    if (_pendingProofBox.isEmpty) return;

    final keys = _pendingProofBox.keys.toList();
    for (final key in keys) {
      final item = _pendingProofBox.get(key);
      if (item is Map) {
        final ledgerEntryId = item['ledgerEntryId'] as String?;
        final isRejected = item['rejected'] == true;
        if (isRejected && ledgerEntryId != null && _gamificationRepository != null) {
          await _gamificationRepository.addReversal(ledgerEntryId, 'Proof rejected on verification');
        }
        await _pendingProofBox.delete(key);
      }
    }
  }

  /// Proof Logs Storage
  List<ProofLogModel> getProofLogs() {
    final values = _proofLogsBox.values;
    final list = <ProofLogModel>[];
    for (final val in values) {
      if (val is Map) {
        try {
          list.add(ProofLogModel.fromJson(Map<String, dynamic>.from(val)));
        } catch (_) {}
      }
    }
    list.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    return list;
  }

  Future<void> saveProofLog(ProofLogModel log) async {
    await _proofLogsBox.put(log.id, log.toJson());
  }

  Future<void> clearProofLogs() async {
    await _proofLogsBox.clear();
  }
}
