import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';
import '../../domain/entities/ledger_entry.dart';
import '../../domain/entities/reward.dart';
import '../models/claimed_reward_model.dart';
import '../models/ledger_entry_model.dart';
import '../models/reward_model.dart';
import 'gamification_repository.dart';

class GamificationRepositoryImpl implements GamificationRepository {
  final Box ledgerBox;
  final Box rewardsBox;
  final Box claimedRewardsBox;
  final Box settingsBox;

  static const String streakKey = 'current_streak_days';

  GamificationRepositoryImpl({
    required this.ledgerBox,
    required this.rewardsBox,
    required this.claimedRewardsBox,
    required this.settingsBox,
  }) {
    _seedDefaultRewardsIfEmpty();
  }

  void _seedDefaultRewardsIfEmpty() {
    if (rewardsBox.isEmpty) {
      final defaultRewards = [
        RewardModel(
          id: 'bronze_coffee',
          title: 'Specialty Coffee / Favorite Drink',
          description: 'Enjoy your favorite coffee or drink guilt-free',
          pointsCost: 50,
          tier: 'bronze',
        ),
        RewardModel(
          id: 'bronze_break',
          title: '30-Minute Guilt-Free Gaming / Video Break',
          description: 'Take a relaxing 30-minute entertainment break',
          pointsCost: 50,
          tier: 'bronze',
        ),
        RewardModel(
          id: 'silver_meal',
          title: 'Favorite Meal / Takeout',
          description: 'Order your favorite comfort meal or dine out',
          pointsCost: 100,
          tier: 'silver',
        ),
        RewardModel(
          id: 'silver_movie',
          title: 'Movie Night or Extended Free Time',
          description: 'Watch a movie or indulge in evening hobbies',
          pointsCost: 100,
          tier: 'silver',
        ),
        RewardModel(
          id: 'gold_shopping',
          title: 'Personal Wishlist Item / Gift to Yourself',
          description: 'Buy something from your personal wishlist',
          pointsCost: 200,
          tier: 'gold',
        ),
        RewardModel(
          id: 'gold_day_off',
          title: 'Full Rest & Recreation Day',
          description: 'A completely guilt-free day off from non-urgent tasks',
          pointsCost: 200,
          tier: 'gold',
        ),
      ];

      for (final reward in defaultRewards) {
        rewardsBox.put(reward.id, reward.toJson());
      }
    }
  }

  @override
  List<LedgerEntry> getLedgerEntries() {
    final list = <LedgerEntry>[];
    for (final key in ledgerBox.keys) {
      final data = ledgerBox.get(key);
      if (data is Map) {
        list.add(LedgerEntryModel.fromJson(data).toEntity());
      }
    }
    list.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    return list;
  }

  @override
  Future<void> addLedgerEntry(LedgerEntry entry) async {
    final model = LedgerEntryModel.fromEntity(entry);
    await ledgerBox.put(model.id, model.toJson());
  }

  @override
  Future<void> undoLedgerEntry(String entryId) async {
    final raw = ledgerBox.get(entryId);
    if (raw is Map) {
      final original = LedgerEntryModel.fromJson(raw).toEntity();
      final reversal = LedgerEntry(
        id: const Uuid().v4(),
        points: -original.points,
        reason: 'Undo: ${original.reason}',
        sourceFeature: original.sourceFeature,
        timestamp: DateTime.now(),
        isReversal: true,
        relatedEntryId: original.id,
      );
      await addLedgerEntry(reversal);
    }
  }

  @override
  int getCurrentPoints() {
    var sum = 0;
    for (final key in ledgerBox.keys) {
      final data = ledgerBox.get(key);
      if (data is Map) {
        final pts = data['points'] as int? ?? 0;
        sum += pts;
      }
    }
    return sum < 0 ? 0 : sum;
  }

  @override
  int getTotalLifetimePoints() {
    var sum = 0;
    for (final key in ledgerBox.keys) {
      final data = ledgerBox.get(key);
      if (data is Map) {
        final isReversal = data['isReversal'] as bool? ?? false;
        final pts = data['points'] as int? ?? 0;
        if (!isReversal && pts > 0) {
          sum += pts;
        }
      }
    }
    return sum;
  }

  @override
  int getCurrentStreakDays() {
    return settingsBox.get(streakKey, defaultValue: 0) as int;
  }

  @override
  Future<void> updateStreak(int days) async {
    await settingsBox.put(streakKey, days);
  }

  @override
  List<Reward> getRewards() {
    final list = <Reward>[];
    for (final key in rewardsBox.keys) {
      final data = rewardsBox.get(key);
      if (data is Map) {
        list.add(RewardModel.fromJson(data).toEntity());
      }
    }
    return list;
  }

  @override
  Future<void> saveReward(Reward reward) async {
    final model = RewardModel.fromEntity(reward);
    await rewardsBox.put(model.id, model.toJson());
  }

  @override
  Future<void> deleteReward(String id) async {
    await rewardsBox.delete(id);
  }

  @override
  List<ClaimedRewardModel> getClaimedRewards() {
    final list = <ClaimedRewardModel>[];
    for (final key in claimedRewardsBox.keys) {
      final data = claimedRewardsBox.get(key);
      if (data is Map) {
        list.add(ClaimedRewardModel.fromJson(data));
      }
    }
    list.sort((a, b) => b.claimedAt.compareTo(a.claimedAt));
    return list;
  }

  @override
  Future<void> claimReward(ClaimedRewardModel claimedReward) async {
    await claimedRewardsBox.put(claimedReward.id, claimedReward.toJson());
  }

  @override
  Map<String, dynamic> exportAll() {
    return {
      'ledger': Map<String, dynamic>.from(ledgerBox.toMap().map(
        (k, v) => MapEntry(k.toString(), v),
      )),
      'rewards': Map<String, dynamic>.from(rewardsBox.toMap().map(
        (k, v) => MapEntry(k.toString(), v),
      )),
      'claimedRewards': Map<String, dynamic>.from(claimedRewardsBox.toMap().map(
        (k, v) => MapEntry(k.toString(), v),
      )),
    };
  }

  @override
  Future<void> importAll(Map<String, dynamic> data) async {
    if (data.containsKey('ledger') && data['ledger'] is Map) {
      await ledgerBox.clear();
      await ledgerBox.putAll(Map<String, dynamic>.from(data['ledger'] as Map));
    }
    if (data.containsKey('rewards') && data['rewards'] is Map) {
      await rewardsBox.clear();
      await rewardsBox.putAll(Map<String, dynamic>.from(data['rewards'] as Map));
    }
    if (data.containsKey('claimedRewards') && data['claimedRewards'] is Map) {
      await claimedRewardsBox.clear();
      await claimedRewardsBox.putAll(Map<String, dynamic>.from(data['claimedRewards'] as Map));
    }
  }
}
