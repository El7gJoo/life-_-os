class ScheduleItemModel {
  final String id;
  final String title;
  final String description;
  final DateTime startTime;
  final DateTime endTime;
  final bool isCompleted;
  final String type; // lecture, study, errand, routine
  final int? recurrenceDay; // 1 = Mon, 7 = Sun
  final bool isShifted;

  ScheduleItemModel({
    required this.id,
    required this.title,
    this.description = '',
    required this.startTime,
    required this.endTime,
    this.isCompleted = false,
    this.type = 'routine',
    this.recurrenceDay,
    this.isShifted = false,
  });

  ScheduleItemModel copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? startTime,
    DateTime? endTime,
    bool? isCompleted,
    String? type,
    int? recurrenceDay,
    bool? isShifted,
  }) {
    return ScheduleItemModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      isCompleted: isCompleted ?? this.isCompleted,
      type: type ?? this.type,
      recurrenceDay: recurrenceDay ?? this.recurrenceDay,
      isShifted: isShifted ?? this.isShifted,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'startTime': startTime.toIso8601String(),
        'endTime': endTime.toIso8601String(),
        'isCompleted': isCompleted,
        'type': type,
        'recurrenceDay': recurrenceDay,
        'isShifted': isShifted,
      };

  factory ScheduleItemModel.fromJson(Map<dynamic, dynamic> json) =>
      ScheduleItemModel(
        id: json['id'] as String,
        title: json['title'] as String,
        description: json['description'] as String? ?? '',
        startTime: DateTime.parse(json['startTime'] as String),
        endTime: DateTime.parse(json['endTime'] as String),
        isCompleted: json['isCompleted'] as bool? ?? false,
        type: json['type'] as String? ?? 'routine',
        recurrenceDay: json['recurrenceDay'] as int?,
        isShifted: json['isShifted'] as bool? ?? false,
      );
}
