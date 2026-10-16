import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/date_utils.dart';
import '../../../../core/utils/haptic_utils.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../settings_backup/presentation/cubits/settings_cubit.dart';
import '../cubits/fiancee_cubit.dart';
import '../cubits/fiancee_state.dart';

class FianceeScreen extends StatelessWidget {
  const FianceeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final isBiometricEnabled = context.watch<SettingsCubit>().state.isBiometricEnabled;

    return BlocBuilder<FianceeCubit, FianceeState>(
      builder: (context, state) {
        if (isBiometricEnabled && !state.isAuthenticated) {
          return Scaffold(
            appBar: AppBar(title: Text(l10n.fianceeHub)),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.lock, size: 64, color: AppColors.romanticRoseLight),
                  const SizedBox(height: 16),
                  Text(
                    l10n.authenticateToAccess,
                    style: theme.textTheme.titleMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.fingerprint),
                    label: Text(l10n.authenticateToAccess),
                    onPressed: () {
                      context.read<FianceeCubit>().setAuthenticated(true);
                    },
                  ),
                ],
              ),
            ),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: Text(l10n.fianceeHub),
            backgroundColor: AppColors.romanticRoseLight,
          ),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Quality time button
              Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.romanticRoseLight.withOpacity(0.15),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.favorite, color: AppColors.romanticRoseLight),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              l10n.qualityTime,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            Text(
                              '+15 points',
                              style: TextStyle(color: Colors.grey[600], fontSize: 13),
                            ),
                          ],
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: state.isQualityTimeCompletedToday
                              ? Colors.grey
                              : AppColors.romanticRoseLight,
                        ),
                        onPressed: state.isQualityTimeCompletedToday
                            ? null
                            : () async {
                                await HapticUtils.heavyImpact();
                                if (context.mounted) {
                                  context.read<FianceeCubit>().completeQualityTime();
                                }
                              },
                        child: Text(state.isQualityTimeCompletedToday ? l10n.done : l10n.done),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    l10n.occasions,
                    style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  TextButton.icon(
                    icon: const Icon(Icons.add),
                    label: Text(l10n.addOccasion),
                    onPressed: () {
                      // Add occasion dialog
                    },
                  ),
                ],
              ),
              const SizedBox(height: 8),

              if (state.occasions.isEmpty)
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Center(
                      child: Text(
                        l10n.noData,
                        style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey),
                      ),
                    ),
                  ),
                )
              else
                ...state.occasions.map(
                  (occasion) {
                    final days = AppDateUtils.daysUntil(occasion.date);
                    return Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: AppColors.romanticRoseLight.withOpacity(0.15),
                          child: const Icon(Icons.cake, color: AppColors.romanticRoseLight),
                        ),
                        title: Text(occasion.title),
                        subtitle: Text(AppDateUtils.formatDisplayDate(occasion.date)),
                        trailing: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.romanticRoseLight.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            days >= 0 ? '$days days left' : 'Passed',
                            style: const TextStyle(
                              color: AppColors.romanticRoseLight,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),

              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    l10n.giftVault,
                    style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  TextButton.icon(
                    icon: const Icon(Icons.add),
                    label: Text(l10n.add),
                    onPressed: () {
                      // Add note dialog
                    },
                  ),
                ],
              ),
              const SizedBox(height: 8),

              if (state.notes.isEmpty)
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Center(
                      child: Text(
                        l10n.noData,
                        style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey),
                      ),
                    ),
                  ),
                )
              else
                ...state.notes.map(
                  (note) => Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      leading: const Icon(Icons.card_giftcard, color: AppColors.romanticRoseLight),
                      title: Text(note.content),
                      subtitle: Text(AppDateUtils.formatDisplayDate(note.dateAdded)),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete_outline, color: Colors.grey),
                        onPressed: () => context.read<FianceeCubit>().deleteNote(note.id),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
