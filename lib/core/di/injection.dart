import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../constants/app_constants.dart';
import '../theme/theme_cubit.dart';
import '../../features/settings_backup/data/repositories/settings_repository_impl.dart';
import '../../features/settings_backup/data/repositories/settings_repository.dart';
import '../../features/gamification/data/repositories/gamification_repository_impl.dart';
import '../../features/gamification/data/repositories/gamification_repository.dart';
import '../../features/schedule_study/data/repositories/schedule_repository_impl.dart';
import '../../features/schedule_study/data/repositories/schedule_repository.dart';
import '../../features/fiancee/data/repositories/fiancee_repository_impl.dart';
import '../../features/fiancee/data/repositories/fiancee_repository.dart';
import '../../features/finance/data/repositories/finance_repository_impl.dart';
import '../../features/finance/data/repositories/finance_repository.dart';
import '../../features/lifestyle/data/repositories/lifestyle_repository_impl.dart';
import '../../features/lifestyle/data/repositories/lifestyle_repository.dart';
import '../../features/settings_backup/presentation/cubits/settings_cubit.dart';
import '../../features/gamification/presentation/cubits/gamification_cubit.dart';
import '../../features/schedule_study/presentation/cubits/schedule_cubit.dart';
import '../../features/fiancee/presentation/cubits/fiancee_cubit.dart';
import '../../features/finance/presentation/cubits/finance_cubit.dart';
import '../../features/lifestyle/presentation/cubits/lifestyle_cubit.dart';
import '../../services/notification_service.dart';
import '../../services/storage_service.dart';
import '../../services/csv_export_service.dart';
import '../../services/widget_data_provider.dart';
import '../../services/mock_data_seeder.dart';

final GetIt getIt = GetIt.instance;

Future<void> setupDependencies() async {
  // Services
  getIt.registerLazySingleton<StorageService>(() => StorageService());
  getIt.registerLazySingleton<NotificationService>(() => NotificationService());
  getIt.registerLazySingleton<CsvExportService>(() => CsvExportService());
  getIt.registerLazySingleton<WidgetDataProvider>(() => WidgetDataProvider());
  getIt.registerLazySingleton<MockDataSeeder>(() => MockDataSeeder());

  // Repositories
  getIt.registerLazySingleton<SettingsRepository>(
    () => SettingsRepositoryImpl(Hive.box(AppConstants.settingsBox)),
  );
  getIt.registerLazySingleton<GamificationRepository>(
    () => GamificationRepositoryImpl(
      ledgerBox: Hive.box(AppConstants.ledgerBox),
      rewardsBox: Hive.box(AppConstants.rewardsBox),
      claimedRewardsBox: Hive.box(AppConstants.claimedRewardsBox),
      settingsBox: Hive.box(AppConstants.settingsBox),
    ),
  );
  getIt.registerLazySingleton<ScheduleRepository>(
    () => ScheduleRepositoryImpl(Hive.box(AppConstants.scheduleBox)),
  );
  getIt.registerLazySingleton<FianceeRepository>(
    () => FianceeRepositoryImpl(Hive.box(AppConstants.fianceeBox)),
  );
  getIt.registerLazySingleton<FinanceRepository>(
    () => FinanceRepositoryImpl(Hive.box(AppConstants.financeBox)),
  );
  getIt.registerLazySingleton<LifestyleRepository>(
    () => LifestyleRepositoryImpl(Hive.box(AppConstants.lifestyleBox)),
  );

  // Cubits
  getIt.registerFactory<ThemeCubit>(() => ThemeCubit());
  getIt.registerFactory<SettingsCubit>(
    () => SettingsCubit(getIt<SettingsRepository>()),
  );
  getIt.registerFactory<GamificationCubit>(
    () => GamificationCubit(getIt<GamificationRepository>()),
  );
  getIt.registerFactory<ScheduleCubit>(
    () => ScheduleCubit(
      getIt<ScheduleRepository>(),
      getIt<GamificationRepository>(),
      getIt<NotificationService>(),
      getIt<SettingsRepository>(),
    ),
  );
  getIt.registerFactory<FianceeCubit>(
    () => FianceeCubit(
      getIt<FianceeRepository>(),
      getIt<GamificationRepository>(),
      getIt<NotificationService>(),
    ),
  );
  getIt.registerFactory<FinanceCubit>(
    () => FinanceCubit(
      getIt<FinanceRepository>(),
      getIt<GamificationRepository>(),
      getIt<SettingsRepository>(),
    ),
  );
  getIt.registerFactory<LifestyleCubit>(
    () => LifestyleCubit(
      getIt<LifestyleRepository>(),
      getIt<GamificationRepository>(),
    ),
  );
}
