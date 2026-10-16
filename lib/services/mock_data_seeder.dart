import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import '../core/constants/app_constants.dart';
import '../features/fiancee/data/models/gift_note_model.dart';
import '../features/fiancee/data/models/occasion_model.dart';
import '../features/fiancee/data/repositories/fiancee_repository.dart';
import '../features/finance/data/models/expense_model.dart';
import '../features/finance/data/repositories/finance_repository.dart';
import '../features/gamification/data/models/claimed_reward_model.dart';
import '../features/gamification/data/models/ledger_entry_model.dart';
import '../features/gamification/data/repositories/gamification_repository.dart';
import '../features/lifestyle/data/models/lifestyle_log_model.dart';
import '../features/lifestyle/data/repositories/lifestyle_repository.dart';
import '../features/schedule_study/data/models/schedule_item_model.dart';
import '../features/schedule_study/data/repositories/schedule_repository.dart';
import '../features/settings_backup/data/repositories/settings_repository.dart';

class MockDataSeeder {
  Future<void> seedAll({
    required GamificationRepository gamificationRepo,
    required ScheduleRepository scheduleRepo,
    required FianceeRepository fianceeRepo,
    required FinanceRepository financeRepo,
    required LifestyleRepository lifestyleRepo,
    SettingsRepository? settingsRepo,
  }) async {
    if (!kDebugMode) return; // Only in debug mode

    final now = DateTime.now();

    if (settingsRepo != null && settingsRepo.getStartingBalance() <= 0) {
      await settingsRepo.setStartingBalance(500.0);
    }

    // 1. Seed Rewards
    await gamificationRepo.seedDefaultRewards();

    // 2. Seed Ledger Entries (past 7 days of continuous streak activity)
    if (gamificationRepo.getLedgerEntries().isEmpty) {
      for (int i = 6; i >= 0; i--) {
        final day = now.subtract(Duration(days: i));
        // Morning study block completed
        await gamificationRepo.addLedgerEntry(LedgerEntryModel(
          id: const Uuid().v4(),
          points: AppConstants.taskCompletionPoints,
          reason: 'Completed morning study routine',
          sourceFeature: 'schedule',
          timestamp: DateTime(day.year, day.month, day.day, 8, 30),
        ));

        // Pomodoro session completed
        await gamificationRepo.addLedgerEntry(LedgerEntryModel(
          id: const Uuid().v4(),
          points: AppConstants.pomodoroPoints,
          reason: 'Deep Work Pomodoro (45m)',
          sourceFeature: 'schedule',
          timestamp: DateTime(day.year, day.month, day.day, 14, 0),
        ));

        // Workout completed
        if (i % 2 == 0) {
          await gamificationRepo.addLedgerEntry(LedgerEntryModel(
            id: const Uuid().v4(),
            points: AppConstants.gymSessionPoints,
            reason: 'Gym Workout Session',
            sourceFeature: 'lifestyle',
            timestamp: DateTime(day.year, day.month, day.day, 17, 30),
          ));
        }

        // Quality time with fiancée
        await gamificationRepo.addLedgerEntry(LedgerEntryModel(
          id: const Uuid().v4(),
          points: AppConstants.qualityTimePoints,
          reason: 'Fiancée Quality Time Call',
          sourceFeature: 'fiancee',
          timestamp: DateTime(day.year, day.month, day.day, 21, 0),
        ));
      }

      // Add a claimed reward in history
      await gamificationRepo.addClaimedReward(ClaimedRewardModel(
        rewardName: 'Specialty Coffee / Favorite Drink',
        tier: 'bronze',
        pointsSpent: 50,
        claimedAt: now.subtract(const Duration(days: 2)),
      ));
    }

    // 3. Seed Schedule Items (weekly lectures + daily tasks)
    if (scheduleRepo.getItems().isEmpty) {
      // Recurring Monday lecture
      await scheduleRepo.addItem(ScheduleItemModel(
        title: 'Distributed Systems Lecture',
        type: 'lecture',
        weekday: 1, // Monday
        startHour: 9,
        startMinute: 0,
        durationMinutes: 120,
        isRecurring: true,
      ));

      // Recurring Wednesday lecture
      await scheduleRepo.addItem(ScheduleItemModel(
        title: 'Software Architecture Lecture',
        type: 'lecture',
        weekday: 3, // Wednesday
        startHour: 10,
        startMinute: 30,
        durationMinutes: 90,
        isRecurring: true,
      ));

      // Recurring Friday review
      await scheduleRepo.addItem(ScheduleItemModel(
        title: 'Weekly Study Review & Pomodoro',
        type: 'study',
        weekday: 5, // Friday
        startHour: 15,
        startMinute: 0,
        durationMinutes: 90,
        isRecurring: true,
      ));

      // Today's specific tasks
      await scheduleRepo.addItem(ScheduleItemModel(
        title: 'Review Machine Learning Notes',
        type: 'study',
        startHour: 11,
        startMinute: 0,
        durationMinutes: 60,
        specificDate: now,
      ));

      await scheduleRepo.addItem(ScheduleItemModel(
        title: 'Pharmacy Errand & Grocery Run',
        type: 'errand',
        startHour: 16,
        startMinute: 30,
        durationMinutes: 45,
        specificDate: now,
      ));
    }

    // 4. Seed Fiancée Occasions & Gift Notes
    if (fianceeRepo.getOccasions().isEmpty) {
      await fianceeRepo.addOccasion(OccasionModel(
        name: 'Her Birthday',
        type: 'birthday',
        date: now.add(const Duration(days: 15)),
        repeatYearly: true,
        notes: 'Loves pastel pink, pearl jewelry, and lavender perfumes',
      ));

      await fianceeRepo.addOccasion(OccasionModel(
        name: 'Engagement Anniversary',
        type: 'anniversary',
        date: now.add(const Duration(days: 45)),
        repeatYearly: true,
        notes: 'Book the rooftop restaurant by the Nile in advance',
      ));

      await fianceeRepo.addOccasion(OccasionModel(
        name: 'Weekend Dinner Date',
        type: 'planned_date',
        date: now.add(const Duration(days: 3)),
        repeatYearly: false,
        notes: 'Try the Italian restaurant in New Cairo',
      ));
    }

    if (fianceeRepo.getGiftNotes().isEmpty) {
      await fianceeRepo.addGiftNote(GiftNoteModel(
        content: 'Mentioned she really wants the new Kindle Paperwhite in Agave Green',
        category: 'gift_idea',
        createdAt: now.subtract(const Duration(days: 5)),
      ));

      await fianceeRepo.addGiftNote(GiftNoteModel(
        content: 'Favorite flowers: White hydrangeas and baby breath',
        category: 'she_likes',
        createdAt: now.subtract(const Duration(days: 10)),
      ));

      await fianceeRepo.addGiftNote(GiftNoteModel(
        content: 'Prefers matcha latte with oat milk over sweet drinks',
        category: 'note',
        createdAt: now.subtract(const Duration(days: 12)),
      ));
    }

    // 5. Seed Finance Expenses (last 3 days)
    if (financeRepo.getExpenses().isEmpty) {
      await financeRepo.addExpense(ExpenseModel(
        amount: 150.0,
        category: 'gas',
        note: 'Octane 95 Full Tank partial',
        timestamp: now.subtract(const Duration(days: 2, hours: 4)),
      ));

      await financeRepo.addExpense(ExpenseModel(
        amount: 85.0,
        category: 'drinks',
        note: 'Iced Flat White & Croissant',
        timestamp: now.subtract(const Duration(days: 1, hours: 6)),
      ));

      await financeRepo.addExpense(ExpenseModel(
        amount: 120.0,
        category: 'food',
        note: 'Healthy lunch bowl',
        timestamp: now.subtract(const Duration(hours: 1)),
      ));
    }

    // 6. Seed Lifestyle Logs (last 3 days)
    if (lifestyleRepo.getLogs().isEmpty) {
      for (int i = 2; i >= 0; i--) {
        final day = now.subtract(Duration(days: i));
        // Water logs
        await lifestyleRepo.addLog(LifestyleLogModel(
          type: 'water',
          timestamp: DateTime(day.year, day.month, day.day, 10, 0),
          value: 4,
        ));
        await lifestyleRepo.addLog(LifestyleLogModel(
          type: 'water',
          timestamp: DateTime(day.year, day.month, day.day, 15, 30),
          value: 3,
        ));

        // Meal logs
        await lifestyleRepo.addLog(LifestyleLogModel(
          type: 'meal',
          timestamp: DateTime(day.year, day.month, day.day, 13, 0),
          notes: 'High-protein grilled chicken salad',
          value: 1,
        ));

        // Workout
        await lifestyleRepo.addLog(LifestyleLogModel(
          type: 'workout',
          timestamp: DateTime(day.year, day.month, day.day, 18, 0),
          notes: 'Push Day: Chest, Shoulders, Triceps',
        ));
      }
    }
  }
}
