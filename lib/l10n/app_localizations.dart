import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en')
  ];

  String get appTitle;
  String get dashboard;
  String get gamification;
  String get schedule;
  String get fiancee;
  String get finance;
  String get lifestyle;
  String get stats;
  String get settings;
  String get onboarding;
  String get points;
  String get streak;
  String streakDays(int count);
  String get currentPoints;
  String get totalPoints;
  String get bronze;
  String get silver;
  String get gold;
  String get redeem;
  String get redeemReward;
  String get rewardUnlocked;
  String get congratulations;
  String get youEarned;
  String get close;
  String get cancel;
  String get save;
  String get delete;
  String get edit;
  String get add;
  String get done;
  String get undo;
  String get snooze;
  String get today;
  String get tomorrow;
  String get yesterday;
  String get morning;
  String get evening;
  String get goodMorning;
  String get morningCheckIn;
  String get morningCheckInMessage;
  String get addTask;
  String get taskName;
  String get noTasksToday;
  String get completeTask;
  String get taskCompleted;
  String askBeforeDeducting(int points);
  String spendNow(int amount, String tier);
  String get keepSaving;
  String get language;
  String get english;
  String get arabic;
  String get theme;
  String get themeSystem;
  String get themeLight;
  String get themeDark;
  String get dayBoundary;
  String get dayBoundaryHint;
  String get prepTime;
  String prepTimeMinutes(int minutes);
  String get currency;
  String get backup;
  String get restore;
  String get exportData;
  String get importData;
  String get backupNow;
  String get backupReminder;
  String get dataExported;
  String get dataImported;
  String get fianceeHub;
  String get qualityTime;
  String get occasions;
  String get giftVault;
  String get notes;
  String get addOccasion;
  String get occasionName;
  String get occasionDate;
  String daysUntil(int days);
  String hoursUntil(int hours);
  String get repeatYearly;
  String get birthday;
  String get anniversary;
  String get plannedDate;
  String get custom;
  String get biometricLock;
  String get enableBiometric;
  String get authenticateToAccess;
  String get pocketTracker;
  String get startingBalance;
  String get totalSpent;
  String get remaining;
  String get addExpense;
  String get amount;
  String get category;
  String get note;
  String get gasFuel;
  String get universityFood;
  String get coffeeDrinks;
  String get transport;
  String get other;
  String get exportCSV;
  String get budget;
  String get weeklyBudget;
  String get monthlyBudget;
  String budgetAlert(int percent);
  String get rolloverSavings;
  String get rolloverTomorrow;
  String get savings;
  String get schedule2;
  String get pomodoro;
  String get startPomodoro;
  String get pomodoroComplete;
  String get sleepCalculator;
  String get targetBedtime;
  String get targetWakeUp;
  String get emergencyShift;
  String get emergencyShiftConfirm;
  String get yes;
  String get no;
  String get addLecture;
  String get lectureName;
  String get lectureTime;
  String get recurrence;
  String weeklyOn(String day);
  String get meals;
  String get water;
  String get workout;
  String get healthyMeal;
  String waterCups(int cups);
  String get addWater;
  String get gymSession;
  String get weeklyStats;
  String get monthlyStats;
  String get spendingByCategory;
  String get pointsOverTime;
  String get studyConsistency;
  String get gymConsistency;
  String get onboardingWelcome;
  String get onboardingSubtitle;
  String get onboardingLanguage;
  String get onboardingTheme;
  String get onboardingPrepTime;
  String get onboardingCurrency;
  String get onboardingDayBoundary;
  String get getStarted;
  String get next;
  String get back;
  String get skip;
  String get manageRewards;
  String get addReward;
  String get rewardName;
  String get rewardTier;
  String get rewardHistory;
  String get noRewardsYet;
  String get streakFreeze;
  String get streakFreezeUsed;
  String get useStreakFreeze;
  String get multiplier;
  String activeMultiplier(String mult);
  String get error;
  String get success;
  String get loading;
  String get noData;
  String get confirmDelete;
  String get windDownReminder;
  String get bedtimeReminder;
  String get wakeUpReminder;
  String get drinkWater;
  String get logExpenses;
  String get checkTasks;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  switch (locale.languageCode) {
    case 'ar': return AppLocalizationsAr();
    case 'en': return AppLocalizationsEn();
  }
  return AppLocalizationsEn();
}
