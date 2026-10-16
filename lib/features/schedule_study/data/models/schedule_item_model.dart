import 'package:uuid/uuid.dart';

class ScheduleItemModel {
  final String id;
  final String title;
  final String type; // 'lecture', 'study', 'task', 'errand'
  final int weekday; // 1=Monday … 7=Sunday; 0 = non-recurring
  final int startHour;
  final int startMinute;
  final int durationMinutes;
  final bool isRecurring;
  final bool isCompleted;
  final DateTime? completedAt;
  final DateTime? specificDate; // for non-recurring items
  final String? ledgerEntryId; // for undo support
  final int shiftMinutes; // cumulative emergency shift applied

  ScheduleItemModel({
    String? id,
    required this.title,
    required this.type,
    this.weekday = 0,
    required this.startHour,
    required this.startMinute,
    this.durationMinutes = 60,
    this.isRecurring = false,
    this.isCompleted = false,
    this.completedAt,
    this.specificDate,
    this.ledgerEntryId,
    this.shiftMinutes = 0,
  }) : id = id ?? const Uuid().v4();

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'type': type,
        'weekday': weekday,
        'startHour': startHour,
        'startMinute': startMinute,
        'durationMinutes': durationMinutes,
        'isRecurring': isRecurring,
        'isCompleted': isCompleted,
        'completedAt': completedAt?.toIso8601String(),
        'specificDate': specificDate?.toIso8601String(),
        'ledgerEntryId': ledgerEntryId,
        'shiftMinutes': shiftMinutes,
      };

  factory ScheduleItemModel.fromJson(Map<String, dynamic> json) =>
      ScheduleItemModel(
        id: json['id'] as String,
        title: json['title'] as String,
        type: json['type'] as String,
        weekday: json['weekday'] as int? ?? 0,
        startHour: json['startHour'] as int,
        startMinute: json['startMinute'] as int,
        durationMinutes: json['durationMinutes'] as int? ?? 60,
        isRecurring: json['isRecurring'] as bool? ?? false,
        isCompleted: json['isCompleted'] as bool? ?? false,
        completedAt: json['completedAt'] != null
            ? DateTime.parse(json['completedAt'] as String)
            : null,
        specificDate: json['specificDate'] != null
            ? DateTime.parse(json['specificDate'] as String)
            : null,
        ledgerEntryId: json['ledgerEntryId'] as String?,
        shiftMinutes: json['shiftMinutes'] as int? ?? 0,
      );

  ScheduleItemModel copyWith({
    String? id,
    String? title,
    String? type,
    int? weekday,
    int? startHour,
    int? startMinute,
    int? durationMinutes,
    bool? isRecurring,
    bool? isCompleted,
    DateTime? completedAt,
    DateTime? specificDate,
    String? ledgerEntryId,
    int? shiftMinutes,
  }) =>
      ScheduleItemModel(
        id: id ?? this.id,
        title: title ?? this.title,
        type: type ?? this.type,
        weekday: weekday ?? this.weekday,
        startHour: startHour ?? this.startHour,
        startMinute: startMinute ?? this.startMinute,
        durationMinutes: durationMinutes ?? this.durationMinutes,
        isRecurring: isRecurring ?? this.isRecurring,
        isCompleted: isCompleted ?? this.isCompleted,
        completedAt: completedAt ?? this.completedAt,
        specificDate: specificDate ?? this.specificDate,
        ledgerEntryId: ledgerEntryId ?? this.ledgerEntryId,
        shiftMinutes: shiftMinutes ?? this.shiftMinutes,
      );

  /// Effective start time on a given date, accounting for accumulated shift
  DateTime effectiveStartTime(DateTime onDate) {
    final base = DateTime(
      onDate.year,
      onDate.month,
      onDate.day,
      startHour,
      startMinute,
    );
    return base.add(Duration(minutes: shiftMinutes));
  }

  DateTime get startTime {
    final baseDate = specificDate ?? DateTime.now();
    return effectiveStartTime(baseDate);
  }

  DateTime get endTime {
    return startTime.add(Duration(minutes: durationMinutes));
  }
}
