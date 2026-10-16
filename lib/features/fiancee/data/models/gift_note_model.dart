import 'package:uuid/uuid.dart';

class GiftNoteModel {
  final String id;
  final String content;
  final String category; // 'gift_idea', 'she_likes', 'note'
  final DateTime createdAt;

  GiftNoteModel({
    String? id,
    required this.content,
    required this.category,
    DateTime? createdAt,
  })  : id = id ?? const Uuid().v4(),
        createdAt = createdAt ?? DateTime.now();

  DateTime get dateAdded => createdAt;

  Map<String, dynamic> toJson() => {
        'id': id,
        'content': content,
        'category': category,
        'createdAt': createdAt.toIso8601String(),
      };

  factory GiftNoteModel.fromJson(Map<String, dynamic> json) => GiftNoteModel(
        id: json['id'] as String,
        content: json['content'] as String,
        category: json['category'] as String,
        createdAt: DateTime.parse(json['createdAt'] as String),
      );

  GiftNoteModel copyWith({
    String? id,
    String? content,
    String? category,
    DateTime? createdAt,
  }) =>
      GiftNoteModel(
        id: id ?? this.id,
        content: content ?? this.content,
        category: category ?? this.category,
        createdAt: createdAt ?? this.createdAt,
      );
}
