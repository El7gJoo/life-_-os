import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/theme/theme_cubit.dart';
import '../../../../l10n/app_localizations.dart';
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

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
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

              const SizedBox(height: 12),

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

              const SizedBox(height: 12),

              // Day Boundary
              Card(
                child: ListTile(
                  leading: const Icon(Icons.access_time, color: AppColors.primary),
                  title: Text(l10n.dayBoundary),
                  subtitle: Text('${state.dayBoundaryHour}:00 AM'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    // Day boundary picker dialog
                  },
                ),
              ),

              const SizedBox(height: 12),

              // Prep Time
              Card(
                child: ListTile(
                  leading: const Icon(Icons.timer_outlined, color: AppColors.primary),
                  title: Text(l10n.prepTime),
                  subtitle: Text(l10n.prepTimeMinutes(state.prepTimeMinutes)),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    // Prep time dialog
                  },
                ),
              ),

              const SizedBox(height: 12),

              // Currency
              Card(
                child: ListTile(
                  leading: const Icon(Icons.monetization_on, color: AppColors.primary),
                  title: Text(l10n.currency),
                  subtitle: Text(state.currency),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    // Currency dialog
                  },
                ),
              ),

              const SizedBox(height: 12),

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
              Text(
                l10n.backup,
                style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),

              Card(
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.file_upload_outlined, color: AppColors.primary),
                      title: Text(l10n.exportData),
                      subtitle: Text(
                        state.lastBackupDate != null
                            ? 'Last: ${state.lastBackupDate!.month}/${state.lastBackupDate!.day}'
                            : 'No backup yet',
                      ),
                      trailing: ElevatedButton(
                        onPressed: () {
                          // Trigger backup
                          context.read<SettingsCubit>().setLastBackupDate(DateTime.now());
                        },
                        child: Text(l10n.backupNow),
                      ),
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(Icons.file_download_outlined, color: AppColors.primary),
                      title: Text(l10n.importData),
                      trailing: TextButton(
                        onPressed: () {
                          // Restore dialog
                        },
                        child: Text(l10n.restore),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
