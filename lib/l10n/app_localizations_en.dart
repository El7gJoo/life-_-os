// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Life OS';

  @override
  String get dashboard => 'Dashboard';

  @override
  String get gamification => 'Rewards';

  @override
  String get schedule => 'Schedule';

  @override
  String get fiancee => 'Fiancée Hub';

  @override
  String get finance => 'Finance';

  @override
  String get lifestyle => 'Lifestyle';

  @override
  String get stats => 'Stats';

  @override
  String get settings => 'Settings';

  @override
  String get onboarding => 'Welcome';

  @override
  String get points => 'Points';

  @override
  String get streak => 'Streak';

  @override
  String streakDays(int count) {
    return '$count day streak';
  }

  @override
  String get currentPoints => 'Current Points';

  @override
  String get totalPoints => 'Total Points';

  @override
  String get bronze => 'Bronze';

  @override
  String get silver => 'Silver';

  @override
  String get gold => 'Gold';

  @override
  String get redeem => 'Redeem';

  @override
  String get redeemReward => 'Redeem Reward';

  @override
  String get rewardUnlocked => 'Reward Unlocked!';

  @override
  String get congratulations => 'Congratulations!';

  @override
  String get youEarned => 'You earned:';

  @override
  String get close => 'Close';

  @override
  String get cancel => 'Cancel';

  @override
  String get save => 'Save';

  @override
  String get delete => 'Delete';

  @override
  String get edit => 'Edit';

  @override
  String get add => 'Add';

  @override
  String get done => 'Done';

  @override
  String get undo => 'Undo';

  @override
  String get snooze => 'Snooze 1 Hour';

  @override
  String get today => 'Today';

  @override
  String get tomorrow => 'Tomorrow';

  @override
  String get yesterday => 'Yesterday';

  @override
  String get morning => 'Morning';

  @override
  String get evening => 'Evening';

  @override
  String get goodMorning => 'Good Morning!';

  @override
  String get morningCheckIn => 'Morning Check-in';

  @override
  String get morningCheckInMessage =>
      'Do you have any extra errands or tasks outside your regular schedule today?';

  @override
  String get addTask => 'Add Task';

  @override
  String get taskName => 'Task Name';

  @override
  String get noTasksToday => 'No tasks for today';

  @override
  String get completeTask => 'Complete Task';

  @override
  String get taskCompleted => 'Task Completed!';

  @override
  String askBeforeDeducting(int points) {
    return 'You have $points points!';
  }

  @override
  String spendNow(int amount, String tier) {
    return 'Spend $amount pts for $tier';
  }

  @override
  String get keepSaving => 'Keep Saving';

  @override
  String get language => 'Language';

  @override
  String get english => 'English';

  @override
  String get arabic => 'Arabic';

  @override
  String get theme => 'Theme';

  @override
  String get themeSystem => 'System';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';

  @override
  String get dayBoundary => 'Day Starts At';

  @override
  String get dayBoundaryHint => 'Default: 4 AM';

  @override
  String get prepTime => 'Prep/Commute Time';

  @override
  String prepTimeMinutes(int minutes) {
    return '$minutes minutes';
  }

  @override
  String get currency => 'Currency';

  @override
  String get backup => 'Backup';

  @override
  String get restore => 'Restore';

  @override
  String get exportData => 'Export Data';

  @override
  String get importData => 'Import Data';

  @override
  String get backupNow => 'Backup Now';

  @override
  String get backupReminder => 'Time to backup your data!';

  @override
  String get dataExported => 'Data exported successfully';

  @override
  String get dataImported => 'Data imported successfully';

  @override
  String get fianceeHub => 'Fiancée Hub';

  @override
  String get qualityTime => 'Quality Time';

  @override
  String get occasions => 'Occasions';

  @override
  String get giftVault => 'Gift Vault';

  @override
  String get notes => 'Notes';

  @override
  String get addOccasion => 'Add Occasion';

  @override
  String get occasionName => 'Occasion Name';

  @override
  String get occasionDate => 'Occasion Date';

  @override
  String daysUntil(int days) {
    return '$days days until';
  }

  @override
  String hoursUntil(int hours) {
    return '$hours hours until';
  }

  @override
  String get repeatYearly => 'Repeat Yearly';

  @override
  String get birthday => 'Birthday';

  @override
  String get anniversary => 'Anniversary';

  @override
  String get plannedDate => 'Planned Date';

  @override
  String get custom => 'Custom';

  @override
  String get biometricLock => 'Biometric Lock';

  @override
  String get enableBiometric => 'Enable Biometric Lock';

  @override
  String get authenticateToAccess => 'Authenticate to access Fiancée Hub';

  @override
  String get pocketTracker => 'Pocket Tracker';

  @override
  String get startingBalance => 'Starting Balance';

  @override
  String get totalSpent => 'Total Spent';

  @override
  String get remaining => 'Remaining';

  @override
  String get addExpense => 'Add Expense';

  @override
  String get amount => 'Amount';

  @override
  String get category => 'Category';

  @override
  String get note => 'Note';

  @override
  String get gasFuel => 'Gas/Fuel';

  @override
  String get universityFood => 'University Food';

  @override
  String get coffeeDrinks => 'Coffee/Drinks';

  @override
  String get transport => 'Transport';

  @override
  String get other => 'Other';

  @override
  String get exportCSV => 'Export CSV';

  @override
  String get budget => 'Budget';

  @override
  String get weeklyBudget => 'Weekly Budget';

  @override
  String get monthlyBudget => 'Monthly Budget';

  @override
  String budgetAlert(int percent) {
    return 'You\'ve used $percent% of your budget';
  }

  @override
  String get rolloverSavings => 'Roll to Savings Vault';

  @override
  String get rolloverTomorrow => 'Roll to Tomorrow\'s Balance';

  @override
  String get savings => 'Savings';

  @override
  String get schedule2 => 'Schedule & Study';

  @override
  String get pomodoro => 'Pomodoro';

  @override
  String get startPomodoro => 'Start Pomodoro';

  @override
  String get pomodoroComplete => 'Pomodoro Complete!';

  @override
  String get sleepCalculator => 'Sleep Calculator';

  @override
  String get targetBedtime => 'Target Bedtime';

  @override
  String get targetWakeUp => 'Target Wake-Up';

  @override
  String get emergencyShift => '+1 Hour Shift';

  @override
  String get emergencyShiftConfirm =>
      'Push all remaining tasks forward by 1 hour?';

  @override
  String get yes => 'Yes';

  @override
  String get no => 'No';

  @override
  String get addLecture => 'Add Lecture';

  @override
  String get lectureName => 'Lecture Name';

  @override
  String get lectureTime => 'Lecture Time';

  @override
  String get recurrence => 'Recurrence';

  @override
  String weeklyOn(String day) {
    return 'Weekly on $day';
  }

  @override
  String get meals => 'Meals';

  @override
  String get water => 'Water';

  @override
  String get workout => 'Workout';

  @override
  String get healthyMeal => 'Healthy Meal';

  @override
  String waterCups(int cups) {
    return '$cups cups';
  }

  @override
  String get addWater => 'Add Water';

  @override
  String get gymSession => 'Gym Session';

  @override
  String get weeklyStats => 'Weekly Stats';

  @override
  String get monthlyStats => 'Monthly Stats';

  @override
  String get spendingByCategory => 'Spending by Category';

  @override
  String get pointsOverTime => 'Points Over Time';

  @override
  String get studyConsistency => 'Study Consistency';

  @override
  String get gymConsistency => 'Gym Consistency';

  @override
  String get onboardingWelcome => 'Welcome to Life OS';

  @override
  String get onboardingSubtitle => 'Your gamified personal productivity system';

  @override
  String get onboardingLanguage => 'Choose your language';

  @override
  String get onboardingTheme => 'Choose your theme';

  @override
  String get onboardingPrepTime => 'Set your prep/commute time';

  @override
  String get onboardingCurrency => 'Set your currency';

  @override
  String get onboardingDayBoundary => 'When does your new day start?';

  @override
  String get getStarted => 'Get Started';

  @override
  String get next => 'Next';

  @override
  String get back => 'Back';

  @override
  String get skip => 'Skip';

  @override
  String get manageRewards => 'Manage Rewards';

  @override
  String get addReward => 'Add Reward';

  @override
  String get rewardName => 'Reward Name';

  @override
  String get rewardTier => 'Reward Tier';

  @override
  String get rewardHistory => 'Reward History';

  @override
  String get noRewardsYet => 'No rewards claimed yet';

  @override
  String get streakFreeze => 'Streak Freeze';

  @override
  String get streakFreezeUsed => 'Streak freeze used this week';

  @override
  String get useStreakFreeze => 'Use Streak Freeze';

  @override
  String get multiplier => 'Multiplier';

  @override
  String activeMultiplier(String mult) {
    return '${mult}x multiplier active!';
  }

  @override
  String get error => 'Error';

  @override
  String get success => 'Success';

  @override
  String get loading => 'Loading...';

  @override
  String get noData => 'No data available';

  @override
  String get confirmDelete => 'Are you sure you want to delete this?';

  @override
  String get windDownReminder => 'Time to wind down for bed!';

  @override
  String get bedtimeReminder => 'Bedtime reminder';

  @override
  String get wakeUpReminder => 'Time to wake up!';

  @override
  String get drinkWater => 'Don\'t forget to drink water!';

  @override
  String get logExpenses => 'Log your recent expenses';

  @override
  String get checkTasks => 'Check your remaining tasks';
}
