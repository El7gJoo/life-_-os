import 'package:equatable/equatable.dart';

class SettingsState extends Equatable {
  final String languageCode;
  final int dayBoundaryHour;
  final int prepTimeMinutes;
  final String currency;
  final bool isOnboardingComplete;
  final bool isBiometricEnabled;
  final double startingBalance;
  final double weeklyBudget;
  final double monthlyBudget;
  final double savingsVault;
  final String? streakFreezeWeek;
  final DateTime? lastBackupDate;
  final String? geminiApiKey;
  final bool isRequireProof;
  final double? universityLat;
  final double? universityLng;
  final int universityRadius;

  const SettingsState({
    required this.languageCode,
    required this.dayBoundaryHour,
    required this.prepTimeMinutes,
    required this.currency,
    required this.isOnboardingComplete,
    required this.isBiometricEnabled,
    required this.startingBalance,
    required this.weeklyBudget,
    required this.monthlyBudget,
    required this.savingsVault,
    this.streakFreezeWeek,
    this.lastBackupDate,
    this.geminiApiKey,
    this.isRequireProof = false,
    this.universityLat,
    this.universityLng,
    this.universityRadius = 300,
  });

  SettingsState copyWith({
    String? languageCode,
    int? dayBoundaryHour,
    int? prepTimeMinutes,
    String? currency,
    bool? isOnboardingComplete,
    bool? isBiometricEnabled,
    double? startingBalance,
    double? weeklyBudget,
    double? monthlyBudget,
    double? savingsVault,
    String? streakFreezeWeek,
    DateTime? lastBackupDate,
    String? Function()? geminiApiKey,
    bool? isRequireProof,
    double? Function()? universityLat,
    double? Function()? universityLng,
    int? universityRadius,
  }) {
    return SettingsState(
      languageCode: languageCode ?? this.languageCode,
      dayBoundaryHour: dayBoundaryHour ?? this.dayBoundaryHour,
      prepTimeMinutes: prepTimeMinutes ?? this.prepTimeMinutes,
      currency: currency ?? this.currency,
      isOnboardingComplete: isOnboardingComplete ?? this.isOnboardingComplete,
      isBiometricEnabled: isBiometricEnabled ?? this.isBiometricEnabled,
      startingBalance: startingBalance ?? this.startingBalance,
      weeklyBudget: weeklyBudget ?? this.weeklyBudget,
      monthlyBudget: monthlyBudget ?? this.monthlyBudget,
      savingsVault: savingsVault ?? this.savingsVault,
      streakFreezeWeek: streakFreezeWeek ?? this.streakFreezeWeek,
      lastBackupDate: lastBackupDate ?? this.lastBackupDate,
      geminiApiKey: geminiApiKey != null ? geminiApiKey() : this.geminiApiKey,
      isRequireProof: isRequireProof ?? this.isRequireProof,
      universityLat: universityLat != null ? universityLat() : this.universityLat,
      universityLng: universityLng != null ? universityLng() : this.universityLng,
      universityRadius: universityRadius ?? this.universityRadius,
    );
  }

  @override
  List<Object?> get props => [
        languageCode,
        dayBoundaryHour,
        prepTimeMinutes,
        currency,
        isOnboardingComplete,
        isBiometricEnabled,
        startingBalance,
        weeklyBudget,
        monthlyBudget,
        savingsVault,
        streakFreezeWeek,
        lastBackupDate,
        geminiApiKey,
        isRequireProof,
        universityLat,
        universityLng,
        universityRadius,
      ];
}
