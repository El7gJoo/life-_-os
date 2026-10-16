import 'package:uuid/uuid.dart';

class OccasionModel {
  final String id;
  final String name;
  final String type; // 'birthday', 'anniversary', 'planned_date', 'custom'
  final DateTime date;
  final bool repeatYearly;
  final String? notes;

  OccasionModel({
    String? id,
    required this.name,
    required this.type,
    required this.date,
    this.repeatYearly = false,
    this.notes,
  }) : id = id ?? const Uuid().v4();

  String get title => name;

  /// Next occurrence of this occasion (today or future).
  DateTime get nextOccurrence {
    if (!repeatYearly) return date;
    final now = DateTime.now();
    DateTime candidate =
        DateTime(now.year, date.month, date.day, date.hour, date.minute);
    if (candidate.isBefore(now)) {
      candidate = DateTime(
          now.year + 1, date.month, date.day, date.hour, date.minute);
    }
    return candidate;
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'type': type,
        'date': date.toIso8601String(),
        'repeatYearly': repeatYearly,
        'notes': notes,
      };

  factory OccasionModel.fromJson(Map<String, dynamic> json) => OccasionModel(
        id: json['id'] as String,
        name: json['name'] as String,
        type: json['type'] as String,
        date: DateTime.parse(json['date'] as String),
        repeatYearly: json['repeatYearly'] as bool? ?? false,
        notes: json['notes'] as String?,
      );

  OccasionModel copyWith({
    String? id,
    String? name,
    String? type,
    DateTime? date,
    bool? repeatYearly,
    String? notes,
  }) =>
      OccasionModel(
        id: id ?? this.id,
        name: name ?? this.name,
        type: type ?? this.type,
        date: date ?? this.date,
        repeatYearly: repeatYearly ?? this.repeatYearly,
        notes: notes ?? this.notes,
      );
}
