import 'dart:convert';
import 'dart:io' show File;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
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
  Future<String> exportAllData({
    required GamificationRepository gamificationRepo,
    required ScheduleRepository scheduleRepo,
    required FianceeRepository fianceeRepo,
    required FinanceRepository financeRepo,
    required LifestyleRepository lifestyleRepo,
    required SettingsRepository settingsRepo,
  }) async {
    final payload = <String, dynamic>{
      'schemaVersion': AppConstants.schemaVersion,
      'exportedAt': DateTime.now().toIso8601String(),
      'data': {
        'settings': settingsRepo.exportAll(),
        'gamification': gamificationRepo.exportAll(),
        'schedule': scheduleRepo.exportAll(),
        'fiancee': fianceeRepo.exportAll(),
        'finance': financeRepo.exportAll(),
        'lifestyle': lifestyleRepo.exportAll(),
      },
    };

    return const JsonEncoder.withIndent('  ').convert(payload);
  }

  Future<void> importAllData(
    String jsonString, {
    required GamificationRepository gamificationRepo,
    required ScheduleRepository scheduleRepo,
    required FianceeRepository fianceeRepo,
    required FinanceRepository financeRepo,
    required LifestyleRepository lifestyleRepo,
    required SettingsRepository settingsRepo,
  }) async {
    final root = jsonDecode(jsonString) as Map<String, dynamic>;
    final schemaVersion = root['schemaVersion'] as int? ?? 1;
    final rawData = (root['data'] is Map<String, dynamic>)
        ? root['data'] as Map<String, dynamic>
        : root;

    final migratedData = _migrate(rawData, schemaVersion);

    if (migratedData.containsKey('settings') && migratedData['settings'] is Map) {
      await settingsRepo.importAll(
        Map<String, dynamic>.from(migratedData['settings'] as Map),
      );
    }

    if (migratedData.containsKey('gamification') && migratedData['gamification'] is Map) {
      await gamificationRepo.importAll(
        Map<String, dynamic>.from(migratedData['gamification'] as Map),
      );
    }

    if (migratedData.containsKey('schedule') && migratedData['schedule'] is Map) {
      await scheduleRepo.importAll(
        Map<String, dynamic>.from(migratedData['schedule'] as Map),
      );
    }

    if (migratedData.containsKey('fiancee') && migratedData['fiancee'] is Map) {
      await fianceeRepo.importAll(
        Map<String, dynamic>.from(migratedData['fiancee'] as Map),
      );
    }

    if (migratedData.containsKey('finance') && migratedData['finance'] is Map) {
      await financeRepo.importAll(
        Map<String, dynamic>.from(migratedData['finance'] as Map),
      );
    }

    if (migratedData.containsKey('lifestyle') && migratedData['lifestyle'] is Map) {
      await lifestyleRepo.importAll(
        Map<String, dynamic>.from(migratedData['lifestyle'] as Map),
      );
    }
  }

  Map<String, dynamic> _migrate(Map<String, dynamic> data, int fromVersion) {
    var migrated = Map<String, dynamic>.from(data);
    // Migration logic across schema versions:
    // When schemaVersion advances from 1 -> 2, transform schema here.
    if (fromVersion < 1) {
      // Pre-v1 normalization
    }
    return migrated;
  }

  // Convenience methods using service locator
  Future<String> exportBackupJson() {
    return exportAllData(
      gamificationRepo: getIt<GamificationRepository>(),
      scheduleRepo: getIt<ScheduleRepository>(),
      fianceeRepo: getIt<FianceeRepository>(),
      financeRepo: getIt<FinanceRepository>(),
      lifestyleRepo: getIt<LifestyleRepository>(),
      settingsRepo: getIt<SettingsRepository>(),
    );
  }

  Future<void> importBackupJson(String jsonString) {
    return importAllData(
      jsonString,
      gamificationRepo: getIt<GamificationRepository>(),
      scheduleRepo: getIt<ScheduleRepository>(),
      fianceeRepo: getIt<FianceeRepository>(),
      financeRepo: getIt<FinanceRepository>(),
      lifestyleRepo: getIt<LifestyleRepository>(),
      settingsRepo: getIt<SettingsRepository>(),
    );
  }

  Future<void> shareBackupFile() async {
    final jsonString = await exportBackupJson();
    final bytes = Uint8List.fromList(utf8.encode(jsonString));
    final xFile = XFile.fromData(
      bytes,
      name: 'life_os_backup_${DateTime.now().millisecondsSinceEpoch}.json',
      mimeType: 'application/json',
    );

    await Share.shareXFiles(
      [xFile],
      subject: 'Life OS Backup',
    );
  }

  Future<bool> restoreFromFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['json'],
      withData: true,
    );

    if (result != null && result.files.isNotEmpty) {
      final file = result.files.single;
      String? content;
      if (file.bytes != null) {
        content = utf8.decode(file.bytes!);
      } else if (!kIsWeb && file.path != null) {
        final ioFile = File(file.path!);
        content = await ioFile.readAsString();
      }
      if (content != null) {
        await importBackupJson(content);
        return true;
      }
    }
    return false;
  }
}
