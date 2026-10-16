import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/theme/theme_cubit.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../services/mock_data_seeder.dart';
import '../../../../services/storage_service.dart';
import '../../../fiancee/data/repositories/fiancee_repository.dart';
import '../../../fiancee/presentation/cubits/fiancee_cubit.dart';
import '../../../finance/data/repositories/finance_repository.dart';
import '../../../gamification/data/repositories/gamification_repository.dart';
import '../../../gamification/presentation/cubits/gamification_cubit.dart';
import '../../../lifestyle/data/repositories/lifestyle_repository.dart';
import '../../../lifestyle/presentation/cubits/lifestyle_cubit.dart';
import '../../../schedule_study/data/repositories/schedule_repository.dart';
import '../../../schedule_study/presentation/cubits/schedule_cubit.dart';
import '../cubits/settings_cubit.dart';
import '../cubits/settings_state.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.settings),
      ),
      body: BlocBuilder<SettingsCubit, SettingsState>(
        builder: (context, state) {
          final themeMode = context.watch<ThemeCubit>().state;
          final daysSinceBackup = state.lastBackupDate == null
              ? null
              : DateTime.now().difference(state.lastBackupDate!).inDays;

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // 7-Day Sideload Certificate Reminder
              Card(
                color: (daysSinceBackup != null && daysSinceBackup >= 5)
                    ? AppColors.warning.withValues(alpha: 0.15)
                    : AppColors.midnightIndigoLight.withValues(alpha: 0.08),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(
                    color: (daysSinceBackup != null && daysSinceBackup >= 5)
                        ? AppColors.warning
                        : Colors.transparent,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Icon(
                        Icons.security,
                        color: (daysSinceBackup != null && daysSinceBackup >= 5)
                            ? AppColors.warning
                            : AppColors.primary,
                        size: 32,
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'iOS Sideload Backup Reminder',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              daysSinceBackup == null
                                  ? 'Export backup weekly to protect your data across 7-day sideload certificates (AltStore/SideStore).'
                                  : 'Last backup: $daysSinceBackup day${daysSinceBackup == 1 ? "" : "s"} ago. ${daysSinceBackup >= 5 ? "⚠️ Refresh certificate & backup recommended!" : "Backup is fresh."}',
                              style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey[700]),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Preferences Section
              Text(
                'Preferences',
                style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),

              // Language
              Card(
                child: ListTile(
                  leading: const Icon(Icons.language, color: AppColors.primary),
                  title: Text(l10n.language),
                  subtitle: Text(state.languageCode == 'ar' ? l10n.arabic : l10n.english),
                  trailing: SegmentedButton<String>(
                    segments: [
                      ButtonSegment(value: 'en', label: Text(l10n.english)),
                      ButtonSegment(value: 'ar', label: Text(l10n.arabic)),
                    ],
                    selected: {state.languageCode},
                    onSelectionChanged: (selected) {
                      context.read<SettingsCubit>().setLanguageCode(selected.first);
                    },
                  ),
                ),
              ),

              const SizedBox(height: 8),

              // Theme
              Card(
                child: ListTile(
                  leading: const Icon(Icons.palette, color: AppColors.primary),
                  title: Text(l10n.theme),
                  subtitle: Text(
                    themeMode == ThemeMode.system
                        ? l10n.themeSystem
                        : themeMode == ThemeMode.light
                            ? l10n.themeLight
                            : l10n.themeDark,
                  ),
                  trailing: IconButton(
                    icon: Icon(
                      themeMode == ThemeMode.dark ? Icons.dark_mode : Icons.light_mode,
                    ),
                    onPressed: () => context.read<ThemeCubit>().toggleTheme(),
                  ),
                ),
              ),

              const SizedBox(height: 8),

              // Day Boundary
              Card(
                child: ListTile(
                  leading: const Icon(Icons.access_time, color: AppColors.primary),
                  title: Text(l10n.dayBoundary),
                  subtitle: Text('${state.dayBoundaryHour}:00 AM (Default 4 AM)'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => _showDayBoundaryDialog(context, state.dayBoundaryHour),
                ),
              ),

              const SizedBox(height: 8),

              // Prep Time
              Card(
                child: ListTile(
                  leading: const Icon(Icons.timer_outlined, color: AppColors.primary),
                  title: Text(l10n.prepTime),
                  subtitle: Text(l10n.prepTimeMinutes(state.prepTimeMinutes)),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => _showPrepTimeDialog(context, state.prepTimeMinutes),
                ),
              ),

              const SizedBox(height: 8),

              // Currency
              Card(
                child: ListTile(
                  leading: const Icon(Icons.monetization_on, color: AppColors.primary),
                  title: Text(l10n.currency),
                  subtitle: Text(state.currency),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => _showCurrencyDialog(context, state.currency),
                ),
              ),

              const SizedBox(height: 8),

              // Biometrics
              Card(
                child: SwitchListTile(
                  secondary: const Icon(Icons.fingerprint, color: AppColors.primary),
                  title: Text(l10n.biometricLock),
                  subtitle: Text(l10n.enableBiometric),
                  value: state.isBiometricEnabled,
                  onChanged: (val) {
                    context.read<SettingsCubit>().setBiometricEnabled(val);
                  },
                ),
              ),

              const SizedBox(height: 24),

              // Data & Backup Section
              Text(
                l10n.backup,
                style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),

              Card(
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.file_upload_outlined, color: AppColors.primary),
                      title: Text(l10n.exportData),
                      subtitle: Text(
                        state.lastBackupDate != null
                            ? 'Last backup: ${state.lastBackupDate!.month}/${state.lastBackupDate!.day} at ${state.lastBackupDate!.hour}:${state.lastBackupDate!.minute.toString().padLeft(2, '0')}'
                            : 'No backup performed yet',
                      ),
                      trailing: ElevatedButton(
                        onPressed: () => _handleExportData(context),
                        child: Text(l10n.backupNow),
                      ),
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(Icons.file_download_outlined, color: AppColors.primary),
                      title: Text(l10n.importData),
                      subtitle: const Text('Restore all boxes from JSON backup file'),
                      trailing: TextButton(
                        onPressed: () => _handleImportData(context),
                        child: Text(l10n.restore),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Developer & Mock Data
              Text(
                'Developer Tools',
                style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),

              Card(
                child: ListTile(
                  leading: const Icon(Icons.science_outlined, color: AppColors.neonEnergyLight),
                  title: const Text('Seed Mock Data'),
                  subtitle: const Text('Fill all modules with sample test data'),
                  trailing: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.neonEnergyLight,
                    ),
                    onPressed: () => _seedMockData(context),
                    child: const Text('Seed Data', style: TextStyle(color: Colors.white)),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showDayBoundaryDialog(BuildContext context, int currentHour) {
    int selected = currentHour;
    showDialog(
      context: context,
      builder: (dialogCtx) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Day Boundary Hour'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Select when your productivity day flips (e.g. 4:00 AM allows night owls to finish tasks before next day resets).',
                style: TextStyle(fontSize: 13, color: Colors.grey),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<int>(
                initialValue: selected,
                decoration: const InputDecoration(border: OutlineInputBorder()),
                items: List.generate(12, (index) {
                  final hour = index + 1;
                  return DropdownMenuItem(
                    value: hour,
                    child: Text('$hour:00 AM ${hour == 4 ? "(Recommended)" : ""}'),
                  );
                }),
                onChanged: (val) {
                  if (val != null) setDialogState(() => selected = val);
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogCtx).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                dialogCtx.read<SettingsCubit>().setDayBoundaryHour(selected);
                Navigator.of(dialogCtx).pop();
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

  void _showPrepTimeDialog(BuildContext context, int currentMinutes) {
    int selected = currentMinutes;
    showDialog(
      context: context,
      builder: (dialogCtx) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Preparation & Commute Time'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'How many minutes you need before your first morning lecture or task.',
                style: TextStyle(fontSize: 13, color: Colors.grey),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<int>(
                initialValue: selected,
                decoration: const InputDecoration(border: OutlineInputBorder()),
                items: const [
                  DropdownMenuItem(value: 30, child: Text('30 minutes')),
                  DropdownMenuItem(value: 45, child: Text('45 minutes')),
                  DropdownMenuItem(value: 60, child: Text('60 minutes (1 hour - Default)')),
                  DropdownMenuItem(value: 75, child: Text('75 minutes')),
                  DropdownMenuItem(value: 90, child: Text('90 minutes (1.5 hours)')),
                  DropdownMenuItem(value: 120, child: Text('120 minutes (2 hours)')),
                ],
                onChanged: (val) {
                  if (val != null) setDialogState(() => selected = val);
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogCtx).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                dialogCtx.read<SettingsCubit>().setPrepTimeMinutes(selected);
                Navigator.of(dialogCtx).pop();
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

  void _showCurrencyDialog(BuildContext context, String currentCurrency) {
    String selected = currentCurrency;
    showDialog(
      context: context,
      builder: (dialogCtx) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Currency'),
          content: DropdownButtonFormField<String>(
            initialValue: selected,
            decoration: const InputDecoration(border: OutlineInputBorder()),
            items: const [
              DropdownMenuItem(value: 'EGP', child: Text('EGP - Egyptian Pound (ج.م)')),
              DropdownMenuItem(value: 'USD', child: Text('USD - US Dollar (\$)')),
              DropdownMenuItem(value: 'EUR', child: Text('EUR - Euro (€)')),
              DropdownMenuItem(value: 'SAR', child: Text('SAR - Saudi Riyal (ر.س)')),
              DropdownMenuItem(value: 'AED', child: Text('AED - UAE Dirham (د.إ)')),
              DropdownMenuItem(value: 'GBP', child: Text('GBP - British Pound (£)')),
              DropdownMenuItem(value: 'KWD', child: Text('KWD - Kuwaiti Dinar (د.ك)')),
            ],
            onChanged: (val) {
              if (val != null) setDialogState(() => selected = val);
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogCtx).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                dialogCtx.read<SettingsCubit>().setCurrency(selected);
                Navigator.of(dialogCtx).pop();
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleExportData(BuildContext context) async {
    final messenger = ScaffoldMessenger.of(context);
    final settingsCubit = context.read<SettingsCubit>();
    try {
      await getIt<StorageService>().shareBackupFile();
      await settingsCubit.setLastBackupDate(DateTime.now());
      messenger.showSnackBar(
        const SnackBar(content: Text('Backup exported successfully!')),
      );
    } catch (e) {
      messenger.showSnackBar(
        SnackBar(content: Text('Export failed: $e')),
      );
    }
  }

  Future<void> _handleImportData(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Restore Backup?'),
        content: const Text(
          'Restoring data from a backup file will replace current local data with the backup contents. Do you want to proceed?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.warning),
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Proceed', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      try {
        final success = await getIt<StorageService>().restoreFromFile();
        if (success && context.mounted) {
          // Refresh all cubits
          context.read<GamificationCubit>().refresh();
          context.read<ScheduleCubit>().refresh();
          context.read<FianceeCubit>().refresh();
          context.read<LifestyleCubit>().refresh();

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Backup restored successfully!')),
          );
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Restore failed: $e')),
          );
        }
      }
    }
  }

  Future<void> _seedMockData(BuildContext context) async {
    try {
      await MockDataSeeder().seedAll(
        gamificationRepo: getIt<GamificationRepository>(),
        scheduleRepo: getIt<ScheduleRepository>(),
        fianceeRepo: getIt<FianceeRepository>(),
        financeRepo: getIt<FinanceRepository>(),
        lifestyleRepo: getIt<LifestyleRepository>(),
      );

      if (context.mounted) {
        context.read<GamificationCubit>().refresh();
        context.read<ScheduleCubit>().refresh();
        context.read<FianceeCubit>().refresh();
        context.read<LifestyleCubit>().refresh();

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Mock test data seeded successfully!')),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Seeding failed: $e')),
        );
      }
    }
  }
}
