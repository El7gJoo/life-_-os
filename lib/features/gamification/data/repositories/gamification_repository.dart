import '../../domain/entities/ledger_entry.dart';
import '../../domain/entities/reward.dart';
import '../models/claimed_reward_model.dart';

abstract class GamificationRepository {
  List<LedgerEntry> getLedgerEntries();
  Future<void> addLedgerEntry(LedgerEntry entry);
  Future<void> undoLedgerEntry(String entryId);
  int getCurrentPoints();
  int getTotalLifetimePoints();
  int getCurrentStreakDays();
  Future<void> updateStreak(int days);
  List<Reward> getRewards();
  Future<void> saveReward(Reward reward);
  Future<void> deleteReward(String id);
  List<ClaimedRewardModel> getClaimedRewards();
  Future<void> claimReward(ClaimedRewardModel claimedReward);
  Map<String, dynamic> exportAll();
  Future<void> importAll(Map<String, dynamic> data);
}
