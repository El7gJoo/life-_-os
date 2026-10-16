import 'package:equatable/equatable.dart';

class ClassSession extends Equatable {
  final String id;
  final String subjectId;
  final String type; // 'lecture', 'section', 'lab'
  final int weekday; // 1..7 (Egyptian week: Sat=6, Sun=7, Mon=1, Tue=2, Wed=3, Thu=4, Fri=5)
  final int startMinutes; // Minutes from midnight
  final int endMinutes; // Minutes from midnight
  final String? location;

  const ClassSession({
    required this.id,
    required this.subjectId,
    required this.type,
    required this.weekday,
    required this.startMinutes,
    required this.endMinutes,
    this.location,
  });

  int get durationMinutes => endMinutes - startMinutes;

  int get startHour => startMinutes ~/ 60;
  int get startMinute => startMinutes % 60;
  int get endHour => endMinutes ~/ 60;
  int get endMinute => endMinutes % 60;

  bool overlapsWith(ClassSession other) {
    if (id == other.id) return false;
    if (weekday != other.weekday) return false;
    return startMinutes < other.endMinutes && other.startMinutes < endMinutes;
  }

  ClassSession copyWith({
    String? id,
    String? subjectId,
    String? type,
    int? weekday,
    int? startMinutes,
    int? endMinutes,
    String? location,
  }) {
    return ClassSession(
      id: id ?? this.id,
      subjectId: subjectId ?? this.subjectId,
      type: type ?? this.type,
      weekday: weekday ?? this.weekday,
      startMinutes: startMinutes ?? this.startMinutes,
      endMinutes: endMinutes ?? this.endMinutes,
      location: location ?? this.location,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'subjectId': subjectId,
      'type': type,
      'weekday': weekday,
      'startMinutes': startMinutes,
      'endMinutes': endMinutes,
      if (location != null) 'location': location,
    };
  }

  factory ClassSession.fromJson(Map<String, dynamic> json) {
    return ClassSession(
      id: json['id'] as String,
      subjectId: json['subjectId'] as String,
      type: json['type'] as String? ?? 'lecture',
      weekday: json['weekday'] as int? ?? 6, // default Saturday
      startMinutes: json['startMinutes'] as int? ?? 540, // 9:00 AM
      endMinutes: json['endMinutes'] as int? ?? 630, // 10:30 AM
      location: json['location'] as String?,
    );
  }

  @override
  List<Object?> get props => [
        id,
        subjectId,
        type,
        weekday,
        startMinutes,
        endMinutes,
        location,
      ];
}
