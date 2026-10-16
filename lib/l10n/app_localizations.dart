import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Life OS'**
  String get appTitle;

  /// No description provided for @dashboard.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get dashboard;

  /// No description provided for @gamification.
  ///
  /// In en, this message translates to:
  /// **'Rewards'**
  String get gamification;

  /// No description provided for @schedule.
  ///
  /// In en, this message translates to:
  /// **'Schedule'**
  String get schedule;

  /// No description provided for @fiancee.
  ///
  /// In en, this message translates to:
  /// **'Fiancée Hub'**
  String get fiancee;

  /// No description provided for @finance.
  ///
  /// In en, this message translates to:
  /// **'Finance'**
  String get finance;

  /// No description provided for @lifestyle.
  ///
  /// In en, this message translates to:
  /// **'Lifestyle'**
  String get lifestyle;

  /// No description provided for @stats.
  ///
  /// In en, this message translates to:
  /// **'Stats'**
  String get stats;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @onboarding.
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get onboarding;

  /// No description provided for @points.
  ///
  /// In en, this message translates to:
  /// **'Points'**
  String get points;

  /// No description provided for @streak.
  ///
  /// In en, this message translates to:
  /// **'Streak'**
  String get streak;

  /// No description provided for @streakDays.
  ///
  /// In en, this message translates to:
  /// **'{count} day streak'**
  String streakDays(int count);

  /// No description provided for @currentPoints.
  ///
  /// In en, this message translates to:
  /// **'Current Points'**
  String get currentPoints;

  /// No description provided for @totalPoints.
  ///
  /// In en, this message translates to:
  /// **'Total Points'**
  String get totalPoints;

  /// No description provided for @bronze.
  ///
  /// In en, this message translates to:
  /// **'Bronze'**
  String get bronze;

  /// No description provided for @silver.
  ///
  /// In en, this message translates to:
  /// **'Silver'**
  String get silver;

  /// No description provided for @gold.
  ///
  /// In en, this message translates to:
  /// **'Gold'**
  String get gold;

  /// No description provided for @redeem.
  ///
  /// In en, this message translates to:
  /// **'Redeem'**
  String get redeem;

  /// No description provided for @redeemReward.
  ///
  /// In en, this message translates to:
  /// **'Redeem Reward'**
  String get redeemReward;

  /// No description provided for @rewardUnlocked.
  ///
  /// In en, this message translates to:
  /// **'Reward Unlocked!'**
  String get rewardUnlocked;

  /// No description provided for @congratulations.
  ///
  /// In en, this message translates to:
  /// **'Congratulations!'**
  String get congratulations;

  /// No description provided for @youEarned.
  ///
  /// In en, this message translates to:
  /// **'You earned:'**
  String get youEarned;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// No description provided for @undo.
  ///
  /// In en, this message translates to:
  /// **'Undo'**
  String get undo;

  /// No description provided for @snooze.
  ///
  /// In en, this message translates to:
  /// **'Snooze 1 Hour'**
  String get snooze;

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// No description provided for @tomorrow.
  ///
  /// In en, this message translates to:
  /// **'Tomorrow'**
  String get tomorrow;

  /// No description provided for @yesterday.
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get yesterday;

  /// No description provided for @morning.
  ///
  /// In en, this message translates to:
  /// **'Morning'**
  String get morning;

  /// No description provided for @evening.
  ///
  /// In en, this message translates to:
  /// **'Evening'**
  String get evening;

  /// No description provided for @goodMorning.
  ///
  /// In en, this message translates to:
  /// **'Good Morning!'**
  String get goodMorning;

  /// No description provided for @morningCheckIn.
  ///
  /// In en, this message translates to:
  /// **'Morning Check-in'**
  String get morningCheckIn;

  /// No description provided for @morningCheckInMessage.
  ///
  /// In en, this message translates to:
  /// **'Do you have any extra errands or tasks outside your regular schedule today?'**
  String get morningCheckInMessage;

  /// No description provided for @addTask.
  ///
  /// In en, this message translates to:
  /// **'Add Task'**
  String get addTask;

  /// No description provided for @taskName.
  ///
  /// In en, this message translates to:
  /// **'Task Name'**
  String get taskName;

  /// No description provided for @noTasksToday.
  ///
  /// In en, this message translates to:
  /// **'No tasks for today'**
  String get noTasksToday;

  /// No description provided for @completeTask.
  ///
  /// In en, this message translates to:
  /// **'Complete Task'**
  String get completeTask;

  /// No description provided for @taskCompleted.
  ///
  /// In en, this message translates to:
  /// **'Task Completed!'**
  String get taskCompleted;

  /// No description provided for @askBeforeDeducting.
  ///
  /// In en, this message translates to:
  /// **'You have {points} points!'**
  String askBeforeDeducting(int points);

  /// No description provided for @spendNow.
  ///
  /// In en, this message translates to:
  /// **'Spend {amount} pts for {tier}'**
  String spendNow(int amount, String tier);

  /// No description provided for @keepSaving.
  ///
  /// In en, this message translates to:
  /// **'Keep Saving'**
  String get keepSaving;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @arabic.
  ///
  /// In en, this message translates to:
  /// **'Arabic'**
  String get arabic;

  /// No description provided for @theme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// No description provided for @themeSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get themeSystem;

  /// No description provided for @themeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get themeLight;

  /// No description provided for @themeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get themeDark;

  /// No description provided for @dayBoundary.
  ///
  /// In en, this message translates to:
  /// **'Day Starts At'**
  String get dayBoundary;

  /// No description provided for @dayBoundaryHint.
  ///
  /// In en, this message translates to:
  /// **'Default: 4 AM'**
  String get dayBoundaryHint;

  /// No description provided for @prepTime.
  ///
  /// In en, this message translates to:
  /// **'Prep/Commute Time'**
  String get prepTime;

  /// No description provided for @prepTimeMinutes.
  ///
  /// In en, this message translates to:
  /// **'{minutes} minutes'**
  String prepTimeMinutes(int minutes);

  /// No description provided for @currency.
  ///
  /// In en, this message translates to:
  /// **'Currency'**
  String get currency;

  /// No description provided for @backup.
  ///
  /// In en, this message translates to:
  /// **'Backup'**
  String get backup;

  /// No description provided for @restore.
  ///
  /// In en, this message translates to:
  /// **'Restore'**
  String get restore;

  /// No description provided for @exportData.
  ///
  /// In en, this message translates to:
  /// **'Export Data'**
  String get exportData;

  /// No description provided for @importData.
  ///
  /// In en, this message translates to:
  /// **'Import Data'**
  String get importData;

  /// No description provided for @backupNow.
  ///
  /// In en, this message translates to:
  /// **'Backup Now'**
  String get backupNow;

  /// No description provided for @backupReminder.
  ///
  /// In en, this message translates to:
  /// **'Time to backup your data!'**
  String get backupReminder;

  /// No description provided for @dataExported.
  ///
  /// In en, this message translates to:
  /// **'Data exported successfully'**
  String get dataExported;

  /// No description provided for @dataImported.
  ///
  /// In en, this message translates to:
  /// **'Data imported successfully'**
  String get dataImported;

  /// No description provided for @fianceeHub.
  ///
  /// In en, this message translates to:
  /// **'Fiancée Hub'**
  String get fianceeHub;

  /// No description provided for @qualityTime.
  ///
  /// In en, this message translates to:
  /// **'Quality Time'**
  String get qualityTime;

  /// No description provided for @occasions.
  ///
  /// In en, this message translates to:
  /// **'Occasions'**
  String get occasions;

  /// No description provided for @giftVault.
  ///
  /// In en, this message translates to:
  /// **'Gift Vault'**
  String get giftVault;

  /// No description provided for @notes.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get notes;

  /// No description provided for @addOccasion.
  ///
  /// In en, this message translates to:
  /// **'Add Occasion'**
  String get addOccasion;

  /// No description provided for @occasionName.
  ///
  /// In en, this message translates to:
  /// **'Occasion Name'**
  String get occasionName;

  /// No description provided for @occasionDate.
  ///
  /// In en, this message translates to:
  /// **'Occasion Date'**
  String get occasionDate;

  /// No description provided for @daysUntil.
  ///
  /// In en, this message translates to:
  /// **'{days} days until'**
  String daysUntil(int days);

  /// No description provided for @hoursUntil.
  ///
  /// In en, this message translates to:
  /// **'{hours} hours until'**
  String hoursUntil(int hours);

  /// No description provided for @repeatYearly.
  ///
  /// In en, this message translates to:
  /// **'Repeat Yearly'**
  String get repeatYearly;

  /// No description provided for @birthday.
  ///
  /// In en, this message translates to:
  /// **'Birthday'**
  String get birthday;

  /// No description provided for @anniversary.
  ///
  /// In en, this message translates to:
  /// **'Anniversary'**
  String get anniversary;

  /// No description provided for @plannedDate.
  ///
  /// In en, this message translates to:
  /// **'Planned Date'**
  String get plannedDate;

  /// No description provided for @custom.
  ///
  /// In en, this message translates to:
  /// **'Custom'**
  String get custom;

  /// No description provided for @biometricLock.
  ///
  /// In en, this message translates to:
  /// **'Biometric Lock'**
  String get biometricLock;

  /// No description provided for @enableBiometric.
  ///
  /// In en, this message translates to:
  /// **'Enable Biometric Lock'**
  String get enableBiometric;

  /// No description provided for @authenticateToAccess.
  ///
  /// In en, this message translates to:
  /// **'Authenticate to access Fiancée Hub'**
  String get authenticateToAccess;

  /// No description provided for @pocketTracker.
  ///
  /// In en, this message translates to:
  /// **'Pocket Tracker'**
  String get pocketTracker;

  /// No description provided for @startingBalance.
  ///
  /// In en, this message translates to:
  /// **'Starting Balance'**
  String get startingBalance;

  /// No description provided for @totalSpent.
  ///
  /// In en, this message translates to:
  /// **'Total Spent'**
  String get totalSpent;

  /// No description provided for @remaining.
  ///
  /// In en, this message translates to:
  /// **'Remaining'**
  String get remaining;

  /// No description provided for @addExpense.
  ///
  /// In en, this message translates to:
  /// **'Add Expense'**
  String get addExpense;

  /// No description provided for @amount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get amount;

  /// No description provided for @category.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get category;

  /// No description provided for @note.
  ///
  /// In en, this message translates to:
  /// **'Note'**
  String get note;

  /// No description provided for @gasFuel.
  ///
  /// In en, this message translates to:
  /// **'Gas/Fuel'**
  String get gasFuel;

  /// No description provided for @universityFood.
  ///
  /// In en, this message translates to:
  /// **'University Food'**
  String get universityFood;

  /// No description provided for @coffeeDrinks.
  ///
  /// In en, this message translates to:
  /// **'Coffee/Drinks'**
  String get coffeeDrinks;

  /// No description provided for @transport.
  ///
  /// In en, this message translates to:
  /// **'Transport'**
  String get transport;

  /// No description provided for @other.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get other;

  /// No description provided for @exportCSV.
  ///
  /// In en, this message translates to:
  /// **'Export CSV'**
  String get exportCSV;

  /// No description provided for @budget.
  ///
  /// In en, this message translates to:
  /// **'Budget'**
  String get budget;

  /// No description provided for @weeklyBudget.
  ///
  /// In en, this message translates to:
  /// **'Weekly Budget'**
  String get weeklyBudget;

  /// No description provided for @monthlyBudget.
  ///
  /// In en, this message translates to:
  /// **'Monthly Budget'**
  String get monthlyBudget;

  /// No description provided for @budgetAlert.
  ///
  /// In en, this message translates to:
  /// **'You\'ve used {percent}% of your budget'**
  String budgetAlert(int percent);

  /// No description provided for @rolloverSavings.
  ///
  /// In en, this message translates to:
  /// **'Roll to Savings Vault'**
  String get rolloverSavings;

  /// No description provided for @rolloverTomorrow.
  ///
  /// In en, this message translates to:
  /// **'Roll to Tomorrow\'s Balance'**
  String get rolloverTomorrow;

  /// No description provided for @savings.
  ///
  /// In en, this message translates to:
  /// **'Savings'**
  String get savings;

  /// No description provided for @schedule2.
  ///
  /// In en, this message translates to:
  /// **'Schedule & Study'**
  String get schedule2;

  /// No description provided for @pomodoro.
  ///
  /// In en, this message translates to:
  /// **'Pomodoro'**
  String get pomodoro;

  /// No description provided for @startPomodoro.
  ///
  /// In en, this message translates to:
  /// **'Start Pomodoro'**
  String get startPomodoro;

  /// No description provided for @pomodoroComplete.
  ///
  /// In en, this message translates to:
  /// **'Pomodoro Complete!'**
  String get pomodoroComplete;

  /// No description provided for @sleepCalculator.
  ///
  /// In en, this message translates to:
  /// **'Sleep Calculator'**
  String get sleepCalculator;

  /// No description provided for @targetBedtime.
  ///
  /// In en, this message translates to:
  /// **'Target Bedtime'**
  String get targetBedtime;

  /// No description provided for @targetWakeUp.
  ///
  /// In en, this message translates to:
  /// **'Target Wake-Up'**
  String get targetWakeUp;

  /// No description provided for @emergencyShift.
  ///
  /// In en, this message translates to:
  /// **'+1 Hour Shift'**
  String get emergencyShift;

  /// No description provided for @emergencyShiftConfirm.
  ///
  /// In en, this message translates to:
  /// **'Push all remaining tasks forward by 1 hour?'**
  String get emergencyShiftConfirm;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @addLecture.
  ///
  /// In en, this message translates to:
  /// **'Add Lecture'**
  String get addLecture;

  /// No description provided for @lectureName.
  ///
  /// In en, this message translates to:
  /// **'Lecture Name'**
  String get lectureName;

  /// No description provided for @lectureTime.
  ///
  /// In en, this message translates to:
  /// **'Lecture Time'**
  String get lectureTime;

  /// No description provided for @recurrence.
  ///
  /// In en, this message translates to:
  /// **'Recurrence'**
  String get recurrence;

  /// No description provided for @weeklyOn.
  ///
  /// In en, this message translates to:
  /// **'Weekly on {day}'**
  String weeklyOn(String day);

  /// No description provided for @meals.
  ///
  /// In en, this message translates to:
  /// **'Meals'**
  String get meals;

  /// No description provided for @water.
  ///
  /// In en, this message translates to:
  /// **'Water'**
  String get water;

  /// No description provided for @workout.
  ///
  /// In en, this message translates to:
  /// **'Workout'**
  String get workout;

  /// No description provided for @healthyMeal.
  ///
  /// In en, this message translates to:
  /// **'Healthy Meal'**
  String get healthyMeal;

  /// No description provided for @waterCups.
  ///
  /// In en, this message translates to:
  /// **'{cups} cups'**
  String waterCups(int cups);

  /// No description provided for @addWater.
  ///
  /// In en, this message translates to:
  /// **'Add Water'**
  String get addWater;

  /// No description provided for @gymSession.
  ///
  /// In en, this message translates to:
  /// **'Gym Session'**
  String get gymSession;

  /// No description provided for @weeklyStats.
  ///
  /// In en, this message translates to:
  /// **'Weekly Stats'**
  String get weeklyStats;

  /// No description provided for @monthlyStats.
  ///
  /// In en, this message translates to:
  /// **'Monthly Stats'**
  String get monthlyStats;

  /// No description provided for @spendingByCategory.
  ///
  /// In en, this message translates to:
  /// **'Spending by Category'**
  String get spendingByCategory;

  /// No description provided for @pointsOverTime.
  ///
  /// In en, this message translates to:
  /// **'Points Over Time'**
  String get pointsOverTime;

  /// No description provided for @studyConsistency.
  ///
  /// In en, this message translates to:
  /// **'Study Consistency'**
  String get studyConsistency;

  /// No description provided for @gymConsistency.
  ///
  /// In en, this message translates to:
  /// **'Gym Consistency'**
  String get gymConsistency;

  /// No description provided for @onboardingWelcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Life OS'**
  String get onboardingWelcome;

  /// No description provided for @onboardingSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Your gamified personal productivity system'**
  String get onboardingSubtitle;

  /// No description provided for @onboardingLanguage.
  ///
  /// In en, this message translates to:
  /// **'Choose your language'**
  String get onboardingLanguage;

  /// No description provided for @onboardingTheme.
  ///
  /// In en, this message translates to:
  /// **'Choose your theme'**
  String get onboardingTheme;

  /// No description provided for @onboardingPrepTime.
  ///
  /// In en, this message translates to:
  /// **'Set your prep/commute time'**
  String get onboardingPrepTime;

  /// No description provided for @onboardingCurrency.
  ///
  /// In en, this message translates to:
  /// **'Set your currency'**
  String get onboardingCurrency;

  /// No description provided for @onboardingDayBoundary.
  ///
  /// In en, this message translates to:
  /// **'When does your new day start?'**
  String get onboardingDayBoundary;

  /// No description provided for @getStarted.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get getStarted;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// No description provided for @manageRewards.
  ///
  /// In en, this message translates to:
  /// **'Manage Rewards'**
  String get manageRewards;

  /// No description provided for @addReward.
  ///
  /// In en, this message translates to:
  /// **'Add Reward'**
  String get addReward;

  /// No description provided for @rewardName.
  ///
  /// In en, this message translates to:
  /// **'Reward Name'**
  String get rewardName;

  /// No description provided for @rewardTier.
  ///
  /// In en, this message translates to:
  /// **'Reward Tier'**
  String get rewardTier;

  /// No description provided for @rewardHistory.
  ///
  /// In en, this message translates to:
  /// **'Reward History'**
  String get rewardHistory;

  /// No description provided for @noRewardsYet.
  ///
  /// In en, this message translates to:
  /// **'No rewards claimed yet'**
  String get noRewardsYet;

  /// No description provided for @streakFreeze.
  ///
  /// In en, this message translates to:
  /// **'Streak Freeze'**
  String get streakFreeze;

  /// No description provided for @streakFreezeUsed.
  ///
  /// In en, this message translates to:
  /// **'Streak freeze used this week'**
  String get streakFreezeUsed;

  /// No description provided for @useStreakFreeze.
  ///
  /// In en, this message translates to:
  /// **'Use Streak Freeze'**
  String get useStreakFreeze;

  /// No description provided for @multiplier.
  ///
  /// In en, this message translates to:
  /// **'Multiplier'**
  String get multiplier;

  /// No description provided for @activeMultiplier.
  ///
  /// In en, this message translates to:
  /// **'{mult}x multiplier active!'**
  String activeMultiplier(String mult);

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @success.
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get success;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @noData.
  ///
  /// In en, this message translates to:
  /// **'No data available'**
  String get noData;

  /// No description provided for @confirmDelete.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this?'**
  String get confirmDelete;

  /// No description provided for @windDownReminder.
  ///
  /// In en, this message translates to:
  /// **'Time to wind down for bed!'**
  String get windDownReminder;

  /// No description provided for @bedtimeReminder.
  ///
  /// In en, this message translates to:
  /// **'Bedtime reminder'**
  String get bedtimeReminder;

  /// No description provided for @wakeUpReminder.
  ///
  /// In en, this message translates to:
  /// **'Time to wake up!'**
  String get wakeUpReminder;

  /// No description provided for @drinkWater.
  ///
  /// In en, this message translates to:
  /// **'Don\'t forget to drink water!'**
  String get drinkWater;

  /// No description provided for @logExpenses.
  ///
  /// In en, this message translates to:
  /// **'Log your recent expenses'**
  String get logExpenses;

  /// No description provided for @checkTasks.
  ///
  /// In en, this message translates to:
  /// **'Check your remaining tasks'**
  String get checkTasks;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
