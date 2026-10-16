import 'package:uuid/uuid.dart';
import '../core/constants/app_constants.dart';
import '../core/di/injection.dart';
import '../features/fiancee/data/models/occasion_model.dart';
import '../features/fiancee/data/repositories/fiancee_repository.dart';
import '../features/finance/data/models/expense_model.dart';
import '../features/finance/data/repositories/finance_repository.dart';
import '../features/gamification/data/repositories/gamification_repository.dart';
import '../features/gamification/domain/entities/ledger_entry.dart';
import '../features/lifestyle/data/models/lifestyle_log_model.dart';
import '../features/lifestyle/data/repositories/lifestyle_repository.dart';
import '../features/schedule_study/data/models/schedule_item_model.dart';
import '../features/schedule_study/data/repositories/schedule_repository.dart';
import '../features/settings_backup/data/repositories/settings_repository.dart';

class MockDataSeeder {
  Future<void> seedAll() async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    // 1. Settings
    final settingsRepo = getIt<SettingsRepository>();
    await settingsRepo.setStartingBalance(500.0);
    await settingsRepo.setWeeklyBudget(2000.0);
    await settingsRepo.setMonthlyBudget(8000.0);

    // 2. Schedule
    final scheduleRepo = getIt<ScheduleRepository>();
    if (scheduleRepo.getItems().isEmpty) {
      await scheduleRepo.addItem(ScheduleItemModel(
        id: const Uuid().v4(),
        title: 'Computer Architecture Lecture',
        description: 'Room 302, Hall A',
        startTime: today.add(const Duration(hours: 9)),
        endTime: today.add(const Duration(hours: 11)),
        type: 'lecture',
      ));
      await scheduleRepo.addItem(ScheduleItemModel(
        id: const Uuid().v4(),
        title: 'Deep Learning Study Block',
        description: 'Transformers & Attention Mechanisms',
        startTime: today.add(const Duration(hours: 14)),
        endTime: today.add(const Duration(hours: 16)),
        type: 'study',
      ));
      await scheduleRepo.addItem(ScheduleItemModel(
        id: const Uuid().v4(),
        title: 'Pick up groceries',
        description: 'Supermarket essentials',
        startTime: today.add(const Duration(hours: 17)),
        endTime: today.add(const Duration(hours: 18)),
        type: 'errand',
      ));
    }

    // 3. Fiancee Occasions
    final fianceeRepo = getIt<FianceeRepository>();
    if (fianceeRepo.getOccasions().isEmpty) {
      await fianceeRepo.addOccasion(OccasionModel(
        id: const Uuid().v4(),
        title: 'Engagement Anniversary',
        date: today.add(const Duration(days: 14)),
        type: 'anniversary',
        repeatsYearly: true,
      ));
      await fianceeRepo.addOccasion(OccasionModel(
        id: const Uuid().v4(),
        title: 'Her Birthday',
        date: today.add(const Duration(days: 45)),
        type: 'birthday',
        repeatsYearly: true,
      ));
    }

    // 4. Finance Expenses
    final financeRepo = getIt<FinanceRepository>();
    if (financeRepo.getExpenses().isEmpty) {
      await financeRepo.addExpense(ExpenseModel(
        id: const Uuid().v4(),
        amount: 85.0,
        category: 'drinks',
        note: 'Iced Latte at campus café',
        timestamp: today.add(const Duration(hours: 10, minutes: 30)),
      ));
      await financeRepo.addExpense(ExpenseModel(
        id: const Uuid().v4(),
        amount: 140.0,
        category: 'food',
        note: 'Lunch at University Mall',
        timestamp: today.add(const Duration(hours: 12, minutes: 45)),
      ));
    }

    // 5. Gamification Points Ledger
    final gamificationRepo = getIt<GamificationRepository>();
    if (gamificationRepo.getLedgerEntries().isEmpty) {
      await gamificationRepo.addLedgerEntry(LedgerEntry(
        id: const Uuid().v4(),
        points: AppConstants.taskCompletionPoints,
        reason: 'Completed morning study routine',
        sourceFeature: 'schedule',
        timestamp: today.subtract(const Duration(days: 1, hours: 2)),
      ));
      await gamificationRepo.addLedgerEntry(LedgerEntry(
        id: const Uuid().v4(),
        points: AppConstants.pomodoroPoints,
        reason: 'Completed Pomodoro session',
        sourceFeature: 'schedule',
        timestamp: today.subtract(const Duration(hours: 3)),
      ));
      await gamificationRepo.addLedgerEntry(LedgerEntry(
        id: const Uuid().v4(),
        points: AppConstants.gymSessionPoints,
        reason: 'Gym Workout Session',
        sourceFeature: 'lifestyle',
        timestamp: today.subtract(const Duration(hours: 1)),
      ));
      await gamificationRepo.updateStreak(4);
    }

    // 6. Lifestyle Log
    final lifestyleRepo = getIt<LifestyleRepository>();
    final todayKey = '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';
    final existingLog = lifestyleRepo.getLogForDate(todayKey);
    if (existingLog.waterCups == 0) {
      await lifestyleRepo.saveLog(LifestyleLogModel(
        date: todayKey,
        waterCups: 4,
        healthyMeals: 2,
        gymSession: true,
        sleepOnTime: true,
        wakeOnTime: true,
      ));
    }
  }
}
