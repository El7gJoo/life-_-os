// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'نظام الحياة';

  @override
  String get dashboard => 'لوحة التحكم';

  @override
  String get gamification => 'المكافآت';

  @override
  String get schedule => 'الجدول';

  @override
  String get fiancee => 'ركن الخطيبة';

  @override
  String get finance => 'المالية';

  @override
  String get lifestyle => 'أسلوب الحياة';

  @override
  String get stats => 'الإحصائيات';

  @override
  String get settings => 'الإعدادات';

  @override
  String get onboarding => 'مرحباً';

  @override
  String get points => 'نقاط';

  @override
  String get streak => 'السلسلة';

  @override
  String streakDays(int count) {
    return 'سلسلة $count يوم';
  }

  @override
  String get currentPoints => 'النقاط الحالية';

  @override
  String get totalPoints => 'إجمالي النقاط';

  @override
  String get bronze => 'برونز';

  @override
  String get silver => 'فضة';

  @override
  String get gold => 'ذهب';

  @override
  String get redeem => 'استبدال';

  @override
  String get redeemReward => 'استبدال المكافأة';

  @override
  String get rewardUnlocked => 'تم فتح المكافأة!';

  @override
  String get congratulations => 'تهانينا!';

  @override
  String get youEarned => 'حصلت على:';

  @override
  String get close => 'إغلاق';

  @override
  String get cancel => 'إلغاء';

  @override
  String get save => 'حفظ';

  @override
  String get delete => 'حذف';

  @override
  String get edit => 'تعديل';

  @override
  String get add => 'إضافة';

  @override
  String get done => 'تم';

  @override
  String get pending => 'قيد الانتظار';

  @override
  String get undo => 'تراجع';

  @override
  String get snooze => 'تأجيل ساعة';

  @override
  String get today => 'اليوم';

  @override
  String get tomorrow => 'غداً';

  @override
  String get yesterday => 'أمس';

  @override
  String get morning => 'صباح';

  @override
  String get evening => 'مساء';

  @override
  String get goodMorning => 'صباح الخير!';

  @override
  String get morningCheckIn => 'تسجيل الصباح';

  @override
  String get morningCheckInMessage =>
      'هل لديك أي مهام إضافية خارج جدولك المعتاد اليوم؟';

  @override
  String get addTask => 'إضافة مهمة';

  @override
  String get taskName => 'اسم المهمة';

  @override
  String get noTasksToday => 'لا توجد مهام اليوم';

  @override
  String get completeTask => 'إكمال المهمة';

  @override
  String get taskCompleted => 'تم إكمال المهمة!';

  @override
  String askBeforeDeducting(int points) {
    return 'لديك $points نقطة!';
  }

  @override
  String spendNow(int amount, String tier) {
    return 'إنفاق $amount نقطة على $tier';
  }

  @override
  String get keepSaving => 'الاستمرار في الادخار';

  @override
  String get language => 'اللغة';

  @override
  String get english => 'الإنجليزية';

  @override
  String get arabic => 'العربية';

  @override
  String get theme => 'المظهر';

  @override
  String get themeSystem => 'النظام';

  @override
  String get themeLight => 'فاتح';

  @override
  String get themeDark => 'داكن';

  @override
  String get dayBoundary => 'يبدأ اليوم في';

  @override
  String get dayBoundaryHint => 'الافتراضي: 4 صباحاً';

  @override
  String get prepTime => 'وقت التحضير والتنقل';

  @override
  String prepTimeMinutes(int minutes) {
    return '$minutes دقيقة';
  }

  @override
  String get currency => 'العملة';

  @override
  String get backup => 'نسخ احتياطي';

  @override
  String get restore => 'استعادة';

  @override
  String get exportData => 'تصدير البيانات';

  @override
  String get importData => 'استيراد البيانات';

  @override
  String get backupNow => 'نسخ احتياطي الآن';

  @override
  String get backupReminder => 'حان وقت نسخ بياناتك احتياطياً!';

  @override
  String get dataExported => 'تم تصدير البيانات بنجاح';

  @override
  String get dataImported => 'تم استيراد البيانات بنجاح';

  @override
  String get fianceeHub => 'ركن الخطيبة';

  @override
  String get qualityTime => 'وقت جودة';

  @override
  String get occasions => 'المناسبات';

  @override
  String get giftVault => 'خزنة الهدايا';

  @override
  String get notes => 'ملاحظات';

  @override
  String get addOccasion => 'إضافة مناسبة';

  @override
  String get occasionName => 'اسم المناسبة';

  @override
  String get occasionDate => 'تاريخ المناسبة';

  @override
  String daysUntil(int days) {
    return '$days يوم حتى';
  }

  @override
  String hoursUntil(int hours) {
    return '$hours ساعة حتى';
  }

  @override
  String get repeatYearly => 'تكرار سنوي';

  @override
  String get birthday => 'عيد ميلاد';

  @override
  String get anniversary => 'ذكرى سنوية';

  @override
  String get plannedDate => 'موعد مخطط';

  @override
  String get custom => 'مخصص';

  @override
  String get biometricLock => 'القفل البيومتري';

  @override
  String get enableBiometric => 'تفعيل القفل البيومتري';

  @override
  String get authenticateToAccess => 'المصادقة للوصول إلى ركن الخطيبة';

  @override
  String get pocketTracker => 'متتبع الجيب';

  @override
  String get startingBalance => 'الرصيد الأولي';

  @override
  String get totalSpent => 'إجمالي الإنفاق';

  @override
  String get remaining => 'المتبقي';

  @override
  String get addExpense => 'إضافة مصروف';

  @override
  String get amount => 'المبلغ';

  @override
  String get category => 'الفئة';

  @override
  String get note => 'ملاحظة';

  @override
  String get gasFuel => 'وقود';

  @override
  String get universityFood => 'طعام الجامعة';

  @override
  String get coffeeDrinks => 'قهوة/مشروبات';

  @override
  String get transport => 'مواصلات';

  @override
  String get other => 'أخرى';

  @override
  String get exportCSV => 'تصدير CSV';

  @override
  String get budget => 'الميزانية';

  @override
  String get weeklyBudget => 'الميزانية الأسبوعية';

  @override
  String get monthlyBudget => 'الميزانية الشهرية';

  @override
  String budgetAlert(int percent) {
    return 'لقد استخدمت $percent٪ من ميزانيتك';
  }

  @override
  String get budgetWarning => 'تحذير الميزانية';

  @override
  String get rolloverSavings => 'نقل إلى خزنة الادخار';

  @override
  String get rolloverTomorrow => 'نقل إلى رصيد الغد';

  @override
  String get savings => 'المدخرات';

  @override
  String get schedule2 => 'الجدول والدراسة';

  @override
  String get pomodoro => 'بومودورو';

  @override
  String get startPomodoro => 'بدء البومودورو';

  @override
  String get pomodoroComplete => 'اكتمل البومودورو!';

  @override
  String get sleepCalculator => 'حاسبة النوم';

  @override
  String get targetBedtime => 'وقت النوم المستهدف';

  @override
  String get targetWakeUp => 'وقت الاستيقاظ المستهدف';

  @override
  String get emergencyShift => 'تأجيل +ساعة';

  @override
  String get emergencyShiftConfirm => 'تأجيل جميع المهام المتبقية بساعة واحدة؟';

  @override
  String get yes => 'نعم';

  @override
  String get no => 'لا';

  @override
  String get addLecture => 'إضافة محاضرة';

  @override
  String get lectureName => 'اسم المحاضرة';

  @override
  String get lectureTime => 'وقت المحاضرة';

  @override
  String get recurrence => 'التكرار';

  @override
  String weeklyOn(String day) {
    return 'أسبوعياً $day';
  }

  @override
  String get meals => 'الوجبات';

  @override
  String get water => 'الماء';

  @override
  String get workout => 'التمرين';

  @override
  String get healthyMeal => 'وجبة صحية';

  @override
  String waterCups(int cups) {
    return '$cups كوب';
  }

  @override
  String get addWater => 'إضافة ماء';

  @override
  String get gymSession => 'جلسة رياضية';

  @override
  String get weeklyStats => 'إحصائيات أسبوعية';

  @override
  String get monthlyStats => 'إحصائيات شهرية';

  @override
  String get spendingByCategory => 'الإنفاق حسب الفئة';

  @override
  String get pointsOverTime => 'النقاط عبر الزمن';

  @override
  String get studyConsistency => 'انتظام الدراسة';

  @override
  String get gymConsistency => 'انتظام الرياضة';

  @override
  String get onboardingWelcome => 'مرحباً بك في نظام الحياة';

  @override
  String get onboardingSubtitle => 'نظامك الشخصي للإنتاجية المدعوم بالألعاب';

  @override
  String get onboardingLanguage => 'اختر لغتك';

  @override
  String get onboardingTheme => 'اختر مظهرك';

  @override
  String get onboardingPrepTime => 'حدد وقت التحضير والتنقل';

  @override
  String get onboardingCurrency => 'حدد عملتك';

  @override
  String get onboardingDayBoundary => 'متى يبدأ يومك الجديد؟';

  @override
  String get getStarted => 'ابدأ';

  @override
  String get next => 'التالي';

  @override
  String get back => 'رجوع';

  @override
  String get skip => 'تخطي';

  @override
  String get manageRewards => 'إدارة المكافآت';

  @override
  String get addReward => 'إضافة مكافأة';

  @override
  String get rewardName => 'اسم المكافأة';

  @override
  String get rewardTier => 'مستوى المكافأة';

  @override
  String get rewardHistory => 'سجل المكافآت';

  @override
  String get noRewardsYet => 'لا توجد مكافآت مطالب بها بعد';

  @override
  String get streakFreeze => 'تجميد السلسلة';

  @override
  String get streakFreezeUsed => 'تم استخدام تجميد السلسلة هذا الأسبوع';

  @override
  String get useStreakFreeze => 'استخدام تجميد السلسلة';

  @override
  String get multiplier => 'المضاعف';

  @override
  String activeMultiplier(String mult) {
    return 'مضاعف ${mult}x نشط!';
  }

  @override
  String get error => 'خطأ';

  @override
  String get success => 'نجاح';

  @override
  String get loading => 'جاري التحميل...';

  @override
  String get noData => 'لا توجد بيانات';

  @override
  String get confirmDelete => 'هل أنت متأكد من الحذف؟';

  @override
  String get windDownReminder => 'حان وقت الاسترخاء قبل النوم!';

  @override
  String get bedtimeReminder => 'تذكير بوقت النوم';

  @override
  String get wakeUpReminder => 'حان وقت الاستيقاظ!';

  @override
  String get drinkWater => 'لا تنسَ شرب الماء!';

  @override
  String get logExpenses => 'سجّل مصروفاتك الأخيرة';

  @override
  String get checkTasks => 'تحقق من مهامك المتبقية';

  @override
  String get all => 'الكل';

  @override
  String get giftIdeas => 'أفكار هدايا 🎁';

  @override
  String get sheLikes => 'أشياء تحبها ✨';

  @override
  String get notesCategory => 'ملاحظات 📝';

  @override
  String pointsDailyReward(int points) {
    return '+$points نقطة مكافأة يومية';
  }

  @override
  String get qualityTimeSuccess => 'تم تسجيل وقت الجودة! حصلت على +15 نقطة ❤️';

  @override
  String deleteOccasionConfirm(String name) {
    return 'هل تريد حذف مناسبة \"$name\"؟ سيتم أيضاً إلغاء الإشعارات المجدولة.';
  }

  @override
  String get noBackupYet => 'لم يتم إجراء نسخ احتياطي بعد';

  @override
  String lastBackupLabel(String time) {
    return 'آخر نسخ احتياطي: $time';
  }

  @override
  String get restoreJsonDesc =>
      'استعادة جميع البيانات من ملف النسخ الاحتياطي JSON';

  @override
  String get devTools => 'أدوات المطور';

  @override
  String get seedMockData => 'توليد بيانات تجريبية';

  @override
  String get seedMockDataDesc => 'ملء جميع الأقسام ببيانات تجريبية';

  @override
  String get seedDataButton => 'توليد البيانات';

  @override
  String get mockDataSeededSuccess => 'تم توليد البيانات التجريبية بنجاح!';

  @override
  String get sideloadBackupReminder => 'تذكير النسخ الاحتياطي لتثبيت iOS';

  @override
  String get sideloadBackupReminderDesc =>
      'قم بتصدير النسخ الاحتياطي أسبوعياً لحماية بياناتك خلال فترة شهادة التثبيت 7 أيام.';

  @override
  String get backupFresh => 'النسخة الاحتياطية حديثة.';

  @override
  String get backupRecommended => '⚠️ يوصى بتحديث الشهادة والنسخ الاحتياطي!';

  @override
  String get preferences => 'التفضيلات';

  @override
  String get recommended => 'موصى به';

  @override
  String get restoreConfirmTitle => 'استعادة النسخة الاحتياطية؟';

  @override
  String get restoreConfirmDesc =>
      'ستؤدي استعادة البيانات إلى استبدال البيانات الحالية بمحتويات النسخة الاحتياطية. هل تريد المتابعة؟';

  @override
  String get proceed => 'متابعة';

  @override
  String get backupExportedSuccess => 'تم تصدير النسخة الاحتياطية بنجاح!';

  @override
  String get backupRestoredSuccess => 'تمت استعادة النسخة الاحتياطية بنجاح!';

  @override
  String exportFailed(String error) {
    return 'فشل التصدير: $error';
  }

  @override
  String restoreFailed(String error) {
    return 'فشلت الاستعادة: $error';
  }

  @override
  String seedingFailed(String error) {
    return 'فشل توليد البيانات: $error';
  }

  @override
  String get dayBoundaryHourTitle => 'ساعة بداية اليوم';

  @override
  String get dayBoundaryDesc =>
      'اختر وقت تجدد يوم الإنتاجية (مثلاً 4:00 ص يتيح لرواد الليل إنهاء مهامهم قبل إعادة ضبط اليوم التالي).';

  @override
  String recordsCount(int count) {
    return '$count سجلات';
  }

  @override
  String get endOfDayRolloverBonus => 'ترحيل نهاية اليوم (+15 نقطة)';

  @override
  String get rolloverDisabledZero =>
      'يجب أن يكون الرصيد الأولي أكبر من 0 للترحيل';

  @override
  String get rolloverDisabledAlready => 'تم إجراء الترحيل لهذا اليوم بالفعل';

  @override
  String get rolloverDisabledDeficit => 'تم تجاوز الميزانية اليومية';

  @override
  String rolloverDialogContent(String amount, String currency) {
    return 'لديك $amount $currency متبقية.\n\nاختر كيف ترغب في التعامل مع المبلغ المتبقي:';
  }

  @override
  String get keepForTomorrow => 'الاحتفاظ للغد';

  @override
  String get sendToSavingsVault => 'إرسال إلى خزنة الادخار';

  @override
  String get rolledToTomorrowSuccess =>
      'تم الترحيل إلى رصيد الغد! حصلت على +15 نقطة 🎉';

  @override
  String get rolledToSavingsSuccess =>
      'تم التحويل إلى خزنة الادخار! حصلت على +15 نقطة 💰';

  @override
  String get lifestyleDailyScore => 'نقاط أسلوب الحياة اليومية';

  @override
  String pointsEarnedToday(int points) {
    return 'تم كسب +$points نقطة اليوم';
  }

  @override
  String cupsTarget(int current, int target) {
    return '$current / $target أكواب';
  }

  @override
  String get goalReached => '🎯 تم الوصول للهدف!';

  @override
  String mealsLoggedCount(int count) {
    return 'تم تسجيل $count وجبات (+5 نقاط لكل منها)';
  }

  @override
  String get sleepWakeGoals => 'أهداف النوم والاستيقاظ';

  @override
  String get pointsForSleepingOnTime => '+10 نقاط للنوم في الوقت المحدد';

  @override
  String get pointsForWakingOnTime => '+10 نقاط للاستيقاظ في الوقت المحدد';

  @override
  String get pointsWhenCompleted => '+20 نقطة عند الإكمال';

  @override
  String get completedWithPoints => 'مكتمل (+20 نقطة)';

  @override
  String get recentActivity => 'النشاط الأخير';

  @override
  String get noActivityToday => 'لم يتم تسجيل أي نشاط اليوم بعد.';

  @override
  String get activityWater => 'شربت كوب ماء';

  @override
  String get activityMeal => 'وجبة صحية (+5 نقاط)';

  @override
  String get activityWorkout => 'اكتمل التمرين (+20 نقطة)';

  @override
  String get activitySleep => 'نمت في الوقت المحدد (+10 نقاط)';

  @override
  String get activityWake => 'استيقظت في الوقت المحدد (+10 نقاط)';

  @override
  String get activityLogged => 'تم تسجيل النشاط';

  @override
  String get passed => 'فاتت';

  @override
  String daysLeft(int days) {
    return 'متبقي $days يوم';
  }

  @override
  String get todayExclamation => 'اليوم!';

  @override
  String get prepTimeCommuteTitle => 'وقت التحضير والتنقل';

  @override
  String get prepTimeCommuteDesc =>
      'كم دقيقة تحتاج قبل أول محاضرة أو مهمة صباحية.';

  @override
  String minutesCount(int minutes) {
    return '$minutes دقيقة';
  }

  @override
  String get setBudget => 'تحديد الميزانية';

  @override
  String get budgetLimitsAlerts => 'حدود الميزانية والتنبيهات';

  @override
  String weeklyBudgetCurrency(String currency) {
    return 'الميزانية الأسبوعية ($currency)';
  }

  @override
  String monthlyBudgetCurrency(String currency) {
    return 'الميزانية الشهرية ($currency)';
  }

  @override
  String deleteExpenseConfirm(String category, String amount, String currency) {
    return 'حذف مصروف $category بقيمة $amount $currency؟';
  }

  @override
  String get newDailyStartingBalance => 'الرصيد الأولي اليومي الجديد';

  @override
  String get giftIdeaNoteHint =>
      'مثال: العطر المفضل، مقاس السوار، الزهور التي تحبها...';

  @override
  String get universityTimetable => 'الجدول الجامعي';

  @override
  String get subjects => 'المواد';

  @override
  String get addSubject => 'إضافة مادة';

  @override
  String get editSubject => 'تعديل مادة';

  @override
  String get subjectName => 'اسم المادة';

  @override
  String get color => 'اللون';

  @override
  String get examDate => 'تاريخ الامتحان';

  @override
  String get noSubjectsYet => 'لم تتم إضافة مواد بعد';

  @override
  String get addSession => 'إضافة جلسة';

  @override
  String get sessionType => 'نوع الجلسة';

  @override
  String get lecture => 'محاضرة';

  @override
  String get section => 'سكشن';

  @override
  String get lab => 'معمل';

  @override
  String get weekday => 'اليوم';

  @override
  String get startTime => 'وقت البدء';

  @override
  String get endTime => 'وقت الانتهاء';

  @override
  String get location => 'المكان (اختياري)';

  @override
  String get invalidTimeRange => 'يجب أن يكون وقت الانتهاء بعد وقت البدء';

  @override
  String get sessionOverlapWarning => 'تحذير: هذه الجلسة تتداخل مع جلسة أخرى!';

  @override
  String get commuteQuestion => 'كم من الوقت سيستغرق وصولك إلى الجامعة اليوم؟';

  @override
  String get studyQuestion => 'ما المادة التي ستدرسها اليوم؟';

  @override
  String get noStudyToday => 'لا دراسة اليوم';

  @override
  String get timelineWakeUp => 'الاستيقاظ';

  @override
  String get timelineLeaveHome => 'مغادرة المنزل';

  @override
  String get timelineReturnHome => 'العودة للمنزل';

  @override
  String get timelineBedtime => 'وقت النوم';

  @override
  String freeWindow(int minutes) {
    return 'وقت فراغ ($minutes د)';
  }

  @override
  String suggestedStudy(int minutes) {
    return 'دراسة مقترحة ($minutes د)';
  }

  @override
  String get attendanceChecklist => 'تسجيل الحضور';

  @override
  String get attended => 'تم الحضور';

  @override
  String attendedPoints(int points) {
    return '+$points نقطة';
  }

  @override
  String get attendanceBeforeStart => 'يسمح بالحضور بعد بدء الجلسة';

  @override
  String get alreadyAttended => 'تم تسجيل الحضور بالفعل';

  @override
  String get nowCard => 'يحدث الآن';

  @override
  String get nextCard => 'التالي';

  @override
  String startsIn(String time) {
    return 'يبدأ خلال $time';
  }

  @override
  String endsIn(String time) {
    return 'ينتهي خلال $time';
  }

  @override
  String get noUpcomingSessions => 'لا توجد جلسات أخرى اليوم';

  @override
  String get weeklyAttendanceRate => 'نسبة الحضور الأسبوعية';

  @override
  String get geminiApiKey => 'مفتاح Gemini API';

  @override
  String get testKey => 'اختبار المفتاح';

  @override
  String get keyValid => 'المفتاح صالح!';

  @override
  String get keyInvalid => 'مفتاح غير صالح أو خطأ بالخدمة';

  @override
  String get requireProofForPoints => 'طلب إثبات للنقاط';

  @override
  String get requireProofSubtitle =>
      'التحقق من الدراسة والوصول بالذكاء الاصطناعي أو الموقع';

  @override
  String get saveUniversityLocation => 'حفظ موقع الجامعة';

  @override
  String get locationSaved => 'تم حفظ موقع الجامعة بنجاح!';

  @override
  String allowedRadius(int meters) {
    return 'النطاق المسموح: $meters متر';
  }

  @override
  String get takeProof => 'التقاط إثبات';

  @override
  String get proofVerified => 'تم التحقق من الإثبات! تم منح النقاط 🎉';

  @override
  String proofRejected(String reason) {
    return 'تم رفض الإثبات: $reason';
  }

  @override
  String proofUnclear(String reason, int attempts) {
    return 'الإثبات غير واضح: $reason. المحاولات المتبقية: $attempts';
  }

  @override
  String get proofPendingOffline =>
      'لا يوجد اتصال بالإنترنت. تم حفظ الإثبات للتحقق لاحقاً.';

  @override
  String get proofPrivacyNotice =>
      'الصور الملتقطة تُرسل بأمان إلى Google Gemini للتحقق وتُحذف فوراً بعد التحليل. لا يتم تخزين أي صور على خوادم خارجية.';

  @override
  String get proofLogs => 'سجل الإثباتات';

  @override
  String get noProofLogs => 'لا يوجد سجل إثباتات بعد';

  @override
  String locationMismatchFallback(int distance) {
    return 'أنت خارج الحرم الجامعي (على بعد $distance متر). يرجى تقديم إثبات بالصورة بدلاً من ذلك.';
  }

  @override
  String get locationPermissionDenied =>
      'تم رفض إذن الوصول للموقع. يرجى تقديم إثبات بالصورة.';

  @override
  String get occasionType => 'نوع المناسبة';

  @override
  String get customCelebration => 'احتفال مخصص';

  @override
  String get date => 'التاريخ';

  @override
  String get change => 'تغيير';

  @override
  String get repeatYearlyDesc => 'يتجدد تلقائياً العام القادم بعد انتهائه';

  @override
  String get yearly => 'سنوياً';

  @override
  String get fianceeNamePlaceholder => 'خطيبتي';

  @override
  String get editFianceeName => 'تعديل اسم الخطيبة';

  @override
  String get enterFianceeName => 'أدخل الاسم';

  @override
  String get fianceeNameUpdated => 'تم تحديث الاسم بنجاح';
}
