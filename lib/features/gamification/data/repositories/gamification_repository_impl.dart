import 'package:hive_flutter/hive_flutter.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/utils/date_utils.dart';
import '../models/claimed_reward_model.dart';
import '../models/ledger_entry_model.dart';
import '../models/reward_model.dart';
import 'gamification_repository.dart';

class GamificationRepositoryImpl implements GamificationRepository {
  final Box ledgerBox;
  final Box rewardsBox;
  final Box claimedRewardsBox;
  final Box settingsBox;

  GamificationRepositoryImpl({
    required this.ledgerBox,
    required this.rewardsBox,
    required this.claimedRewardsBox,
    required this.settingsBox,
  });

  // ---------------------------------------------------------------------------
  // Ledger
  // ---------------------------------------------------------------------------

  @override
  Future<void> addLedgerEntry(LedgerEntryModel entry) async {
    await ledgerBox.put(entry.id, entry.toJson());
  }

  @override
  List<LedgerEntryModel> getLedgerEntries() {
    final list = <LedgerEntryModel>[];
    for (final key in ledgerBox.keys) {
      final value = ledgerBox.get(key);
      if (value is Map) {
        list.add(LedgerEntryModel.fromJson(Map<String, dynamic>.from(value)));
      }
    }
    list.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    return list;
  }

  @override
  LedgerEntryModel? getEntryById(String id) {
    final value = ledgerBox.get(id);
    if (value is Map) {
      return LedgerEntryModel.fromJson(Map<String, dynamic>.from(value));
    }
    return null;
  }

  @override
  Future<LedgerEntryModel?> addReversal(String entryId, String reason) async {
    final original = getEntryById(entryId);
    if (original == null) return null;

    final reversal = LedgerEntryModel(
      points: -original.points,
      reason: reason.isNotEmpty ? reason : 'Reversal of: ${original.reason}',
      sourceFeature: original.sourceFeature,
      timestamp: DateTime.now(),
      isReversal: true,
      reversalOf: original.id,
    );
    await addLedgerEntry(reversal);
    return reversal;
  }

  // ---------------------------------------------------------------------------
  // Points / streak computation
  // ---------------------------------------------------------------------------

  @override
  int getCurrentPoints() {
    var sum = 0;
    for (final entry in getLedgerEntries()) {
      sum += entry.points;
    }
    return sum < 0 ? 0 : sum;
  }

  @override
  int getTotalLifetimePoints() {
    var sum = 0;
    for (final entry in getLedgerEntries()) {
      if (!entry.isReversal && entry.points > 0) sum += entry.points;
    }
    return sum;
  }

  @override
  int getCurrentStreakDays([int dayBoundaryHour = 4]) {
    final entries = getLedgerEntries()
        .where((e) => !e.isReversal && e.points > 0)
        .toList();

    if (entries.isEmpty) return 0;

    final activeDates = <DateTime>{};
    for (final e in entries) {
      activeDates.add(AppDateUtils.getDayStart(e.timestamp, dayBoundaryHour));
    }

    final now = DateTime.now();
    final todayStart = AppDateUtils.getDayStart(now, dayBoundaryHour);
    final yesterdayStart = todayStart.subtract(const Duration(days: 1));

    DateTime checkDate;
    if (activeDates.contains(todayStart)) {
      checkDate = todayStart;
    } else if (activeDates.contains(yesterdayStart)) {
      checkDate = yesterdayStart;
    } else {
      return 0;
    }

    var streak = 0;
    final freezeWeek = getStreakFreezeWeek();
    var usedFreezeInCalculation = false;

    while (true) {
      if (activeDates.contains(checkDate)) {
        streak++;
        checkDate = checkDate.subtract(const Duration(days: 1));
      } else {
        final weekKey = AppDateUtils.getWeekKey(checkDate);
        if (!usedFreezeInCalculation && freezeWeek == weekKey) {
          usedFreezeInCalculation = true;
          checkDate = checkDate.subtract(const Duration(days: 1));
        } else {
          break;
        }
      }
    }

    return streak;
  }

  @override
  String? getStreakFreezeWeek() =>
      settingsBox.get(AppConstants.streakFreezeWeekKey) as String?;

  @override
  Future<void> setStreakFreezeWeek(String weekKey) async =>
      settingsBox.put(AppConstants.streakFreezeWeekKey, weekKey);

  @override
  Future<void> updateStreak(int days) async =>
      settingsBox.put('manual_streak_override', days);

  // ---------------------------------------------------------------------------
  // Rewards
  // ---------------------------------------------------------------------------

