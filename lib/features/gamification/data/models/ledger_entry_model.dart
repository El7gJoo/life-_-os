import 'package:uuid/uuid.dart';

class LedgerEntryModel {
  final String id;
  final int points; // positive = earned, negative = spent
  final String reason;
  final String sourceFeature; // 'gamification','schedule','finance','lifestyle','fiancee'
  final DateTime timestamp;
  final bool isReversal;
  final String? reversalOf; // id of the entry this reverses

  LedgerEntryModel({
    String? id,
    required this.points,
    required this.reason,
    required this.sourceFeature,
    DateTime? timestamp,
    this.isReversal = false,
    this.reversalOf,
  })  : id = id ?? const Uuid().v4(),
        timestamp = timestamp ?? DateTime.now();

  Map<String, dynamic> toJson() => {
        'id': id,
        'points': points,
        'reason': reason,
        'sourceFeature': sourceFeature,
        'timestamp': timestamp.toIso8601String(),
        'isReversal': isReversal,
        'reversalOf': reversalOf,
      };

  factory LedgerEntryModel.fromJson(Map<String, dynamic> json) =>
      LedgerEntryModel(
        id: json['id'] as String,
        points: json['points'] as int,
        reason: json['reason'] as String,
        sourceFeature: json['sourceFeature'] as String,
        timestamp: DateTime.parse(json['timestamp'] as String),
        isReversal: json['isReversal'] as bool? ?? false,
        reversalOf: json['reversalOf'] as String?,
      );

  LedgerEntryModel copyWith({
    String? id,
    int? points,
    String? reason,
    String? sourceFeature,
    DateTime? timestamp,
    bool? isReversal,
    String? reversalOf,
  }) =>
      LedgerEntryModel(
        id: id ?? this.id,
        points: points ?? this.points,
        reason: reason ?? this.reason,
        sourceFeature: sourceFeature ?? this.sourceFeature,
        timestamp: timestamp ?? this.timestamp,
        isReversal: isReversal ?? this.isReversal,
        reversalOf: reversalOf ?? this.reversalOf,
      );
}
