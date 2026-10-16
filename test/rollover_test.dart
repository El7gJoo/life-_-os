import 'package:flutter_test/flutter_test.dart';
import 'package:life_os/core/models/result.dart';
import 'package:life_os/features/finance/data/models/expense_model.dart';
import 'package:life_os/features/finance/data/repositories/finance_repository.dart';
import 'package:life_os/features/finance/presentation/cubits/finance_cubit.dart';
import 'package:life_os/features/finance/presentation/cubits/finance_state.dart';
import 'package:life_os/features/gamification/data/models/ledger_entry_model.dart';
import 'package:life_os/features/gamification/data/models/reward_model.dart';
import 'package:life_os/features/gamification/data/repositories/gamification_repository.dart';
import 'package:life_os/features/settings_backup/data/repositories/settings_repository.dart';

class MockFinanceRepository extends Fake implements FinanceRepository {
  List<ExpenseModel> expenses = [];

  @override
  List<ExpenseModel> getExpenses() => expenses;

  @override
  Future<void> addExpense(ExpenseModel expense) async {
    expenses.add(expense);
  }

  @override
  Future<void> deleteExpense(String id) async {
    expenses.removeWhere((e) => e.id == id);
  }

  @override
  double getTotalSpentToday([int dayBoundaryHour = 4]) {
    return expenses.fold(0.0, (sum, e) => sum + e.amount);
  }

  @override
  List<ExpenseModel> getExpensesForDateRange(DateTime start, DateTime end) => expenses;

  @override
  List<ExpenseModel> getExpensesForMonth(int year, int month) => expenses;
}

class MockGamificationRepository extends Fake implements GamificationRepository {
  List<LedgerEntryModel> ledger = [];

  @override
  List<LedgerEntryModel> getLedgerEntries() => ledger;

  @override
  Future<void> addLedgerEntry(LedgerEntryModel entry) async {
    ledger.add(entry);
  }

  @override
  int getCurrentPoints() => ledger.fold(0, (sum, e) => sum + e.points);

  @override
  int getCurrentStreakDays([int dayBoundaryHour = 4]) => 0;

  @override
  Future<void> updateStreak(int days) async {}

  @override
  List<RewardModel> getRewards() => [];

  @override
  Future<void> addReward(RewardModel reward) async {}

  @override
  Future<void> deleteReward(String id) async {}

  @override
  Future<void> updateReward(RewardModel reward) async {}
}

class MockSettingsRepository extends Fake implements SettingsRepository {
  double startingBalance = 200.0;
  DateTime? lastRolloverDate;
  int dayBoundaryHour = 4;
  double weeklyBudget = 0.0;
  double monthlyBudget = 0.0;
  String currency = 'EGP';
  double savingsVault = 0.0;

  @override
  double getStartingBalance() => startingBalance;

  @override
  Future<Result<void>> setStartingBalance(double balance) async {
    startingBalance = balance;
    return const Success(null);
  }

  @override
  DateTime? getLastRolloverDate() => lastRolloverDate;

  @override
  Future<Result<void>> setLastRolloverDate(DateTime date) async {
    lastRolloverDate = date;
    return const Success(null);
  }

  @override
  int getDayBoundaryHour() => dayBoundaryHour;

  @override
  Future<Result<void>> setDayBoundaryHour(int hour) async {
    dayBoundaryHour = hour;
    return const Success(null);
  }

  @override
  double getWeeklyBudget() => weeklyBudget;

  @override
  Future<Result<void>> setWeeklyBudget(double budget) async {
    weeklyBudget = budget;
    return const Success(null);
  }

  @override
  double getMonthlyBudget() => monthlyBudget;

  @override
  Future<Result<void>> setMonthlyBudget(double budget) async {
    monthlyBudget = budget;
    return const Success(null);
  }

  @override
  String getCurrency() => currency;

  @override
  Future<Result<void>> setCurrency(String c) async {
    currency = c;
    return const Success(null);
  }

  @override
  double getSavingsVault() => savingsVault;

  @override
  Future<Result<void>> setSavingsVault(double amount) async {
    savingsVault = amount;
    return const Success(null);
  }
}

void main() {
  late MockFinanceRepository financeRepo;
  late MockGamificationRepository gamificationRepo;
  late MockSettingsRepository settingsRepo;

  setUp(() {
    financeRepo = MockFinanceRepository();
    gamificationRepo = MockGamificationRepository();
    settingsRepo = MockSettingsRepository();
  });

  group('End-of-Day Rollover Unit Tests', () {
    test('Rollover disabled when starting balance is zero', () {
      settingsRepo.startingBalance = 0.0;
      final cubit = FinanceCubit(financeRepo, gamificationRepo, settingsRepo);

      expect(cubit.state.startingBalance, 0.0);
      expect(cubit.state.canRollover, isFalse);
      expect(cubit.state.rolloverEligibility, RolloverEligibility.zeroBalance);

      cubit.close();
    });

    test('Rollover disabled when daily budget is exceeded (negative remaining pocket)', () {
      settingsRepo.startingBalance = 100.0;
      financeRepo.expenses = [
        ExpenseModel(id: '1', amount: 120.0, category: 'food', timestamp: DateTime.now()),
      ];
      final cubit = FinanceCubit(financeRepo, gamificationRepo, settingsRepo);

      expect(cubit.state.remainingPocket, -20.0);
      expect(cubit.state.canRollover, isFalse);
      expect(cubit.state.rolloverEligibility, RolloverEligibility.budgetExceeded);

      cubit.close();
    });

    test('Rollover disabled when already completed today (same logical day boundary)', () {
      settingsRepo.startingBalance = 200.0;
      // Rollover already completed 1 hour ago
      settingsRepo.lastRolloverDate = DateTime.now().subtract(const Duration(hours: 1));

      final cubit = FinanceCubit(financeRepo, gamificationRepo, settingsRepo);

      expect(cubit.state.canRollover, isFalse);
      expect(cubit.state.rolloverEligibility, RolloverEligibility.alreadyCompletedToday);

      cubit.close();
    });

    test('Rollover enabled when positive balance, within budget, and not completed today', () async {
      settingsRepo.startingBalance = 300.0;
      settingsRepo.lastRolloverDate = DateTime.now().subtract(const Duration(days: 2)); // completed 2 days ago
      financeRepo.expenses = [
        ExpenseModel(id: '1', amount: 50.0, category: 'coffee', timestamp: DateTime.now()),
      ];

      final cubit = FinanceCubit(financeRepo, gamificationRepo, settingsRepo);

      expect(cubit.state.remainingPocket, 250.0);
      expect(cubit.state.canRollover, isTrue);
      expect(cubit.state.rolloverEligibility, RolloverEligibility.eligible);

      // Perform rollover
      await cubit.closeDayRollover(rollToSavings: false);

      // 1. Should have awarded +15 points to Gamification Ledger
      expect(gamificationRepo.ledger.length, 1);
      expect(gamificationRepo.ledger.first.points, 15);
      expect(gamificationRepo.ledger.first.sourceFeature, 'finance');

      // 2. Settings should have updated lastRolloverDate
      expect(settingsRepo.lastRolloverDate, isNotNull);

      // 3. Eligibility should now be alreadyCompletedToday
      expect(cubit.state.canRollover, isFalse);
      expect(cubit.state.rolloverEligibility, RolloverEligibility.alreadyCompletedToday);

      cubit.close();
    });
  });
}
