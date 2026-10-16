import 'dart:math';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_constants.dart';
import '../../data/models/claimed_reward_model.dart';
import '../../data/models/ledger_entry_model.dart';
import '../../data/models/reward_model.dart';
import '../../data/repositories/gamification_repository.dart';
import 'gamification_state.dart';

class GamificationCubit extends Cubit<GamificationState> {
  final GamificationRepository _repository;

  GamificationCubit(this._repository)
      : super(GamificationState(
          currentPoints: _repository.getCurrentPoints(),
          totalLifetimePoints: _repository.getTotalLifetimePoints(),
          currentStreakDays: _repository.getCurrentStreakDays(),
          activeMultiplier: _calculateMultiplier(_repository.getCurrentStreakDays()),
          rewards: _repository.getRewards(),
          claimedRewards: _repository.getClaimedRewards(),
          ledgerEntries: _repository.getLedgerEntries(),
        ));

  static double _calculateMultiplier(int streak) {
    if (streak >= 7) return 2.0;
    if (streak >= AppConstants.streakMultiplierThreshold) return 1.5;
    return 1.0;
  }

  void refresh() {
    final streak = _repository.getCurrentStreakDays();
    emit(state.copyWith(
      currentPoints: _repository.getCurrentPoints(),
      totalLifetimePoints: _repository.getTotalLifetimePoints(),
      currentStreakDays: streak,
      activeMultiplier: _calculateMultiplier(streak),
      rewards: _repository.getRewards(),
      claimedRewards: _repository.getClaimedRewards(),
      ledgerEntries: _repository.getLedgerEntries(),
    ));
  }

  Future<void> awardPoints(int basePoints, String reason, String sourceFeature) async {
    final effectivePoints = (basePoints * state.activeMultiplier).round();
    final entry = LedgerEntryModel(
      points: effectivePoints,
      reason: state.activeMultiplier > 1.0 ? '$reason (${state.activeMultiplier}x)' : reason,
      sourceFeature: sourceFeature,
      timestamp: DateTime.now(),
    );
    await _repository.addLedgerEntry(entry);
    refresh();
  }

  Future<void> deductPoints(int points, String reason, String sourceFeature) async {
    final entry = LedgerEntryModel(
      points: -points.abs(),
      reason: reason,
      sourceFeature: sourceFeature,
      timestamp: DateTime.now(),
    );
    await _repository.addLedgerEntry(entry);
    refresh();
  }

  Future<void> undo(String entryId) async {
    await _repository.addReversal(entryId, 'Undo');
    refresh();
  }

  Future<RewardModel?> redeemTier(String tier) async {
    int cost;
    switch (tier.toLowerCase()) {
      case 'gold':
        cost = AppConstants.goldPointsCost;
        break;
      case 'silver':
        cost = AppConstants.silverPointsCost;
        break;
      case 'bronze':
      default:
        cost = AppConstants.bronzePointsCost;
        break;
    }

    if (state.currentPoints < cost) {
      return null;
    }

    final tierRewards = _repository.getRewardsByTier(tier);
    if (tierRewards.isEmpty) {
      return null;
    }

    final selected = tierRewards[Random().nextInt(tierRewards.length)];

    final ledgerEntry = LedgerEntryModel(
      points: -cost,
      reason: 'Redeemed ${selected.name} ($tier)',
      sourceFeature: 'gamification',
      timestamp: DateTime.now(),
    );
    await _repository.addLedgerEntry(ledgerEntry);

    final claimed = ClaimedRewardModel(
      rewardName: selected.name,
      tier: tier,
      pointsSpent: cost,
      claimedAt: DateTime.now(),
      ledgerEntryId: ledgerEntry.id,
    );
    await _repository.addClaimedReward(claimed);

    emit(state.copyWith(
      lastUnlockedReward: selected,
      claimedRewards: _repository.getClaimedRewards(),
      currentPoints: _repository.getCurrentPoints(),
      ledgerEntries: _repository.getLedgerEntries(),
    ));

    return selected;
  }

  void clearLastUnlockedReward() {
    emit(state.copyWith(clearLastUnlockedReward: true));
  }

  Future<void> addReward(RewardModel reward) async {
    await _repository.addReward(reward);
    refresh();
  }

  Future<void> deleteReward(String id) async {
    await _repository.deleteReward(id);
    refresh();
  }

  Future<void> updateStreak(int days) async {
    await _repository.updateStreak(days);
    refresh();
  }
}
