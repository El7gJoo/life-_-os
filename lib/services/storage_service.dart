import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../core/constants/app_constants.dart';
import '../core/di/injection.dart';
import '../features/fiancee/data/repositories/fiancee_repository.dart';
import '../features/finance/data/repositories/finance_repository.dart';
import '../features/gamification/data/repositories/gamification_repository.dart';
import '../features/lifestyle/data/repositories/lifestyle_repository.dart';
import '../features/schedule_study/data/repositories/schedule_repository.dart';
import '../features/settings_backup/data/repositories/settings_repository.dart';

class StorageService {
  Future<String> exportBackupJson() async {
    final settingsRepo = getIt<SettingsRepository>();
    final gamificationRepo = getIt<GamificationRepository>();
    final scheduleRepo = getIt<ScheduleRepository>();
    final fianceeRepo = getIt<FianceeRepository>();
    final financeRepo = getIt<FinanceRepository>();
    final lifestyleRepo = getIt<LifestyleRepository>();

    final backupData = <String, dynamic>{
      'schemaVersion': AppConstants.schemaVersion,
      'exportedAt': DateTime.now().toIso8601String(),
      'settings': settingsRepo.exportAll(),
      'gamification': gamificationRepo.exportAll(),
      'schedule': scheduleRepo.exportAll(),
      'fiancee': fianceeRepo.exportAll(),
      'finance': financeRepo.exportAll(),
      'lifestyle': lifestyleRepo.exportAll(),
    };

    return jsonEncode(backupData);
  }

  Future<void> importBackupJson(String jsonString) async {
    final data = jsonDecode(jsonString) as Map<String, dynamic>;
    final version = data['schemaVersion'] as int? ?? 1;

    // Apply migrations if needed
    final migrated = _migrateData(data, version);

    if (migrated.containsKey('settings') && migrated['settings'] is Map) {
      await getIt<SettingsRepository>().importAll(
        Map<String, dynamic>.from(migrated['settings'] as Map),
      );
    }
    if (migrated.containsKey('gamification') && migrated['gamification'] is Map) {
      await getIt<GamificationRepository>().importAll(
        Map<String, dynamic>.from(migrated['gamification'] as Map),
      );
    }
    if (migrated.containsKey('schedule') && migrated['schedule'] is Map) {
      await getIt<ScheduleRepository>().importAll(
        Map<String, dynamic>.from(migrated['schedule'] as Map),
      );
    }
    if (migrated.containsKey('fiancee') && migrated['fiancee'] is Map) {
      await getIt<FianceeRepository>().importAll(
        Map<String, dynamic>.from(migrated['fiancee'] as Map),
      );
    }
    if (migrated.containsKey('finance') && migrated['finance'] is Map) {
      await getIt<FinanceRepository>().importAll(
        Map<String, dynamic>.from(migrated['finance'] as Map),
      );
    }
    if (migrated.containsKey('lifestyle') && migrated['lifestyle'] is Map) {
      await getIt<LifestyleRepository>().importAll(
        Map<String, dynamic>.from(migrated['lifestyle'] as Map),
      );
    }
  }

  Map<String, dynamic> _migrateData(Map<String, dynamic> data, int currentVersion) {
    var migrated = Map<String, dynamic>.from(data);
    // Migration paths for future schema changes
    if (currentVersion < 1) {
      // Future migration logic
    }
    return migrated;
  }

  Future<void> shareBackupFile() async {
    final jsonString = await exportBackupJson();
    final tempDir = await getTemporaryDirectory();
    final file = File('${tempDir.path}/life_os_backup_${DateTime.now().millisecondsSinceEpoch}.json');
    await file.writeAsString(jsonString);

    await Share.shareXFiles(
      [XFile(file.path)],
      subject: 'Life OS Backup',
    );
  }

  Future<bool> restoreFromFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['json'],
    );

    if (result != null && result.files.single.path != null) {
      final file = File(result.files.single.path!);
      final content = await file.readAsString();
      await importBackupJson(content);
      return true;
    }
    return false;
  }
}
