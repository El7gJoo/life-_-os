import 'package:equatable/equatable.dart';

class Reward extends Equatable {
  final String id;
  final String title;
  final String description;
  final int pointsCost;
  final String tier; // bronze, silver, gold
  final bool isCustom;

  const Reward({
    required this.id,
    required this.title,
    this.description = '',
    required this.pointsCost,
    required this.tier,
    this.isCustom = false,
  });

  @override
  List<Object?> get props => [id, title, description, pointsCost, tier, isCustom];
}
