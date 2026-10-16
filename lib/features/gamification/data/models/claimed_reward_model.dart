class ClaimedRewardModel {
  final String id;
  final String rewardId;
  final String title;
  final String tier;
  final int pointsSpent;
  final DateTime claimedAt;

  ClaimedRewardModel({
    required this.id,
    required this.rewardId,
    required this.title,
    required this.tier,
    required this.pointsSpent,
    required this.claimedAt,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'rewardId': rewardId,
        'title': title,
        'tier': tier,
        'pointsSpent': pointsSpent,
        'claimedAt': claimedAt.toIso8601String(),
      };

  factory ClaimedRewardModel.fromJson(Map<dynamic, dynamic> json) =>
      ClaimedRewardModel(
        id: json['id'] as String,
        rewardId: json['rewardId'] as String,
        title: json['title'] as String,
        tier: json['tier'] as String,
        pointsSpent: json['pointsSpent'] as int? ?? 0,
        claimedAt: DateTime.parse(json['claimedAt'] as String),
      );
}
