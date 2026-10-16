class AppConstants {
  // Hive box names
  static const String settingsBox = 'settings_box';
  static const String gamificationBox = 'gamification_box';
  static const String scheduleBox = 'schedule_box';
  static const String fianceeBox = 'fiancee_box';
  static const String financeBox = 'finance_box';
  static const String lifestyleBox = 'lifestyle_box';
  static const String ledgerBox = 'ledger_box';
  static const String rewardsBox = 'rewards_box';
  static const String claimedRewardsBox = 'claimed_rewards_box';
  static const String subjectsBox = 'subjects_box';
  static const String timetableBox = 'timetable_box';
  static const String attendanceBox = 'attendance_box';
  static const String studyLogsBox = 'study_logs_box';
  static const String proofLogsBox = 'proof_logs_box';
  static const String pendingProofBox = 'pending_proof_box';
  
  // Settings keys
  static const String themeKey = 'theme_mode';
  static const String languageKey = 'language_code';
  static const String dayBoundaryKey = 'day_boundary_hour';
  static const String prepTimeKey = 'prep_time_minutes';
  static const String lastCommuteKey = 'last_commute_minutes';
  static const String currencyKey = 'currency';
  static const String onboardingCompleteKey = 'onboarding_complete';
  static const String biometricEnabledKey = 'biometric_enabled';
  static const String startingBalanceKey = 'starting_balance';
  static const String weeklyBudgetKey = 'weekly_budget';
  static const String monthlyBudgetKey = 'monthly_budget';
  static const String savingsVaultKey = 'savings_vault';
  static const String streakFreezeWeekKey = 'streak_freeze_week';
  static const String lastBackupKey = 'last_backup_date';
  static const String lastRolloverKey = 'last_rollover_date';
  static const String geminiApiKey = 'gemini_api_key';
  static const String requireProofKey = 'require_proof_for_points';
  static const String universityLatKey = 'university_latitude';
  static const String universityLngKey = 'university_longitude';
  static const String universityRadiusKey = 'university_radius';
  static const String fianceeNameKey = 'fiancee_name';
  
  // Defaults
  static const int defaultDayBoundaryHour = 4;
  static const int defaultPrepTimeMinutes = 90;
  static const String defaultCurrency = 'EGP';
  static const String defaultLocale = 'en';
  static const int defaultUniversityRadius = 300;
  
  // Points
  static const int bronzePointsCost = 50;
  static const int silverPointsCost = 100;
  static const int goldPointsCost = 200;
  static const int taskCompletionPoints = 10;
  static const int pomodoroPoints = 20;
  static const int qualityTimePoints = 15;
  static const int sleepOnTimePoints = 10;
  static const int wakeOnTimePoints = 10;
  static const int healthyMealPoints = 5;
  static const int gymSessionPoints = 20;
  static const int endOfDayRolloverPoints = 15;
  static const int attendanceLecturePoints = 10;
  static const int attendanceSectionPoints = 10;
  static const int attendanceLabPoints = 10;
  static const int streakMultiplierThreshold = 3;
  
  // Notifications
  static const int maxPendingNotifications = 64;
  static const int notificationWindowDays = 7;
  static const String cairoTimezone = 'Africa/Cairo';
  
  // Pomodoro
  static const int pomodoroShortMinutes = 25;
  static const int pomodoroLongMinutes = 45;
  
  // Backup
  static const int schemaVersion = 2;
  static const int backupReminderDays = 7;
}
