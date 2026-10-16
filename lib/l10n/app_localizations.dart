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

  /// No description provided for @pending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get pending;

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

  /// No description provided for @budgetWarning.
  ///
  /// In en, this message translates to:
  /// **'Budget Warning'**
  String get budgetWarning;

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

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// No description provided for @giftIdeas.
  ///
  /// In en, this message translates to:
  /// **'Gift Ideas 🎁'**
  String get giftIdeas;

  /// No description provided for @sheLikes.
  ///
  /// In en, this message translates to:
  /// **'She Likes ✨'**
  String get sheLikes;

  /// No description provided for @notesCategory.
  ///
  /// In en, this message translates to:
  /// **'Notes 📝'**
  String get notesCategory;

  /// No description provided for @pointsDailyReward.
  ///
  /// In en, this message translates to:
  /// **'+{points} points daily reward'**
  String pointsDailyReward(int points);

  /// No description provided for @qualityTimeSuccess.
  ///
  /// In en, this message translates to:
  /// **'Quality Time logged! +15 points earned ❤️'**
  String get qualityTimeSuccess;

  /// No description provided for @deleteOccasionConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete occasion \"{name}\"? Scheduled notifications will also be cancelled.'**
  String deleteOccasionConfirm(String name);

  /// No description provided for @noBackupYet.
  ///
  /// In en, this message translates to:
  /// **'No backup performed yet'**
  String get noBackupYet;

  /// No description provided for @lastBackupLabel.
  ///
  /// In en, this message translates to:
  /// **'Last backup: {time}'**
  String lastBackupLabel(String time);

  /// No description provided for @restoreJsonDesc.
  ///
  /// In en, this message translates to:
  /// **'Restore all boxes from JSON backup file'**
  String get restoreJsonDesc;

  /// No description provided for @devTools.
  ///
  /// In en, this message translates to:
  /// **'Developer Tools'**
  String get devTools;

  /// No description provided for @seedMockData.
  ///
  /// In en, this message translates to:
  /// **'Seed Mock Data'**
  String get seedMockData;

  /// No description provided for @seedMockDataDesc.
  ///
  /// In en, this message translates to:
  /// **'Fill all modules with sample test data'**
  String get seedMockDataDesc;

  /// No description provided for @seedDataButton.
  ///
  /// In en, this message translates to:
  /// **'Seed Data'**
  String get seedDataButton;

  /// No description provided for @mockDataSeededSuccess.
  ///
  /// In en, this message translates to:
  /// **'Mock test data seeded successfully!'**
  String get mockDataSeededSuccess;

  /// No description provided for @sideloadBackupReminder.
  ///
  /// In en, this message translates to:
  /// **'iOS Sideload Backup Reminder'**
  String get sideloadBackupReminder;

  /// No description provided for @sideloadBackupReminderDesc.
  ///
  /// In en, this message translates to:
  /// **'Export backup weekly to protect your data across 7-day sideload certificates (AltStore/SideStore).'**
  String get sideloadBackupReminderDesc;

  /// No description provided for @backupFresh.
  ///
  /// In en, this message translates to:
  /// **'Backup is fresh.'**
  String get backupFresh;

  /// No description provided for @backupRecommended.
  ///
  /// In en, this message translates to:
  /// **'⚠️ Refresh certificate & backup recommended!'**
  String get backupRecommended;

  /// No description provided for @preferences.
  ///
  /// In en, this message translates to:
  /// **'Preferences'**
  String get preferences;

  /// No description provided for @recommended.
  ///
  /// In en, this message translates to:
  /// **'Recommended'**
  String get recommended;

  /// No description provided for @restoreConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Restore Backup?'**
  String get restoreConfirmTitle;

  /// No description provided for @restoreConfirmDesc.
  ///
  /// In en, this message translates to:
  /// **'Restoring data from a backup file will replace current local data with the backup contents. Do you want to proceed?'**
  String get restoreConfirmDesc;

  /// No description provided for @proceed.
  ///
  /// In en, this message translates to:
  /// **'Proceed'**
  String get proceed;

  /// No description provided for @backupExportedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Backup exported successfully!'**
  String get backupExportedSuccess;

  /// No description provided for @backupRestoredSuccess.
  ///
  /// In en, this message translates to:
  /// **'Backup restored successfully!'**
  String get backupRestoredSuccess;

  /// No description provided for @exportFailed.
  ///
  /// In en, this message translates to:
  /// **'Export failed: {error}'**
  String exportFailed(String error);

  /// No description provided for @restoreFailed.
  ///
  /// In en, this message translates to:
  /// **'Restore failed: {error}'**
  String restoreFailed(String error);

  /// No description provided for @seedingFailed.
  ///
  /// In en, this message translates to:
  /// **'Seeding failed: {error}'**
  String seedingFailed(String error);

  /// No description provided for @dayBoundaryHourTitle.
  ///
  /// In en, this message translates to:
  /// **'Day Boundary Hour'**
  String get dayBoundaryHourTitle;

  /// No description provided for @dayBoundaryDesc.
  ///
  /// In en, this message translates to:
  /// **'Select when your productivity day flips (e.g. 4:00 AM allows night owls to finish tasks before next day resets).'**
  String get dayBoundaryDesc;

  /// No description provided for @recordsCount.
  ///
  /// In en, this message translates to:
  /// **'{count} records'**
  String recordsCount(int count);

  /// No description provided for @endOfDayRolloverBonus.
  ///
  /// In en, this message translates to:
  /// **'End-of-Day Rollover (+15 pts)'**
  String get endOfDayRolloverBonus;

  /// No description provided for @rolloverDisabledZero.
  ///
  /// In en, this message translates to:
  /// **'Starting balance must be greater than 0'**
  String get rolloverDisabledZero;

  /// No description provided for @rolloverDisabledAlready.
  ///
  /// In en, this message translates to:
  /// **'Rollover already completed today'**
  String get rolloverDisabledAlready;

  /// No description provided for @rolloverDisabledDeficit.
  ///
  /// In en, this message translates to:
  /// **'Daily budget was exceeded'**
  String get rolloverDisabledDeficit;

  /// No description provided for @rolloverDialogContent.
  ///
  /// In en, this message translates to:
  /// **'You have {amount} {currency} remaining.\n\nChoose how you want to handle your leftover balance:'**
  String rolloverDialogContent(String amount, String currency);

  /// No description provided for @keepForTomorrow.
  ///
  /// In en, this message translates to:
  /// **'Keep for Tomorrow'**
  String get keepForTomorrow;

  /// No description provided for @sendToSavingsVault.
  ///
  /// In en, this message translates to:
  /// **'Send to Savings Vault'**
  String get sendToSavingsVault;

  /// No description provided for @rolledToTomorrowSuccess.
  ///
  /// In en, this message translates to:
  /// **'Rolled to tomorrow\'s starting balance! +15 pts earned 🎉'**
  String get rolledToTomorrowSuccess;

  /// No description provided for @rolledToSavingsSuccess.
  ///
  /// In en, this message translates to:
  /// **'Transferred to Savings Vault! +15 pts earned 💰'**
  String get rolledToSavingsSuccess;

  /// No description provided for @lifestyleDailyScore.
  ///
  /// In en, this message translates to:
  /// **'Lifestyle Daily Score'**
  String get lifestyleDailyScore;

  /// No description provided for @pointsEarnedToday.
  ///
  /// In en, this message translates to:
  /// **'+{points} points earned today'**
  String pointsEarnedToday(int points);

  /// No description provided for @cupsTarget.
  ///
  /// In en, this message translates to:
  /// **'{current} / {target} cups'**
  String cupsTarget(int current, int target);

  /// No description provided for @goalReached.
  ///
  /// In en, this message translates to:
  /// **'🎯 Goal reached!'**
  String get goalReached;

  /// No description provided for @mealsLoggedCount.
  ///
  /// In en, this message translates to:
  /// **'{count} meals logged (+5 pts each)'**
  String mealsLoggedCount(int count);

  /// No description provided for @sleepWakeGoals.
  ///
  /// In en, this message translates to:
  /// **'Sleep & Wake Goals'**
  String get sleepWakeGoals;

  /// No description provided for @pointsForSleepingOnTime.
  ///
  /// In en, this message translates to:
  /// **'+10 points for sleeping on time'**
  String get pointsForSleepingOnTime;

  /// No description provided for @pointsForWakingOnTime.
  ///
  /// In en, this message translates to:
  /// **'+10 points for waking on time'**
  String get pointsForWakingOnTime;

  /// No description provided for @pointsWhenCompleted.
  ///
  /// In en, this message translates to:
  /// **'+20 pts when completed'**
  String get pointsWhenCompleted;

  /// No description provided for @completedWithPoints.
  ///
  /// In en, this message translates to:
  /// **'Completed (+20 pts)'**
  String get completedWithPoints;

  /// No description provided for @recentActivity.
  ///
  /// In en, this message translates to:
  /// **'Recent Activity'**
  String get recentActivity;

  /// No description provided for @noActivityToday.
  ///
  /// In en, this message translates to:
  /// **'No activity logged today yet.'**
  String get noActivityToday;

  /// No description provided for @activityWater.
  ///
  /// In en, this message translates to:
  /// **'Drank 1 cup of water'**
  String get activityWater;

  /// No description provided for @activityMeal.
  ///
  /// In en, this message translates to:
  /// **'Healthy meal (+5 pts)'**
  String get activityMeal;

  /// No description provided for @activityWorkout.
  ///
  /// In en, this message translates to:
  /// **'Workout session completed (+20 pts)'**
  String get activityWorkout;

  /// No description provided for @activitySleep.
  ///
  /// In en, this message translates to:
  /// **'Slept on time (+10 pts)'**
  String get activitySleep;

  /// No description provided for @activityWake.
  ///
  /// In en, this message translates to:
  /// **'Woke up on time (+10 pts)'**
  String get activityWake;

  /// No description provided for @activityLogged.
  ///
  /// In en, this message translates to:
  /// **'Activity logged'**
  String get activityLogged;

  /// No description provided for @passed.
  ///
  /// In en, this message translates to:
  /// **'Passed'**
  String get passed;

  /// No description provided for @daysLeft.
  ///
  /// In en, this message translates to:
  /// **'{days} days left'**
  String daysLeft(int days);

  /// No description provided for @todayExclamation.
  ///
  /// In en, this message translates to:
  /// **'Today!'**
  String get todayExclamation;

  /// No description provided for @prepTimeCommuteTitle.
  ///
  /// In en, this message translates to:
  /// **'Preparation & Commute Time'**
  String get prepTimeCommuteTitle;

  /// No description provided for @prepTimeCommuteDesc.
  ///
  /// In en, this message translates to:
  /// **'How many minutes you need before your first morning lecture or task.'**
  String get prepTimeCommuteDesc;

  /// No description provided for @minutesCount.
  ///
  /// In en, this message translates to:
  /// **'{minutes} minutes'**
  String minutesCount(int minutes);

  /// No description provided for @setBudget.
  ///
  /// In en, this message translates to:
  /// **'Set Budget'**
  String get setBudget;

  /// No description provided for @budgetLimitsAlerts.
  ///
  /// In en, this message translates to:
  /// **'Budget Limits & Alerts'**
  String get budgetLimitsAlerts;

  /// No description provided for @weeklyBudgetCurrency.
  ///
  /// In en, this message translates to:
  /// **'Weekly Budget ({currency})'**
  String weeklyBudgetCurrency(String currency);

  /// No description provided for @monthlyBudgetCurrency.
  ///
  /// In en, this message translates to:
  /// **'Monthly Budget ({currency})'**
  String monthlyBudgetCurrency(String currency);

  /// No description provided for @deleteExpenseConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete {category} expense of {amount} {currency}?'**
  String deleteExpenseConfirm(String category, String amount, String currency);

  /// No description provided for @newDailyStartingBalance.
  ///
  /// In en, this message translates to:
  /// **'New Daily Starting Balance'**
  String get newDailyStartingBalance;

  /// No description provided for @giftIdeaNoteHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Favorite perfume, bracelet size, flowers she loves...'**
  String get giftIdeaNoteHint;

  /// No description provided for @universityTimetable.
  ///
  /// In en, this message translates to:
  /// **'University Timetable'**
  String get universityTimetable;

  /// No description provided for @subjects.
  ///
  /// In en, this message translates to:
  /// **'Subjects'**
  String get subjects;

  /// No description provided for @addSubject.
  ///
  /// In en, this message translates to:
  /// **'Add Subject'**
  String get addSubject;

  /// No description provided for @editSubject.
  ///
  /// In en, this message translates to:
  /// **'Edit Subject'**
  String get editSubject;

  /// No description provided for @subjectName.
  ///
  /// In en, this message translates to:
  /// **'Subject Name'**
  String get subjectName;

  /// No description provided for @color.
  ///
  /// In en, this message translates to:
  /// **'Color'**
  String get color;

  /// No description provided for @examDate.
  ///
  /// In en, this message translates to:
  /// **'Exam Date'**
  String get examDate;

  /// No description provided for @noSubjectsYet.
  ///
  /// In en, this message translates to:
  /// **'No subjects added yet'**
  String get noSubjectsYet;

  /// No description provided for @addSession.
  ///
  /// In en, this message translates to:
  /// **'Add Session'**
  String get addSession;

  /// No description provided for @sessionType.
  ///
  /// In en, this message translates to:
  /// **'Session Type'**
  String get sessionType;

  /// No description provided for @lecture.
  ///
  /// In en, this message translates to:
  /// **'Lecture'**
  String get lecture;

  /// No description provided for @section.
  ///
  /// In en, this message translates to:
  /// **'Section'**
  String get section;

  /// No description provided for @lab.
  ///
  /// In en, this message translates to:
  /// **'Lab'**
  String get lab;

  /// No description provided for @weekday.
  ///
  /// In en, this message translates to:
  /// **'Weekday'**
  String get weekday;

  /// No description provided for @startTime.
  ///
  /// In en, this message translates to:
  /// **'Start Time'**
  String get startTime;

  /// No description provided for @endTime.
  ///
  /// In en, this message translates to:
  /// **'End Time'**
  String get endTime;

  /// No description provided for @location.
  ///
  /// In en, this message translates to:
  /// **'Location (optional)'**
  String get location;

  /// No description provided for @invalidTimeRange.
  ///
  /// In en, this message translates to:
  /// **'End time must be after start time'**
  String get invalidTimeRange;

  /// No description provided for @sessionOverlapWarning.
  ///
  /// In en, this message translates to:
  /// **'Warning: This session overlaps with another session!'**
  String get sessionOverlapWarning;

  /// No description provided for @commuteQuestion.
  ///
  /// In en, this message translates to:
  /// **'How long will it take you to get to university today?'**
  String get commuteQuestion;

  /// No description provided for @studyQuestion.
  ///
  /// In en, this message translates to:
  /// **'Which subject will you study today?'**
  String get studyQuestion;

  /// No description provided for @noStudyToday.
  ///
  /// In en, this message translates to:
  /// **'No study today'**
  String get noStudyToday;

  /// No description provided for @timelineWakeUp.
  ///
  /// In en, this message translates to:
  /// **'Wake Up'**
  String get timelineWakeUp;

  /// No description provided for @timelineLeaveHome.
  ///
  /// In en, this message translates to:
  /// **'Leave Home'**
  String get timelineLeaveHome;

  /// No description provided for @timelineReturnHome.
  ///
  /// In en, this message translates to:
  /// **'Return Home'**
  String get timelineReturnHome;

  /// No description provided for @timelineBedtime.
  ///
  /// In en, this message translates to:
  /// **'Bedtime'**
  String get timelineBedtime;

  /// No description provided for @freeWindow.
  ///
  /// In en, this message translates to:
  /// **'Free Window ({minutes}m)'**
  String freeWindow(int minutes);

  /// No description provided for @suggestedStudy.
  ///
  /// In en, this message translates to:
  /// **'Suggested Study ({minutes}m)'**
  String suggestedStudy(int minutes);

  /// No description provided for @attendanceChecklist.
  ///
  /// In en, this message translates to:
  /// **'Attendance Checklist'**
  String get attendanceChecklist;

  /// No description provided for @attended.
  ///
  /// In en, this message translates to:
  /// **'Attended'**
  String get attended;

  /// No description provided for @attendedPoints.
  ///
  /// In en, this message translates to:
  /// **'+{points} pts'**
  String attendedPoints(int points);

  /// No description provided for @attendanceBeforeStart.
  ///
  /// In en, this message translates to:
  /// **'Attendance allowed after session starts'**
  String get attendanceBeforeStart;

  /// No description provided for @alreadyAttended.
  ///
  /// In en, this message translates to:
  /// **'Already marked as attended'**
  String get alreadyAttended;

  /// No description provided for @nowCard.
  ///
  /// In en, this message translates to:
  /// **'Happening Now'**
  String get nowCard;

  /// No description provided for @nextCard.
  ///
  /// In en, this message translates to:
  /// **'Up Next'**
  String get nextCard;

  /// No description provided for @startsIn.
  ///
  /// In en, this message translates to:
  /// **'Starts in {time}'**
  String startsIn(String time);

  /// No description provided for @endsIn.
  ///
  /// In en, this message translates to:
  /// **'Ends in {time}'**
  String endsIn(String time);

  /// No description provided for @noUpcomingSessions.
  ///
  /// In en, this message translates to:
  /// **'No more sessions today'**
  String get noUpcomingSessions;

  /// No description provided for @weeklyAttendanceRate.
  ///
  /// In en, this message translates to:
  /// **'Weekly Attendance Rate'**
  String get weeklyAttendanceRate;

  /// No description provided for @geminiApiKey.
  ///
  /// In en, this message translates to:
  /// **'Gemini API Key'**
  String get geminiApiKey;

  /// No description provided for @testKey.
  ///
  /// In en, this message translates to:
  /// **'Test Key'**
  String get testKey;

  /// No description provided for @keyValid.
  ///
  /// In en, this message translates to:
  /// **'API Key is valid!'**
  String get keyValid;

  /// No description provided for @keyInvalid.
  ///
  /// In en, this message translates to:
  /// **'Invalid API Key or API error'**
  String get keyInvalid;

  /// No description provided for @requireProofForPoints.
  ///
  /// In en, this message translates to:
  /// **'Require proof for points'**
  String get requireProofForPoints;

  /// No description provided for @requireProofSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Verify study & arrival with AI photo or GPS'**
  String get requireProofSubtitle;

  /// No description provided for @saveUniversityLocation.
  ///
  /// In en, this message translates to:
  /// **'Save University Location'**
  String get saveUniversityLocation;

  /// No description provided for @locationSaved.
  ///
  /// In en, this message translates to:
  /// **'University location saved successfully!'**
  String get locationSaved;

  /// No description provided for @allowedRadius.
  ///
  /// In en, this message translates to:
  /// **'Allowed Radius: {meters}m'**
  String allowedRadius(int meters);

  /// No description provided for @takeProof.
  ///
  /// In en, this message translates to:
  /// **'Take Proof'**
  String get takeProof;

  /// No description provided for @proofVerified.
  ///
  /// In en, this message translates to:
  /// **'Proof Verified! Points Awarded 🎉'**
  String get proofVerified;

  /// No description provided for @proofRejected.
  ///
  /// In en, this message translates to:
  /// **'Proof Rejected: {reason}'**
  String proofRejected(String reason);

  /// No description provided for @proofUnclear.
  ///
  /// In en, this message translates to:
  /// **'Proof Unclear: {reason}. Attempts remaining: {attempts}'**
  String proofUnclear(String reason, int attempts);

  /// No description provided for @proofPendingOffline.
  ///
  /// In en, this message translates to:
  /// **'No internet connection. Proof queued for verification.'**
  String get proofPendingOffline;

  /// No description provided for @proofPrivacyNotice.
  ///
  /// In en, this message translates to:
  /// **'Photos taken are sent securely to Google Gemini for verification and deleted immediately after analysis. No photos are stored on servers.'**
  String get proofPrivacyNotice;

  /// No description provided for @proofLogs.
  ///
  /// In en, this message translates to:
  /// **'Proof History'**
  String get proofLogs;

  /// No description provided for @noProofLogs.
  ///
  /// In en, this message translates to:
  /// **'No proof logs recorded yet'**
  String get noProofLogs;

  /// No description provided for @locationMismatchFallback.
  ///
  /// In en, this message translates to:
  /// **'You are outside the university campus ({distance}m away). Please provide a photo proof instead.'**
  String locationMismatchFallback(int distance);

  /// No description provided for @locationPermissionDenied.
  ///
  /// In en, this message translates to:
  /// **'Location permission denied. Please provide a photo proof instead.'**
  String get locationPermissionDenied;

  /// No description provided for @occasionType.
  ///
  /// In en, this message translates to:
  /// **'Occasion Type'**
  String get occasionType;

  /// No description provided for @customCelebration.
  ///
  /// In en, this message translates to:
  /// **'Custom Celebration'**
  String get customCelebration;

  /// No description provided for @date.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get date;

  /// No description provided for @change.
  ///
  /// In en, this message translates to:
  /// **'Change'**
  String get change;

  /// No description provided for @repeatYearlyDesc.
  ///
  /// In en, this message translates to:
  /// **'Auto-renews next year after passing'**
  String get repeatYearlyDesc;

  /// No description provided for @yearly.
  ///
  /// In en, this message translates to:
  /// **'Yearly'**
  String get yearly;
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
