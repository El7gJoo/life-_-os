import 'package:equatable/equatable.dart';

class ProofLogModel extends Equatable {
  final String id;
  final DateTime timestamp;
  final String type; // 'attendance' or 'study'
  final String targetId; // sessionId or subjectId
  final String verdict; // 'approved', 'rejected', 'location_verified'
  final String reason;
  final String? photoHash;

  const ProofLogModel({
    required this.id,
    required this.timestamp,
    required this.type,
    required this.targetId,
    required this.verdict,
    required this.reason,
    this.photoHash,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'timestamp': timestamp.toIso8601String(),
        'type': type,
        'targetId': targetId,
        'verdict': verdict,
        'reason': reason,
        'photoHash': photoHash,
      };

  factory ProofLogModel.fromJson(Map<String, dynamic> json) => ProofLogModel(
        id: json['id'] as String,
        timestamp: DateTime.parse(json['timestamp'] as String),
        type: json['type'] as String,
        targetId: json['targetId'] as String,
        verdict: json['verdict'] as String,
        reason: json['reason'] as String? ?? '',
        photoHash: json['photoHash'] as String?,
      );

  @override
  List<Object?> get props => [
        id,
        timestamp,
        type,
        targetId,
        verdict,
        reason,
        photoHash,
      ];
}
