import 'dart:math';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/constants/app_constants.dart';
import '../../data/models/claimed_reward_model.dart';
import '../../data/repositories/gamification_repository.dart';
import '../../domain/entities/ledger_entry.dart';
import '../../domain/entities/reward.dart';
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
    final entry = LedgerEntry(
      id: const Uuid().v4(),
      points: effectivePoints,
      reason: state.activeMultiplier > 1.0 ? '$reason (${state.activeMultiplier}x)' : reason,
      sourceFeature: sourceFeature,
      timestamp: DateTime.now(),
    );
    await _repository.addLedgerEntry(entry);
    refresh();
  }

  Future<void> deductPoints(int points, String reason, String sourceFeature) async {
    final entry = LedgerEntry(
      id: const Uuid().v4(),
      points: -points.abs(),
      reason: reason,
      sourceFeature: sourceFeature,
      timestamp: DateTime.now(),
    );
    await _repository.addLedgerEntry(entry);
    refresh();
  }

  Future<void> undo(String entryId) async {
    await _repository.undoLedgerEntry(entryId);
    refresh();
  }

  Future<Reward?> redeemTier(String tier) async {
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

    final tierRewards = state.rewards.where((r) => r.tier.toLowerCase() == tier.toLowerCase()).toList();
    if (tierRewards.isEmpty) {
      return null;
    }

    final selected = tierRewards[Random().nextInt(tierRewards.length)];

    await deductPoints(cost, 'Redeemed ${selected.title} ($tier)', 'gamification');

    final claimed = ClaimedRewardModel(
      id: const Uuid().v4(),
      rewardId: selected.id,
      title: selected.title,
      tier: tier,
      pointsSpent: cost,
      claimedAt: DateTime.now(),
    );
    await _repository.claimReward(claimed);

    emit(state.copyWith(
      lastUnlockedReward: selected,
      claimedRewards: _repository.getClaimedRewards(),
    ));

    return selected;
  }

  void clearLastUnlockedReward() {
    emit(state.copyWith(clearLastUnlockedReward: true));
  }

  Future<void> addReward(Reward reward) async {
    await _repository.saveReward(reward);
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
