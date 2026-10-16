class OccasionModel {
  final String id;
  final String title;
  final DateTime date;
  final String type; // birthday, anniversary, plannedDate, custom
  final bool repeatsYearly;

  OccasionModel({
    required this.id,
    required this.title,
    required this.date,
    this.type = 'custom',
    this.repeatsYearly = false,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'date': date.toIso8601String(),
        'type': type,
        'repeatsYearly': repeatsYearly,
      };

  factory OccasionModel.fromJson(Map<dynamic, dynamic> json) => OccasionModel(
        id: json['id'] as String,
        title: json['title'] as String,
        date: DateTime.parse(json['date'] as String),
        type: json['type'] as String? ?? 'custom',
        repeatsYearly: json['repeatsYearly'] as bool? ?? false,
      );
}
