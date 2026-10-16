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
  String get pending => 'Pending';

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
  String get budgetWarning => 'Budget Warning';

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

  @override
  String get all => 'All';

  @override
  String get giftIdeas => 'Gift Ideas 🎁';

  @override
  String get sheLikes => 'She Likes ✨';

  @override
  String get notesCategory => 'Notes 📝';

  @override
  String pointsDailyReward(int points) {
    return '+$points points daily reward';
  }

  @override
  String get qualityTimeSuccess => 'Quality Time logged! +15 points earned ❤️';

  @override
  String deleteOccasionConfirm(String name) {
    return 'Delete occasion \"$name\"? Scheduled notifications will also be cancelled.';
  }

  @override
  String get noBackupYet => 'No backup performed yet';

  @override
  String lastBackupLabel(String time) {
    return 'Last backup: $time';
  }

  @override
  String get restoreJsonDesc => 'Restore all boxes from JSON backup file';

  @override
  String get devTools => 'Developer Tools';

  @override
  String get seedMockData => 'Seed Mock Data';

  @override
  String get seedMockDataDesc => 'Fill all modules with sample test data';

  @override
  String get seedDataButton => 'Seed Data';

  @override
  String get mockDataSeededSuccess => 'Mock test data seeded successfully!';

  @override
  String get sideloadBackupReminder => 'iOS Sideload Backup Reminder';

  @override
  String get sideloadBackupReminderDesc =>
      'Export backup weekly to protect your data across 7-day sideload certificates (AltStore/SideStore).';

  @override
  String get backupFresh => 'Backup is fresh.';

  @override
  String get backupRecommended =>
      '⚠️ Refresh certificate & backup recommended!';

  @override
  String get preferences => 'Preferences';

  @override
  String get recommended => 'Recommended';

  @override
  String get restoreConfirmTitle => 'Restore Backup?';

  @override
  String get restoreConfirmDesc =>
      'Restoring data from a backup file will replace current local data with the backup contents. Do you want to proceed?';

  @override
  String get proceed => 'Proceed';

  @override
  String get backupExportedSuccess => 'Backup exported successfully!';

  @override
  String get backupRestoredSuccess => 'Backup restored successfully!';

  @override
  String exportFailed(String error) {
    return 'Export failed: $error';
  }

  @override
  String restoreFailed(String error) {
    return 'Restore failed: $error';
  }

  @override
  String seedingFailed(String error) {
    return 'Seeding failed: $error';
  }

  @override
  String get dayBoundaryHourTitle => 'Day Boundary Hour';

  @override
  String get dayBoundaryDesc =>
      'Select when your productivity day flips (e.g. 4:00 AM allows night owls to finish tasks before next day resets).';

  @override
  String recordsCount(int count) {
    return '$count records';
  }

  @override
  String get endOfDayRolloverBonus => 'End-of-Day Rollover (+15 pts)';

  @override
  String get rolloverDisabledZero => 'Starting balance must be greater than 0';

  @override
  String get rolloverDisabledAlready => 'Rollover already completed today';

  @override
  String get rolloverDisabledDeficit => 'Daily budget was exceeded';

  @override
  String rolloverDialogContent(String amount, String currency) {
    return 'You have $amount $currency remaining.\n\nChoose how you want to handle your leftover balance:';
  }

  @override
  String get keepForTomorrow => 'Keep for Tomorrow';

  @override
  String get sendToSavingsVault => 'Send to Savings Vault';

  @override
  String get rolledToTomorrowSuccess =>
      'Rolled to tomorrow\'s starting balance! +15 pts earned 🎉';

  @override
  String get rolledToSavingsSuccess =>
      'Transferred to Savings Vault! +15 pts earned 💰';

  @override
  String get lifestyleDailyScore => 'Lifestyle Daily Score';

  @override
  String pointsEarnedToday(int points) {
    return '+$points points earned today';
  }

  @override
  String cupsTarget(int current, int target) {
    return '$current / $target cups';
  }

  @override
  String get goalReached => '🎯 Goal reached!';

  @override
  String mealsLoggedCount(int count) {
    return '$count meals logged (+5 pts each)';
  }

  @override
  String get sleepWakeGoals => 'Sleep & Wake Goals';

  @override
  String get pointsForSleepingOnTime => '+10 points for sleeping on time';

  @override
  String get pointsForWakingOnTime => '+10 points for waking on time';

  @override
  String get pointsWhenCompleted => '+20 pts when completed';

  @override
  String get completedWithPoints => 'Completed (+20 pts)';

  @override
  String get recentActivity => 'Recent Activity';

  @override
  String get noActivityToday => 'No activity logged today yet.';

  @override
  String get activityWater => 'Drank 1 cup of water';

  @override
  String get activityMeal => 'Healthy meal (+5 pts)';

  @override
  String get activityWorkout => 'Workout session completed (+20 pts)';

  @override
  String get activitySleep => 'Slept on time (+10 pts)';

  @override
  String get activityWake => 'Woke up on time (+10 pts)';

  @override
  String get activityLogged => 'Activity logged';

  @override
  String get passed => 'Passed';

  @override
  String daysLeft(int days) {
    return '$days days left';
  }

  @override
  String get todayExclamation => 'Today!';

  @override
  String get prepTimeCommuteTitle => 'Preparation & Commute Time';

  @override
  String get prepTimeCommuteDesc =>
      'How many minutes you need before your first morning lecture or task.';

  @override
  String minutesCount(int minutes) {
    return '$minutes minutes';
  }

  @override
  String get setBudget => 'Set Budget';

  @override
  String get budgetLimitsAlerts => 'Budget Limits & Alerts';

  @override
  String weeklyBudgetCurrency(String currency) {
    return 'Weekly Budget ($currency)';
  }

  @override
  String monthlyBudgetCurrency(String currency) {
    return 'Monthly Budget ($currency)';
  }

  @override
  String deleteExpenseConfirm(String category, String amount, String currency) {
    return 'Delete $category expense of $amount $currency?';
  }

  @override
  String get newDailyStartingBalance => 'New Daily Starting Balance';

  @override
  String get giftIdeaNoteHint =>
      'e.g. Favorite perfume, bracelet size, flowers she loves...';

  @override
  String get universityTimetable => 'University Timetable';

  @override
  String get subjects => 'Subjects';

  @override
  String get addSubject => 'Add Subject';

  @override
  String get editSubject => 'Edit Subject';

  @override
  String get subjectName => 'Subject Name';

  @override
  String get color => 'Color';

  @override
  String get examDate => 'Exam Date';

  @override
  String get noSubjectsYet => 'No subjects added yet';

  @override
  String get addSession => 'Add Session';

  @override
  String get sessionType => 'Session Type';

  @override
  String get lecture => 'Lecture';

  @override
  String get section => 'Section';

  @override
  String get lab => 'Lab';

  @override
  String get weekday => 'Weekday';

  @override
  String get startTime => 'Start Time';

  @override
  String get endTime => 'End Time';

  @override
  String get location => 'Location (optional)';

  @override
  String get invalidTimeRange => 'End time must be after start time';

  @override
  String get sessionOverlapWarning =>
      'Warning: This session overlaps with another session!';

  @override
  String get commuteQuestion =>
      'How long will it take you to get to university today?';

  @override
  String get studyQuestion => 'Which subject will you study today?';

  @override
  String get noStudyToday => 'No study today';

  @override
  String get timelineWakeUp => 'Wake Up';

  @override
  String get timelineLeaveHome => 'Leave Home';

  @override
  String get timelineReturnHome => 'Return Home';

  @override
  String get timelineBedtime => 'Bedtime';

  @override
  String freeWindow(int minutes) {
    return 'Free Window (${minutes}m)';
  }

  @override
  String suggestedStudy(int minutes) {
    return 'Suggested Study (${minutes}m)';
  }

  @override
  String get attendanceChecklist => 'Attendance Checklist';

  @override
  String get attended => 'Attended';

  @override
  String attendedPoints(int points) {
    return '+$points pts';
  }

  @override
  String get attendanceBeforeStart => 'Attendance allowed after session starts';

  @override
  String get alreadyAttended => 'Already marked as attended';

  @override
  String get nowCard => 'Happening Now';

  @override
  String get nextCard => 'Up Next';

  @override
  String startsIn(String time) {
    return 'Starts in $time';
  }

  @override
  String endsIn(String time) {
    return 'Ends in $time';
  }

  @override
  String get noUpcomingSessions => 'No more sessions today';

  @override
  String get weeklyAttendanceRate => 'Weekly Attendance Rate';

  @override
  String get geminiApiKey => 'Gemini API Key';

  @override
  String get testKey => 'Test Key';

  @override
  String get keyValid => 'API Key is valid!';

  @override
  String get keyInvalid => 'Invalid API Key or API error';

  @override
  String get requireProofForPoints => 'Require proof for points';

  @override
  String get requireProofSubtitle =>
      'Verify study & arrival with AI photo or GPS';

  @override
  String get saveUniversityLocation => 'Save University Location';

  @override
  String get locationSaved => 'University location saved successfully!';

  @override
  String allowedRadius(int meters) {
    return 'Allowed Radius: ${meters}m';
  }

  @override
  String get takeProof => 'Take Proof';

  @override
  String get proofVerified => 'Proof Verified! Points Awarded 🎉';

  @override
  String proofRejected(String reason) {
    return 'Proof Rejected: $reason';
  }

  @override
  String proofUnclear(String reason, int attempts) {
    return 'Proof Unclear: $reason. Attempts remaining: $attempts';
  }

  @override
  String get proofPendingOffline =>
      'No internet connection. Proof queued for verification.';

  @override
  String get proofPrivacyNotice =>
      'Photos taken are sent securely to Google Gemini for verification and deleted immediately after analysis. No photos are stored on servers.';

  @override
  String get proofLogs => 'Proof History';

  @override
  String get noProofLogs => 'No proof logs recorded yet';

  @override
  String locationMismatchFallback(int distance) {
    return 'You are outside the university campus (${distance}m away). Please provide a photo proof instead.';
  }

  @override
  String get locationPermissionDenied =>
      'Location permission denied. Please provide a photo proof instead.';

  @override
  String get occasionType => 'Occasion Type';

  @override
  String get customCelebration => 'Custom Celebration';

  @override
  String get date => 'Date';

  @override
  String get change => 'Change';

  @override
  String get repeatYearlyDesc => 'Auto-renews next year after passing';

  @override
  String get yearly => 'Yearly';

  @override
  String get fianceeNamePlaceholder => 'My Fiancée';

  @override
  String get editFianceeName => 'Edit Fiancée\'s Name';

  @override
  String get enterFianceeName => 'Enter name';

  @override
  String get fianceeNameUpdated => 'Name updated successfully';
}
