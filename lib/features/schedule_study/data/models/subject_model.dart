import 'package:equatable/equatable.dart';

class Subject extends Equatable {
  final String id;
  final String name;
  final int colorValue;
  final DateTime? examDate;

  const Subject({
    required this.id,
    required this.name,
    required this.colorValue,
    this.examDate,
  });

  Subject copyWith({
    String? id,
    String? name,
    int? colorValue,
    DateTime? examDate,
  }) {
    return Subject(
      id: id ?? this.id,
      name: name ?? this.name,
      colorValue: colorValue ?? this.colorValue,
      examDate: examDate ?? this.examDate,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'colorValue': colorValue,
      if (examDate != null) 'examDate': examDate!.toIso8601String(),
    };
  }

  factory Subject.fromJson(Map<String, dynamic> json) {
    return Subject(
      id: json['id'] as String,
      name: json['name'] as String,
      colorValue: json['colorValue'] as int? ?? 0xFF2196F3,
      examDate: json['examDate'] != null
          ? DateTime.tryParse(json['examDate'] as String)
          : null,
    );
  }

  @override
  List<Object?> get props => [id, name, colorValue, examDate];
}