  @override
  Future<void> addReward(RewardModel reward) async {
    await rewardsBox.put(reward.id, reward.toJson());
  }

  @override
  List<RewardModel> getRewards() {
    final list = <RewardModel>[];
    for (final key in rewardsBox.keys) {
      final value = rewardsBox.get(key);
      if (value is Map) {
        list.add(RewardModel.fromJson(Map<String, dynamic>.from(value)));
      }
    }
    return list;
  }

  @override
  List<RewardModel> getRewardsByTier(String tier) =>
      getRewards()
          .where((r) => r.tier.toLowerCase() == tier.toLowerCase())
          .toList();

  @override
  Future<void> updateReward(RewardModel reward) async {
    await rewardsBox.put(reward.id, reward.toJson());
  }

  @override
  Future<void> deleteReward(String id) async {
    await rewardsBox.delete(id);
  }

  @override
  Future<void> seedDefaultRewards() async {
    if (rewardsBox.isNotEmpty) return;
    final defaults = [
      RewardModel(id: 'bronze_coffee', name: 'Specialty Coffee / Favorite Drink', tier: 'bronze', isDefault: true),
      RewardModel(id: 'bronze_gaming', name: '30-Minute Guilt-Free Gaming Break', tier: 'bronze', isDefault: true),
      RewardModel(id: 'bronze_snack', name: 'Favorite Snack Treat', tier: 'bronze', isDefault: true),
      RewardModel(id: 'silver_meal', name: 'Favorite Takeout / Cheat Meal', tier: 'silver', isDefault: true),
      RewardModel(id: 'silver_movie', name: 'Movie Night / Extended Free Evening', tier: 'silver', isDefault: true),
      RewardModel(id: 'silver_outing', name: 'Short Leisure Outing', tier: 'silver', isDefault: true),
      RewardModel(id: 'gold_shopping', name: 'Wishlist Item / Personal Treat', tier: 'gold', isDefault: true),
      RewardModel(id: 'gold_day_off', name: 'Complete Day Off from Non-Urgent Tasks', tier: 'gold', isDefault: true),
    ];
    for (final r in defaults) {
      await rewardsBox.put(r.id, r.toJson());
    }
  }

  // ---------------------------------------------------------------------------
  // Claimed rewards
  // ---------------------------------------------------------------------------

  @override
  Future<void> addClaimedReward(ClaimedRewardModel claimedReward) async {
    await claimedRewardsBox.put(claimedReward.id, claimedReward.toJson());
  }

  @override
  List<ClaimedRewardModel> getClaimedRewards() {
    final list = <ClaimedRewardModel>[];
    for (final key in claimedRewardsBox.keys) {
      final value = claimedRewardsBox.get(key);
      if (value is Map) {
        list.add(ClaimedRewardModel.fromJson(Map<String, dynamic>.from(value)));
      }
    }
    list.sort((a, b) => b.claimedAt.compareTo(a.claimedAt));
    return list;
  }

  @override
  Future<void> deleteClaimedReward(String id) async {
    await claimedRewardsBox.delete(id);
  }

  // ---------------------------------------------------------------------------
  // Export / Import
  // ---------------------------------------------------------------------------

  @override
  Map<String, dynamic> exportAll() => {
        'ledger': getLedgerEntries().map((e) => e.toJson()).toList(),
        'rewards': getRewards().map((r) => r.toJson()).toList(),
        'claimedRewards': getClaimedRewards().map((c) => c.toJson()).toList(),
      };

  @override
  Future<void> importAll(Map<String, dynamic> data) async {
    if (data['ledger'] is List) {
      await ledgerBox.clear();
      for (final item in data['ledger'] as List) {
        if (item is Map) {
          final entry = LedgerEntryModel.fromJson(Map<String, dynamic>.from(item));
          await ledgerBox.put(entry.id, entry.toJson());
        }
      }
    }
    if (data['rewards'] is List) {
      await rewardsBox.clear();
      for (final item in data['rewards'] as List) {
        if (item is Map) {
          final reward = RewardModel.fromJson(Map<String, dynamic>.from(item));
          await rewardsBox.put(reward.id, reward.toJson());
        }
      }
    }
    if (data['claimedRewards'] is List) {
      await claimedRewardsBox.clear();
      for (final item in data['claimedRewards'] as List) {
        if (item is Map) {
          final claimed = ClaimedRewardModel.fromJson(Map<String, dynamic>.from(item));
          await claimedRewardsBox.put(claimed.id, claimed.toJson());
        }
      }
    }
  }
}
