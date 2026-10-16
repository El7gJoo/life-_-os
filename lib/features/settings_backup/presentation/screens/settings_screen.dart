import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/theme/theme_cubit.dart';
import '../../../../core/utils/rtl_utils.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../services/mock_data_seeder.dart';
import '../../../../services/storage_service.dart';
import '../../../fiancee/data/repositories/fiancee_repository.dart';
import '../../../fiancee/presentation/cubits/fiancee_cubit.dart';
import '../../../finance/data/repositories/finance_repository.dart';
import '../../../finance/presentation/cubits/finance_cubit.dart';
import '../../../gamification/data/repositories/gamification_repository.dart';
import '../../../gamification/presentation/cubits/gamification_cubit.dart';
import '../../../lifestyle/data/repositories/lifestyle_repository.dart';
import '../../../lifestyle/presentation/cubits/lifestyle_cubit.dart';
import '../../../schedule_study/data/repositories/schedule_repository.dart';
import '../../../schedule_study/presentation/cubits/schedule_cubit.dart';
import '../../data/repositories/settings_repository.dart';
import '../cubits/settings_cubit.dart';
import '../cubits/settings_state.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  String _formatHour(int hour, String locale) {
    final dt = DateTime(2026, 1, 1, hour, 0);
    return DateFormat('h:mm a', locale).format(dt);
  }

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
                            Text(
                              l10n.sideloadBackupReminder,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              daysSinceBackup == null
                                  ? l10n.sideloadBackupReminderDesc
                                  : '${l10n.lastBackupLabel(RtlUtils.ltr('$daysSinceBackup days ago'))} ${daysSinceBackup >= 5 ? l10n.backupRecommended : l10n.backupFresh}',
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
                l10n.preferences,
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
                  subtitle: Text(
                    '${_formatHour(state.dayBoundaryHour, state.languageCode)} (${l10n.dayBoundaryHint})',
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => _showDayBoundaryDialog(context, state),
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
                  onTap: () => _showPrepTimeDialog(context, state),
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
                  onTap: () => _showCurrencyDialog(context, state),
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
                            ? l10n.lastBackupLabel(DateFormat('yyyy/MM/dd HH:mm').format(state.lastBackupDate!))
                            : l10n.noBackupYet,
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
                      subtitle: Text(l10n.restoreJsonDesc),
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
                l10n.devTools,
                style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),

              Card(
                child: ListTile(
                  leading: const Icon(Icons.science_outlined, color: AppColors.neonEnergyLight),
                  title: Text(l10n.seedMockData),
                  subtitle: Text(l10n.seedMockDataDesc),
                  trailing: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.neonEnergyLight,
                    ),
                    onPressed: () => _seedMockData(context),
                    child: Text(l10n.seedDataButton, style: const TextStyle(color: Colors.white)),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showDayBoundaryDialog(BuildContext context, SettingsState state) {
    final l10n = AppLocalizations.of(context);
    int selected = state.dayBoundaryHour;
    showDialog(
      context: context,
      builder: (dialogCtx) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(l10n.dayBoundaryHourTitle),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                l10n.dayBoundaryDesc,
                style: const TextStyle(fontSize: 13, color: Colors.grey),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<int>(
                initialValue: selected,
                decoration: const InputDecoration(border: OutlineInputBorder()),
                items: List.generate(12, (index) {
                  final hour = index + 1;
                  final formatted = _formatHour(hour, state.languageCode);
                  return DropdownMenuItem(
                    value: hour,
                    child: Text('$formatted ${hour == 4 ? "(${l10n.recommended})" : ""}'),
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
              child: Text(l10n.cancel),
            ),
            ElevatedButton(
              onPressed: () {
                dialogCtx.read<SettingsCubit>().setDayBoundaryHour(selected);
                Navigator.of(dialogCtx).pop();
              },
              child: Text(l10n.save),
            ),
          ],
        ),
      ),
    );
  }

  void _showPrepTimeDialog(BuildContext context, SettingsState state) {
    final l10n = AppLocalizations.of(context);
    int selected = state.prepTimeMinutes;
    showDialog(
      context: context,
      builder: (dialogCtx) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(l10n.prepTimeCommuteTitle),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                l10n.prepTimeCommuteDesc,
                style: const TextStyle(fontSize: 13, color: Colors.grey),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<int>(
                initialValue: selected,
                decoration: const InputDecoration(border: OutlineInputBorder()),
                items: [
                  DropdownMenuItem(value: 30, child: Text(l10n.minutesCount(30))),
                  DropdownMenuItem(value: 45, child: Text(l10n.minutesCount(45))),
                  DropdownMenuItem(value: 60, child: Text('${l10n.minutesCount(60)} (${l10n.recommended})')),
                  DropdownMenuItem(value: 75, child: Text(l10n.minutesCount(75))),
                  DropdownMenuItem(value: 90, child: Text(l10n.minutesCount(90))),
                  DropdownMenuItem(value: 120, child: Text(l10n.minutesCount(120))),
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
              child: Text(l10n.cancel),
            ),
            ElevatedButton(
              onPressed: () {
                dialogCtx.read<SettingsCubit>().setPrepTimeMinutes(selected);
                Navigator.of(dialogCtx).pop();
              },
              child: Text(l10n.save),
            ),
          ],
        ),
      ),
    );
  }

  void _showCurrencyDialog(BuildContext context, SettingsState state) {
    final l10n = AppLocalizations.of(context);
    String selected = state.currency;
    showDialog(
      context: context,
      builder: (dialogCtx) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(l10n.currency),
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
              child: Text(l10n.cancel),
            ),
            ElevatedButton(
              onPressed: () {
                dialogCtx.read<SettingsCubit>().setCurrency(selected);
                Navigator.of(dialogCtx).pop();
              },
              child: Text(l10n.save),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleExportData(BuildContext context) async {
    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final settingsCubit = context.read<SettingsCubit>();
    try {
      await getIt<StorageService>().shareBackupFile();
      await settingsCubit.setLastBackupDate(DateTime.now());
      messenger.showSnackBar(
        SnackBar(content: Text(l10n.backupExportedSuccess)),
      );
    } catch (e) {
      messenger.showSnackBar(
        SnackBar(content: Text(l10n.exportFailed(e.toString()))),
      );
    }
  }

  Future<void> _handleImportData(BuildContext context) async {
    final l10n = AppLocalizations.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(l10n.restoreConfirmTitle),
        content: Text(l10n.restoreConfirmDesc),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.warning),
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(l10n.proceed, style: const TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      final messenger = ScaffoldMessenger.of(context);
      try {
        final success = await getIt<StorageService>().restoreFromFile();
        if (success && context.mounted) {
          // Refresh all cubits
          context.read<GamificationCubit>().refresh();
          context.read<ScheduleCubit>().refresh();
          context.read<FianceeCubit>().refresh();
          context.read<FinanceCubit>().refresh();
          context.read<LifestyleCubit>().refresh();
          context.read<SettingsCubit>().refresh();

          messenger.showSnackBar(
            SnackBar(content: Text(l10n.backupRestoredSuccess)),
          );
        }
      } catch (e) {
        messenger.showSnackBar(
          SnackBar(content: Text(l10n.restoreFailed(e.toString()))),
        );
      }
    }
  }

  Future<void> _seedMockData(BuildContext context) async {
    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    try {
      await MockDataSeeder().seedAll(
        gamificationRepo: getIt<GamificationRepository>(),
        scheduleRepo: getIt<ScheduleRepository>(),
        fianceeRepo: getIt<FianceeRepository>(),
        financeRepo: getIt<FinanceRepository>(),
        lifestyleRepo: getIt<LifestyleRepository>(),
        settingsRepo: getIt<SettingsRepository>(),
      );

      if (context.mounted) {
        context.read<GamificationCubit>().refresh();
        context.read<ScheduleCubit>().refresh();
        context.read<FianceeCubit>().refresh();
        context.read<FinanceCubit>().refresh();
        context.read<LifestyleCubit>().refresh();
        context.read<SettingsCubit>().refresh();

        messenger.showSnackBar(
          SnackBar(content: Text(l10n.mockDataSeededSuccess)),
        );
      }
    } catch (e) {
      messenger.showSnackBar(
        SnackBar(content: Text(l10n.seedingFailed(e.toString()))),
      );
    }
  }
}
