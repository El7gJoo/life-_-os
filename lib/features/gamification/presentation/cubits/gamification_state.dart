import 'package:equatable/equatable.dart';
import '../../data/models/claimed_reward_model.dart';
import '../../domain/entities/ledger_entry.dart';
import '../../domain/entities/reward.dart';

class GamificationState extends Equatable {
  final int currentPoints;
  final int totalLifetimePoints;
  final int currentStreakDays;
  final double activeMultiplier;
  final List<Reward> rewards;
  final List<ClaimedRewardModel> claimedRewards;
  final List<LedgerEntry> ledgerEntries;
  final Reward? lastUnlockedReward;

  const GamificationState({
    required this.currentPoints,
    required this.totalLifetimePoints,
    required this.currentStreakDays,
    required this.activeMultiplier,
    required this.rewards,
    required this.claimedRewards,
    required this.ledgerEntries,
    this.lastUnlockedReward,
  });

  GamificationState copyWith({
    int? currentPoints,
    int? totalLifetimePoints,
    int? currentStreakDays,
    double? activeMultiplier,
    List<Reward>? rewards,
    List<ClaimedRewardModel>? claimedRewards,
    List<LedgerEntry>? ledgerEntries,
    Reward? lastUnlockedReward,
    bool clearLastUnlockedReward = false,
  }) {
    return GamificationState(
      currentPoints: currentPoints ?? this.currentPoints,
      totalLifetimePoints: totalLifetimePoints ?? this.totalLifetimePoints,
      currentStreakDays: currentStreakDays ?? this.currentStreakDays,
      activeMultiplier: activeMultiplier ?? this.activeMultiplier,
      rewards: rewards ?? this.rewards,
      claimedRewards: claimedRewards ?? this.claimedRewards,
      ledgerEntries: ledgerEntries ?? this.ledgerEntries,
      lastUnlockedReward: clearLastUnlockedReward
          ? null
          : (lastUnlockedReward ?? this.lastUnlockedReward),
    );
  }

  @override
  List<Object?> get props => [
        currentPoints,
        totalLifetimePoints,
        currentStreakDays,
        activeMultiplier,
        rewards,
        claimedRewards,
        ledgerEntries,
        lastUnlockedReward,
      ];
}
