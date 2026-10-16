import 'package:uuid/uuid.dart';

class ClaimedRewardModel {
  final String id;
  final String rewardName;
  final String tier;
  final int pointsSpent;
  final DateTime claimedAt;
  final String? ledgerEntryId; // for undo support

  ClaimedRewardModel({
    String? id,
    required this.rewardName,
    required this.tier,
    required this.pointsSpent,
    DateTime? claimedAt,
    this.ledgerEntryId,
  })  : id = id ?? const Uuid().v4(),
        claimedAt = claimedAt ?? DateTime.now();

  Map<String, dynamic> toJson() => {
        'id': id,
        'rewardName': rewardName,
        'tier': tier,
        'pointsSpent': pointsSpent,
        'claimedAt': claimedAt.toIso8601String(),
        'ledgerEntryId': ledgerEntryId,
      };

  factory ClaimedRewardModel.fromJson(Map<String, dynamic> json) =>
      ClaimedRewardModel(
        id: json['id'] as String,
        rewardName: json['rewardName'] as String,
        tier: json['tier'] as String,
        pointsSpent: json['pointsSpent'] as int,
        claimedAt: DateTime.parse(json['claimedAt'] as String),
        ledgerEntryId: json['ledgerEntryId'] as String?,
      );
}
