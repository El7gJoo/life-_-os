import 'package:equatable/equatable.dart';

class LedgerEntry extends Equatable {
  final String id;
  final int points;
  final String reason;
  final String sourceFeature;
  final DateTime timestamp;
  final bool isReversal;
  final String? relatedEntryId;

  const LedgerEntry({
    required this.id,
    required this.points,
    required this.reason,
    required this.sourceFeature,
    required this.timestamp,
    this.isReversal = false,
    this.relatedEntryId,
  });

  @override
  List<Object?> get props => [
        id,
        points,
        reason,
        sourceFeature,
        timestamp,
        isReversal,
        relatedEntryId,
      ];
}
