import 'package:equatable/equatable.dart';

class StudyLogModel extends Equatable {
  final String id;
  final String subjectId;
  final DateTime date;
  final int minutes;

  const StudyLogModel({
    required this.id,
    required this.subjectId,
    required this.date,
    required this.minutes,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'subjectId': subjectId,
      'date': date.toIso8601String(),
      'minutes': minutes,
    };
  }

  factory StudyLogModel.fromJson(Map<String, dynamic> json) {
    return StudyLogModel(
      id: json['id'] as String,
      subjectId: json['subjectId'] as String,
      date: DateTime.parse(json['date'] as String),
      minutes: json['minutes'] as int? ?? 0,
    );
  }

  @override
  List<Object?> get props => [id, subjectId, date, minutes];
}
