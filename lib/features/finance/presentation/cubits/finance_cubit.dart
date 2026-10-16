import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_constants.dart';
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
        )) {
    _recalculate();
  }

  void _recalculate() {
    final expenses = _financeRepository.getExpenses();
    final starting = _settingsRepository.getStartingBalance();
    final dayBoundary = _settingsRepository.getDayBoundaryHour();
    final totalSpent = _financeRepository.getTotalSpentToday(dayBoundary);
    final remaining = starting - totalSpent;

    emit(state.copyWith(
      expenses: expenses,
      startingBalance: starting,
      totalSpentToday: totalSpent,
      remainingPocket: remaining,
      currency: _settingsRepository.getCurrency(),
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

  Future<void> closeDayRollover({required bool rollToSavings}) async {
    if (state.remainingPocket >= 0) {
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
      _recalculate();
    }
  }
}
