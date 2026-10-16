import 'package:equatable/equatable.dart';

class AttendanceRecord extends Equatable {
  final String id;
  final String sessionId;
  final String dateStr; // Format: YYYY-MM-DD
  final DateTime timestamp;
  final int pointsAwarded;
  final String? ledgerEntryId;

  const AttendanceRecord({
    required this.id,
    required this.sessionId,
    required this.dateStr,
    required this.timestamp,
    required this.pointsAwarded,
    this.ledgerEntryId,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sessionId': sessionId,
      'dateStr': dateStr,
      'timestamp': timestamp.toIso8601String(),
      'pointsAwarded': pointsAwarded,
      if (ledgerEntryId != null) 'ledgerEntryId': ledgerEntryId,
    };
  }

  factory AttendanceRecord.fromJson(Map<String, dynamic> json) {
    return AttendanceRecord(
      id: json['id'] as String,
      sessionId: json['sessionId'] as String,
      dateStr: json['dateStr'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      pointsAwarded: json['pointsAwarded'] as int? ?? 10,
      ledgerEntryId: json['ledgerEntryId'] as String?,
    );
  }

  @override
  List<Object?> get props => [id, sessionId, dateStr, timestamp, pointsAwarded, ledgerEntryId];
}
