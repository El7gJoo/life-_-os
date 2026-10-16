abstract class SettingsRepository {
  String getLanguageCode();
  Future<void> setLanguageCode(String code);
  int getDayBoundaryHour();
  Future<void> setDayBoundaryHour(int hour);
  int getPrepTimeMinutes();
  Future<void> setPrepTimeMinutes(int minutes);
  String getCurrency();
  Future<void> setCurrency(String currency);
  bool isOnboardingComplete();
  Future<void> setOnboardingComplete(bool value);
  bool isBiometricEnabled();
  Future<void> setBiometricEnabled(bool value);
  double getStartingBalance();
  Future<void> setStartingBalance(double balance);
  double getWeeklyBudget();
  Future<void> setWeeklyBudget(double budget);
  double getMonthlyBudget();
  Future<void> setMonthlyBudget(double budget);
  double getSavingsVault();
  Future<void> setSavingsVault(double amount);
  String? getStreakFreezeWeek();
  Future<void> setStreakFreezeWeek(String weekKey);
  DateTime? getLastBackupDate();
  Future<void> setLastBackupDate(DateTime date);
  Map<String, dynamic> exportAll();
  Future<void> importAll(Map<String, dynamic> data);
}
