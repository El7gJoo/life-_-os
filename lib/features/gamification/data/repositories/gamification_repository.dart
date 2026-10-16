import '../models/claimed_reward_model.dart';
import '../models/ledger_entry_model.dart';
import '../models/reward_model.dart';

abstract class GamificationRepository {
  Future<void> addLedgerEntry(LedgerEntryModel entry);
  List<LedgerEntryModel> getLedgerEntries();
  LedgerEntryModel? getEntryById(String id);
  Future<LedgerEntryModel?> addReversal(String entryId, String reason);

  int getCurrentPoints();
  int getTotalLifetimePoints();
  int getCurrentStreakDays([int dayBoundaryHour = 4]);
  String? getStreakFreezeWeek();
  Future<void> setStreakFreezeWeek(String weekKey);
  Future<void> updateStreak(int days);

  Future<void> addReward(RewardModel reward);
  List<RewardModel> getRewards();
  List<RewardModel> getRewardsByTier(String tier);
  Future<void> updateReward(RewardModel reward);
  Future<void> deleteReward(String id);
  Future<void> seedDefaultRewards();

  Future<void> addClaimedReward(ClaimedRewardModel claimedReward);
  List<ClaimedRewardModel> getClaimedRewards();
  Future<void> deleteClaimedReward(String id);

  Map<String, dynamic> exportAll();
  Future<void> importAll(Map<String, dynamic> data);
}
