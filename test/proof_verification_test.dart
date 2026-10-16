import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:life_os/features/schedule_study/data/models/proof_log_model.dart';
import 'package:life_os/features/settings_backup/data/repositories/settings_repository.dart';
import 'package:life_os/services/proof_service.dart';

class MockBox extends Fake implements Box {
  final Map<dynamic, dynamic> _map = {};

  @override
  Iterable get values => _map.values;

  @override
  Iterable get keys => _map.keys;

  @override
  dynamic get(dynamic key, {dynamic defaultValue}) => _map[key] ?? defaultValue;

  @override
  Future<void> put(dynamic key, dynamic value) async {
    _map[key] = value;
  }

  @override
  Future<void> delete(dynamic key) async {
    _map.remove(key);
  }

  @override
  Future<int> clear() async {
    final count = _map.length;
    _map.clear();
    return count;
  }

  @override
  bool get isEmpty => _map.isEmpty;

  @override
  int get length => _map.length;
}

class MockSettingsRepository extends Fake implements SettingsRepository {
  String? apiKey = 'test_gemini_api_key';
  bool requireProof = true;
  double? universityLat = 30.0276;
  double? universityLng = 31.2089;
  int radius = 500;

  @override
  String? getGeminiApiKey() => apiKey;
  @override
  bool isRequireProofEnabled() => requireProof;
  @override
  double? getUniversityLatitude() => universityLat;
  @override
  double? getUniversityLongitude() => universityLng;
  @override
  int getUniversityRadius() => radius;
}

