import 'package:uuid/uuid.dart';

class RewardModel {
  final String id;
  final String name;
  final String tier; // 'bronze', 'silver', 'gold'
  final bool isDefault;

  RewardModel({
    String? id,
    required this.name,
    required this.tier,
    this.isDefault = false,
  }) : id = id ?? const Uuid().v4();

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'tier': tier,
        'isDefault': isDefault,
      };

  factory RewardModel.fromJson(Map<String, dynamic> json) => RewardModel(
        id: json['id'] as String,
        name: json['name'] as String,
        tier: json['tier'] as String,
        isDefault: json['isDefault'] as bool? ?? false,
      );

  RewardModel copyWith({
    String? id,
    String? name,
    String? tier,
    bool? isDefault,
  }) =>
      RewardModel(
        id: id ?? this.id,
        name: name ?? this.name,
        tier: tier ?? this.tier,
        isDefault: isDefault ?? this.isDefault,
      );
}
