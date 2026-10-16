import 'package:uuid/uuid.dart';

class LifestyleLogModel {
  final String id;
  final String type; // 'meal', 'water', 'workout', 'sleep_start', 'wake'
  final DateTime timestamp;
  final String? notes;
  final int? value; // water cups, meal count, etc.
  final String? ledgerEntryId;

  LifestyleLogModel({
    String? id,
    required this.type,
    DateTime? timestamp,
    this.notes,
    this.value,
    this.ledgerEntryId,
  })  : id = id ?? const Uuid().v4(),
        timestamp = timestamp ?? DateTime.now();

  Map<String, dynamic> toJson() => {
        'id': id,
        'type': type,
        'timestamp': timestamp.toIso8601String(),
        'notes': notes,
        'value': value,
        'ledgerEntryId': ledgerEntryId,
      };

  factory LifestyleLogModel.fromJson(Map<String, dynamic> json) =>
      LifestyleLogModel(
        id: json['id'] as String,
        type: json['type'] as String,
        timestamp: DateTime.parse(json['timestamp'] as String),
        notes: json['notes'] as String?,
        value: json['value'] as int?,
        ledgerEntryId: json['ledgerEntryId'] as String?,
      );

  LifestyleLogModel copyWith({
    String? id,
    String? type,
    DateTime? timestamp,
    String? notes,
    int? value,
    String? ledgerEntryId,
  }) =>
      LifestyleLogModel(
        id: id ?? this.id,
        type: type ?? this.type,
        timestamp: timestamp ?? this.timestamp,
        notes: notes ?? this.notes,
        value: value ?? this.value,
        ledgerEntryId: ledgerEntryId ?? this.ledgerEntryId,
      );
}
