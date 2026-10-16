import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/settings_repository.dart';
import 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  final SettingsRepository _settingsRepository;

  SettingsCubit(this._settingsRepository)
      : super(SettingsState(
          languageCode: _settingsRepository.getLanguageCode(),
          dayBoundaryHour: _settingsRepository.getDayBoundaryHour(),
          prepTimeMinutes: _settingsRepository.getPrepTimeMinutes(),
          currency: _settingsRepository.getCurrency(),
          isOnboardingComplete: _settingsRepository.isOnboardingComplete(),
          isBiometricEnabled: _settingsRepository.isBiometricEnabled(),
          startingBalance: _settingsRepository.getStartingBalance(),
          weeklyBudget: _settingsRepository.getWeeklyBudget(),
          monthlyBudget: _settingsRepository.getMonthlyBudget(),
          savingsVault: _settingsRepository.getSavingsVault(),
          streakFreezeWeek: _settingsRepository.getStreakFreezeWeek(),
          lastBackupDate: _settingsRepository.getLastBackupDate(),
        ));

  Future<void> setLanguageCode(String code) async {
    await _settingsRepository.setLanguageCode(code);
    emit(state.copyWith(languageCode: code));
  }

  Future<void> toggleLanguage() async {
    final newCode = state.languageCode == 'ar' ? 'en' : 'ar';
    await setLanguageCode(newCode);
  }

  Future<void> setDayBoundaryHour(int hour) async {
    await _settingsRepository.setDayBoundaryHour(hour);
    emit(state.copyWith(dayBoundaryHour: hour));
  }

  Future<void> setPrepTimeMinutes(int minutes) async {
    await _settingsRepository.setPrepTimeMinutes(minutes);
    emit(state.copyWith(prepTimeMinutes: minutes));
  }

  Future<void> setCurrency(String currency) async {
    await _settingsRepository.setCurrency(currency);
    emit(state.copyWith(currency: currency));
  }

  Future<void> setOnboardingComplete(bool value) async {
    await _settingsRepository.setOnboardingComplete(value);
    emit(state.copyWith(isOnboardingComplete: value));
  }

  Future<void> setBiometricEnabled(bool value) async {
    await _settingsRepository.setBiometricEnabled(value);
    emit(state.copyWith(isBiometricEnabled: value));
  }

  Future<void> setStartingBalance(double balance) async {
    await _settingsRepository.setStartingBalance(balance);
    emit(state.copyWith(startingBalance: balance));
  }

  Future<void> setWeeklyBudget(double budget) async {
    await _settingsRepository.setWeeklyBudget(budget);
    emit(state.copyWith(weeklyBudget: budget));
  }

  Future<void> setMonthlyBudget(double budget) async {
    await _settingsRepository.setMonthlyBudget(budget);
    emit(state.copyWith(monthlyBudget: budget));
  }

  Future<void> setSavingsVault(double amount) async {
    await _settingsRepository.setSavingsVault(amount);
    emit(state.copyWith(savingsVault: amount));
  }

  Future<void> setStreakFreezeWeek(String weekKey) async {
    await _settingsRepository.setStreakFreezeWeek(weekKey);
    emit(state.copyWith(streakFreezeWeek: weekKey));
  }

  Future<void> setLastBackupDate(DateTime date) async {
    await _settingsRepository.setLastBackupDate(date);
    emit(state.copyWith(lastBackupDate: date));
  }
}
