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
}