void main() {
  group('ProofService Gemini JSON Parsing Tests', () {
    test('parses clean valid JSON response correctly', () {
      const response = '{"valid": true, "confidence": 0.95, "reason": "Lecture hall with blackboard visible"}';
      final parsed = ProofService.parseGeminiResponse(response);

      expect(parsed['valid'], isTrue);
      expect(parsed['confidence'], 0.95);
      expect(parsed['reason'], 'Lecture hall with blackboard visible');
    });

    test('parses JSON wrapped inside markdown code fences', () {
      const response = '```json\n{"valid": true, "confidence": 0.85, "reason": "Textbook and notes on desk"}\n```';
      final parsed = ProofService.parseGeminiResponse(response);

      expect(parsed['valid'], isTrue);
      expect(parsed['confidence'], 0.85);
      expect(parsed['reason'], 'Textbook and notes on desk');
    });

    test('parses invalid proof verdict with low confidence', () {
      const response = '{"valid": false, "confidence": 0.2, "reason": "Living room sofa, no study material"}';
      final parsed = ProofService.parseGeminiResponse(response);

      expect(parsed['valid'], isFalse);
      expect(parsed['confidence'], 0.2);
      expect(parsed['reason'], 'Living room sofa, no study material');
    });

    test('handles malformed / non-JSON response gracefully', () {
      const response = 'I am an AI and I cannot verify this image accurately.';
      final parsed = ProofService.parseGeminiResponse(response);

      expect(parsed['valid'], isFalse);
      expect(parsed['confidence'], 0.0);
      expect(parsed['reason'], contains('Malformed'));
    });
  });

  group('ProofService Geofencing Tests', () {
    late MockSettingsRepository settingsRepo;
    late MockBox proofLogsBox;
    late MockBox pendingProofBox;
    late ProofService proofService;

    setUp(() {
      settingsRepo = MockSettingsRepository();
      proofLogsBox = MockBox();
      pendingProofBox = MockBox();
      proofService = ProofService(
        settingsRepository: settingsRepo,
        proofLogsBox: proofLogsBox,
        pendingProofBox: pendingProofBox,
      );
    });

    test('geofence math calculates distance accurately and passes within radius', () {
      // University is at 30.0276, 31.2089 (Cairo University)
      // Point ~100m away
      const currentLat = 30.0280;
      const currentLng = 31.2093;

      final dist = ProofService.calculateDistanceMeters(
        currentLat,
        currentLng,
        settingsRepo.universityLat!,
        settingsRepo.universityLng!,
      );

      expect(dist, lessThan(500)); // Within 500m radius

      final result = proofService.verifyAttendanceLocation(
        currentLat: currentLat,
        currentLng: currentLng,
      );

      expect(result.isValid, isTrue);
      expect(result.verdict, 'location_verified');
    });

    test('geofence rejects location when outside configured radius', () {
      // Point ~2.5km away
      const farLat = 30.0500;
      const farLng = 31.2300;

      final dist = ProofService.calculateDistanceMeters(
        farLat,
        farLng,
        settingsRepo.universityLat!,
        settingsRepo.universityLng!,
      );

      expect(dist, greaterThan(500));

      final result = proofService.verifyAttendanceLocation(
        currentLat: farLat,
        currentLng: farLng,
      );

      expect(result.isValid, isFalse);
      expect(result.verdict, 'location_mismatch');
      expect(result.reason, contains('Outside university campus'));
    });
  });

  group('ProofService Photo Hash & Duplicate Rejection Tests', () {
    late MockSettingsRepository settingsRepo;
    late MockBox proofLogsBox;
    late MockBox pendingProofBox;
    late ProofService proofService;

    setUp(() {
      settingsRepo = MockSettingsRepository();
      proofLogsBox = MockBox();
      pendingProofBox = MockBox();
      proofService = ProofService(
        settingsRepository: settingsRepo,
        proofLogsBox: proofLogsBox,
        pendingProofBox: pendingProofBox,
      );
    });

    test('SHA-256 calculation produces consistent hash for same bytes', () {
      final sampleBytes1 = utf8.encode('photo_content_1');
      final sampleBytes2 = utf8.encode('photo_content_1');
      final sampleBytes3 = utf8.encode('photo_content_different');

      final hash1 = ProofService.calculateSha256(sampleBytes1);
      final hash2 = ProofService.calculateSha256(sampleBytes2);
      final hash3 = ProofService.calculateSha256(sampleBytes3);

      expect(hash1, equals(hash2));
      expect(hash1, isNot(equals(hash3)));
    });

    test('rejects duplicate photo hash if already submitted and approved', () async {
      final sampleBytes = utf8.encode('classroom_blackboard_image');
      final hash = ProofService.calculateSha256(sampleBytes);

      // Pre-populate proof log with this hash
      final existingLog = ProofLogModel(
        id: 'log-1',
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        type: 'attendance',
        targetId: 'session-prev',
        verdict: 'approved',
        reason: 'Lecture hall verified',
        photoHash: hash,
      );
      await proofService.saveProofLog(existingLog);

      final result = await proofService.verifyPhotoProof(
        imageBytes: sampleBytes,
        type: 'attendance',
        targetId: 'session-new',
      );

      expect(result.isValid, isFalse);
      expect(result.verdict, 'duplicate');
      expect(result.reason, 'This photo has already been used for proof.');
    });
  });

  group('ProofService Max 3 Attempts Logic Tests', () {
    late MockSettingsRepository settingsRepo;
    late MockBox proofLogsBox;
    late MockBox pendingProofBox;
    late ProofService proofService;

    setUp(() {
      settingsRepo = MockSettingsRepository();
      proofLogsBox = MockBox();
      pendingProofBox = MockBox();
      proofService = ProofService(
        settingsRepository: settingsRepo,
        proofLogsBox: proofLogsBox,
        pendingProofBox: pendingProofBox,
      );
    });

    test('locks session after 3 failed attempts today', () async {
      const targetId = 'session-limit-test';

      // Record 3 rejected logs for today
      for (int i = 1; i <= 3; i++) {
        await proofService.saveProofLog(ProofLogModel(
          id: 'log-$i',
          timestamp: DateTime.now(),
          type: 'attendance',
          targetId: targetId,
          verdict: 'rejected',
          reason: 'Photo unclear attempt $i',
        ));
      }

      final result = await proofService.verifyPhotoProof(
        imageBytes: utf8.encode('new_photo_attempt_4'),
        type: 'attendance',
        targetId: targetId,
      );

      expect(result.isValid, isFalse);
      expect(result.verdict, 'max_attempts_exceeded');
      expect(result.reason, contains('Maximum 3 attempts reached'));
    });
  });

  group('ProofService Offline Queue Tests', () {
    late MockSettingsRepository settingsRepo;
    late MockBox proofLogsBox;
    late MockBox pendingProofBox;
    late ProofService proofService;

    setUp(() {
      settingsRepo = MockSettingsRepository();
      proofLogsBox = MockBox();
      pendingProofBox = MockBox();
      proofService = ProofService(
        settingsRepository: settingsRepo,
        proofLogsBox: proofLogsBox,
        pendingProofBox: pendingProofBox,
      );
    });

    test('offline network error queues proof and awards provisional points', () async {
      // Mock HTTP client that throws network exception
      final offlineClient = MockClient((request) async {
        throw http.ClientException('Network unreachable');
      });

      final imageBytes = utf8.encode('offline_study_notes');

      final result = await proofService.verifyPhotoProof(
        imageBytes: imageBytes,
        type: 'study',
        targetId: 'subject-math',
        httpClient: offlineClient,
      );

      expect(result.isValid, isTrue);
      expect(result.isOfflineQueued, isTrue);
      expect(result.verdict, 'offline_queued');
      expect(pendingProofBox.length, 1);

      // Process pending queue
      await proofService.processPendingProofs();
      expect(pendingProofBox.length, 0);
    });
  });
}
