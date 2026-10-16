class GiftNoteModel {
  final String id;
  final String content;
  final DateTime dateAdded;
  final bool isIdea;

  GiftNoteModel({
    required this.id,
    required this.content,
    required this.dateAdded,
    this.isIdea = false,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'content': content,
        'dateAdded': dateAdded.toIso8601String(),
        'isIdea': isIdea,
      };

  factory GiftNoteModel.fromJson(Map<dynamic, dynamic> json) => GiftNoteModel(
        id: json['id'] as String,
        content: json['content'] as String,
        dateAdded: DateTime.parse(json['dateAdded'] as String),
        isIdea: json['isIdea'] as bool? ?? false,
      );
}
