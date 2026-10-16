import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/utils/date_utils.dart';
import '../../../gamification/data/models/ledger_entry_model.dart';
import '../../../gamification/data/repositories/gamification_repository.dart';
import '../../../settings_backup/data/repositories/settings_repository.dart';
import '../../data/models/expense_model.dart';
import '../../data/repositories/finance_repository.dart';
import 'finance_state.dart';

class FinanceCubit extends Cubit<FinanceState> {
  final FinanceRepository _financeRepository;
  final GamificationRepository _gamificationRepository;
  final SettingsRepository _settingsRepository;

  FinanceCubit(
    this._financeRepository,
    this._gamificationRepository,
    this._settingsRepository,
  ) : super(FinanceState(
          expenses: _financeRepository.getExpenses(),
          startingBalance: _settingsRepository.getStartingBalance(),
          totalSpentToday: 0.0,
          remainingPocket: 0.0,
          currency: _settingsRepository.getCurrency(),
          weeklyBudget: _settingsRepository.getWeeklyBudget(),
          monthlyBudget: _settingsRepository.getMonthlyBudget(),
        )) {
    _recalculate();
  }

  void refresh() {
    _recalculate();
  }

  void _recalculate() {
    final expenses = _financeRepository.getExpenses();
    final starting = _settingsRepository.getStartingBalance();
    final dayBoundary = _settingsRepository.getDayBoundaryHour();
    final totalSpent = _financeRepository.getTotalSpentToday(dayBoundary);
    final remaining = starting - totalSpent;
    final weeklyBudget = _settingsRepository.getWeeklyBudget();
    final monthlyBudget = _settingsRepository.getMonthlyBudget();

    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final weekStart = DateTime(startOfWeek.year, startOfWeek.month, startOfWeek.day);
    final weekEnd = weekStart.add(const Duration(days: 7));

    final weeklyExpenses = _financeRepository.getExpensesForDateRange(weekStart, weekEnd);
    final weeklySpent = weeklyExpenses.fold(0.0, (sum, e) => sum + e.amount);

    final monthlyExpenses = _financeRepository.getExpensesForMonth(now.year, now.month);
    final monthlySpent = monthlyExpenses.fold(0.0, (sum, e) => sum + e.amount);

    String? alert;
    if (weeklyBudget > 0 && weeklySpent >= weeklyBudget * 0.8) {
      final pct = ((weeklySpent / weeklyBudget) * 100).round();
      alert = 'You have used $pct% of your weekly budget';
    } else if (monthlyBudget > 0 && monthlySpent >= monthlyBudget * 0.8) {
      final pct = ((monthlySpent / monthlyBudget) * 100).round();
      alert = 'You have used $pct% of your monthly budget';
    }

    // Determine rollover eligibility
    RolloverEligibility eligibility;
    if (starting <= 0) {
      eligibility = RolloverEligibility.zeroBalance;
    } else if (remaining < 0) {
      eligibility = RolloverEligibility.budgetExceeded;
    } else {
      final lastRollover = _settingsRepository.getLastRolloverDate();
      if (lastRollover != null && AppDateUtils.isSameLogicalDay(lastRollover, now, dayBoundary)) {
        eligibility = RolloverEligibility.alreadyCompletedToday;
      } else {
        eligibility = RolloverEligibility.eligible;
      }
    }

    emit(state.copyWith(
      expenses: expenses,
      startingBalance: starting,
      totalSpentToday: totalSpent,
      remainingPocket: remaining,
      currency: _settingsRepository.getCurrency(),
      weeklyBudget: weeklyBudget,
      monthlyBudget: monthlyBudget,
      weeklySpent: weeklySpent,
      monthlySpent: monthlySpent,
      budgetAlert: alert,
      rolloverEligibility: eligibility,
    ));
  }

  Future<void> addExpense(ExpenseModel expense) async {
    await _financeRepository.addExpense(expense);
    _recalculate();
  }

  Future<void> deleteExpense(String id) async {
    await _financeRepository.deleteExpense(id);
    _recalculate();
  }

  Future<void> updateStartingBalance(double balance) async {
    await _settingsRepository.setStartingBalance(balance);
    _recalculate();
  }

  Future<void> setWeeklyBudget(double budget) async {
    await _settingsRepository.setWeeklyBudget(budget);
    _recalculate();
  }

  Future<void> setMonthlyBudget(double budget) async {
    await _settingsRepository.setMonthlyBudget(budget);
    _recalculate();
  }

  Future<void> closeDayRollover({required bool rollToSavings}) async {
    if (!state.canRollover) {
      return;
    }

    // Award +15 points
    await _gamificationRepository.addLedgerEntry(LedgerEntryModel(
      points: AppConstants.endOfDayRolloverPoints,
      reason: 'Budget Under Limit Bonus',
      sourceFeature: 'finance',
      timestamp: DateTime.now(),
    ));

    if (rollToSavings) {
      final currentSavings = _settingsRepository.getSavingsVault();
      await _settingsRepository.setSavingsVault(currentSavings + state.remainingPocket);
      await _settingsRepository.setStartingBalance(0.0);
    } else {
      // Roll to tomorrow's starting balance
      await _settingsRepository.setStartingBalance(state.remainingPocket);
    }

    await _settingsRepository.setLastRolloverDate(DateTime.now());
    _recalculate();
  }
}
