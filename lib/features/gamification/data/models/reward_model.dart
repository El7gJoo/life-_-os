import '../../domain/entities/reward.dart';

class RewardModel {
  final String id;
  final String title;
  final String description;
  final int pointsCost;
  final String tier;
  final bool isCustom;

  RewardModel({
    required this.id,
    required this.title,
    this.description = '',
    required this.pointsCost,
    required this.tier,
    this.isCustom = false,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'pointsCost': pointsCost,
        'tier': tier,
        'isCustom': isCustom,
      };

  factory RewardModel.fromJson(Map<dynamic, dynamic> json) => RewardModel(
        id: json['id'] as String,
        title: json['title'] as String,
        description: json['description'] as String? ?? '',
        pointsCost: json['pointsCost'] as int? ?? 0,
        tier: json['tier'] as String? ?? 'bronze',
        isCustom: json['isCustom'] as bool? ?? false,
      );

  Reward toEntity() => Reward(
        id: id,
        title: title,
        description: description,
        pointsCost: pointsCost,
        tier: tier,
        isCustom: isCustom,
      );

  factory RewardModel.fromEntity(Reward entity) => RewardModel(
        id: entity.id,
        title: entity.title,
        description: entity.description,
        pointsCost: entity.pointsCost,
        tier: entity.tier,
        isCustom: entity.isCustom,
      );
}
