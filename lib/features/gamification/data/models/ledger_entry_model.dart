import '../../domain/entities/ledger_entry.dart';

class LedgerEntryModel {
  final String id;
  final int points;
  final String reason;
  final String sourceFeature;
  final DateTime timestamp;
  final bool isReversal;
  final String? relatedEntryId;

  LedgerEntryModel({
    required this.id,
    required this.points,
    required this.reason,
    required this.sourceFeature,
    required this.timestamp,
    this.isReversal = false,
    this.relatedEntryId,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'points': points,
        'reason': reason,
        'sourceFeature': sourceFeature,
        'timestamp': timestamp.toIso8601String(),
        'isReversal': isReversal,
        'relatedEntryId': relatedEntryId,
      };

  factory LedgerEntryModel.fromJson(Map<dynamic, dynamic> json) =>
      LedgerEntryModel(
        id: json['id'] as String,
        points: json['points'] as int? ?? 0,
        reason: json['reason'] as String? ?? '',
        sourceFeature: json['sourceFeature'] as String? ?? '',
        timestamp: DateTime.parse(json['timestamp'] as String),
        isReversal: json['isReversal'] as bool? ?? false,
        relatedEntryId: json['relatedEntryId'] as String?,
      );

  LedgerEntry toEntity() => LedgerEntry(
        id: id,
        points: points,
        reason: reason,
        sourceFeature: sourceFeature,
        timestamp: timestamp,
        isReversal: isReversal,
        relatedEntryId: relatedEntryId,
      );

  factory LedgerEntryModel.fromEntity(LedgerEntry entity) => LedgerEntryModel(
        id: entity.id,
        points: entity.points,
        reason: entity.reason,
        sourceFeature: entity.sourceFeature,
        timestamp: entity.timestamp,
        isReversal: entity.isReversal,
        relatedEntryId: entity.relatedEntryId,
      );
}
