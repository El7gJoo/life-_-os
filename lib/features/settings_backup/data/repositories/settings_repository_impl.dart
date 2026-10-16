import 'package:hive_flutter/hive_flutter.dart';
import '../../../../core/constants/app_constants.dart';
import 'settings_repository.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  final Box _box;
  SettingsRepositoryImpl(this._box);

  @override
  String getLanguageCode() =>
      _box.get(AppConstants.languageKey, defaultValue: AppConstants.defaultLocale) as String;

  @override
  Future<void> setLanguageCode(String code) => _box.put(AppConstants.languageKey, code);

  @override
  int getDayBoundaryHour() =>
      _box.get(AppConstants.dayBoundaryKey, defaultValue: AppConstants.defaultDayBoundaryHour) as int;

  @override
  Future<void> setDayBoundaryHour(int hour) => _box.put(AppConstants.dayBoundaryKey, hour);

  @override
  int getPrepTimeMinutes() =>
      _box.get(AppConstants.prepTimeKey, defaultValue: AppConstants.defaultPrepTimeMinutes) as int;

  @override
  Future<void> setPrepTimeMinutes(int minutes) => _box.put(AppConstants.prepTimeKey, minutes);

  @override
  String getCurrency() =>
      _box.get(AppConstants.currencyKey, defaultValue: AppConstants.defaultCurrency) as String;

  @override
  Future<void> setCurrency(String currency) => _box.put(AppConstants.currencyKey, currency);

  @override
  bool isOnboardingComplete() =>
      _box.get(AppConstants.onboardingCompleteKey, defaultValue: false) as bool;

  @override
  Future<void> setOnboardingComplete(bool value) =>
      _box.put(AppConstants.onboardingCompleteKey, value);

  @override
  bool isBiometricEnabled() =>
      _box.get(AppConstants.biometricEnabledKey, defaultValue: false) as bool;

  @override
  Future<void> setBiometricEnabled(bool value) =>
      _box.put(AppConstants.biometricEnabledKey, value);

  @override
  double getStartingBalance() =>
      (_box.get(AppConstants.startingBalanceKey, defaultValue: 0.0) as num).toDouble();

  @override
  Future<void> setStartingBalance(double balance) =>
      _box.put(AppConstants.startingBalanceKey, balance);

  @override
  double getWeeklyBudget() =>
      (_box.get(AppConstants.weeklyBudgetKey, defaultValue: 0.0) as num).toDouble();

  @override
  Future<void> setWeeklyBudget(double budget) => _box.put(AppConstants.weeklyBudgetKey, budget);

  @override
  double getMonthlyBudget() =>
      (_box.get(AppConstants.monthlyBudgetKey, defaultValue: 0.0) as num).toDouble();

  @override
  Future<void> setMonthlyBudget(double budget) => _box.put(AppConstants.monthlyBudgetKey, budget);

  @override
  double getSavingsVault() =>
      (_box.get(AppConstants.savingsVaultKey, defaultValue: 0.0) as num).toDouble();

  @override
  Future<void> setSavingsVault(double amount) => _box.put(AppConstants.savingsVaultKey, amount);

  @override
  String? getStreakFreezeWeek() => _box.get(AppConstants.streakFreezeWeekKey) as String?;

  @override
  Future<void> setStreakFreezeWeek(String weekKey) =>
      _box.put(AppConstants.streakFreezeWeekKey, weekKey);

  @override
  DateTime? getLastBackupDate() {
    final stored = _box.get(AppConstants.lastBackupKey) as String?;
    if (stored == null) return null;
    return DateTime.tryParse(stored);
  }

  @override
  Future<void> setLastBackupDate(DateTime date) =>
      _box.put(AppConstants.lastBackupKey, date.toIso8601String());

  @override
  Map<String, dynamic> exportAll() => Map<String, dynamic>.from(_box.toMap().map(
    (k, v) => MapEntry(k.toString(), v),
  ));

  @override
  Future<void> importAll(Map<String, dynamic> data) async {
    await _box.clear();
    await _box.putAll(data);
  }
}
