import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'core/constants/app_constants.dart';
import 'core/di/injection.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_cubit.dart';
import 'features/dashboard/presentation/screens/dashboard_screen.dart';
import 'features/fiancee/presentation/cubits/fiancee_cubit.dart';
import 'features/fiancee/presentation/screens/fiancee_screen.dart';
import 'features/finance/presentation/cubits/finance_cubit.dart';
import 'features/finance/presentation/screens/finance_screen.dart';
import 'features/gamification/presentation/cubits/gamification_cubit.dart';
import 'features/gamification/presentation/screens/gamification_screen.dart';
import 'features/lifestyle/presentation/cubits/lifestyle_cubit.dart';
import 'features/lifestyle/presentation/screens/lifestyle_screen.dart';
import 'features/onboarding/presentation/screens/onboarding_screen.dart';
import 'features/schedule_study/presentation/cubits/schedule_cubit.dart';
import 'features/schedule_study/presentation/screens/schedule_screen.dart';
import 'features/settings_backup/presentation/cubits/settings_cubit.dart';
import 'features/settings_backup/presentation/cubits/settings_state.dart';
import 'l10n/app_localizations.dart';
import 'features/gamification/data/repositories/gamification_repository.dart';
import 'services/notification_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize timezone
  tz.initializeTimeZones();

  // Initialize Hive
  await Hive.initFlutter();

  // Open all Hive boxes
  await Future.wait([
    Hive.openBox(AppConstants.settingsBox),
    Hive.openBox(AppConstants.gamificationBox),
    Hive.openBox(AppConstants.scheduleBox),
    Hive.openBox(AppConstants.fianceeBox),
    Hive.openBox(AppConstants.financeBox),
    Hive.openBox(AppConstants.lifestyleBox),
    Hive.openBox(AppConstants.ledgerBox),
    Hive.openBox(AppConstants.rewardsBox),
    Hive.openBox(AppConstants.claimedRewardsBox),
    Hive.openBox(AppConstants.subjectsBox),
    Hive.openBox(AppConstants.timetableBox),
    Hive.openBox(AppConstants.attendanceBox),
    Hive.openBox(AppConstants.studyLogsBox),
    Hive.openBox(AppConstants.proofLogsBox),
    Hive.openBox(AppConstants.pendingProofBox),
  ]);

  // Setup DI
  await setupDependencies();

  // Seed default rewards if first launch
  await getIt<GamificationRepository>().seedDefaultRewards();

  // Initialize notifications
  await getIt<NotificationService>().initialize();
  await getIt<NotificationService>().requestPermissions();

  runApp(const LifeOSApp());
}

class LifeOSApp extends StatelessWidget {
  const LifeOSApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ThemeCubit>(create: (_) => getIt<ThemeCubit>()),
        BlocProvider<SettingsCubit>(create: (_) => getIt<SettingsCubit>()),
        BlocProvider<GamificationCubit>(create: (_) => getIt<GamificationCubit>()),
        BlocProvider<ScheduleCubit>(create: (_) => getIt<ScheduleCubit>()),
        BlocProvider<FianceeCubit>(create: (_) => getIt<FianceeCubit>()),
        BlocProvider<FinanceCubit>(create: (_) => getIt<FinanceCubit>()),
        BlocProvider<LifestyleCubit>(create: (_) => getIt<LifestyleCubit>()),
      ],
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, themeMode) {
          return BlocBuilder<SettingsCubit, SettingsState>(
            builder: (context, settingsState) {
              return MaterialApp(
                title: 'Life OS',
                debugShowCheckedModeBanner: false,
                theme: AppTheme.lightTheme,
                darkTheme: AppTheme.darkTheme,
                themeMode: themeMode,
                locale: Locale(settingsState.languageCode),
                supportedLocales: AppLocalizations.supportedLocales,
                localizationsDelegates: AppLocalizations.localizationsDelegates,
                home: settingsState.isOnboardingComplete
                    ? const MainNavigationScaffold()
                    : OnboardingScreen(
                        onComplete: () {
                          // Handled by cubit state change
                        },
                      ),
              );
            },
          );
        },
      ),
    );
  }
}

class MainNavigationScaffold extends StatefulWidget {
  const MainNavigationScaffold({super.key});

  @override
  State<MainNavigationScaffold> createState() => _MainNavigationScaffoldState();
}

class _MainNavigationScaffoldState extends State<MainNavigationScaffold> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    DashboardScreen(),
    ScheduleScreen(),
    FianceeScreen(),
    FinanceScreen(),
    GamificationScreen(),
    LifestyleScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() => _currentIndex = index);
        },
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.dashboard_outlined),
            selectedIcon: const Icon(Icons.dashboard),
            label: l10n.dashboard,
          ),
          NavigationDestination(
            icon: const Icon(Icons.calendar_month_outlined),
            selectedIcon: const Icon(Icons.calendar_month),
            label: l10n.schedule,
          ),
          NavigationDestination(
            icon: const Icon(Icons.favorite_outline),
            selectedIcon: const Icon(Icons.favorite),
            label: l10n.fiancee,
          ),
          NavigationDestination(
            icon: const Icon(Icons.account_balance_wallet_outlined),
            selectedIcon: const Icon(Icons.account_balance_wallet),
            label: l10n.finance,
          ),
          NavigationDestination(
            icon: const Icon(Icons.emoji_events_outlined),
            selectedIcon: const Icon(Icons.emoji_events),
            label: l10n.gamification,
          ),
          NavigationDestination(
            icon: const Icon(Icons.health_and_safety_outlined),
            selectedIcon: const Icon(Icons.health_and_safety),
            label: l10n.lifestyle,
          ),
        ],
      ),
    );
  }
}
