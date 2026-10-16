import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/haptic_utils.dart';
import '../../../../l10n/app_localizations.dart';
import '../cubits/lifestyle_cubit.dart';
import '../cubits/lifestyle_state.dart';

class LifestyleScreen extends StatelessWidget {
  const LifestyleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return BlocBuilder<LifestyleCubit, LifestyleState>(
      builder: (context, state) {
        final log = state.todayLog;

        return Scaffold(
          appBar: AppBar(
            title: Text(l10n.lifestyle),
            backgroundColor: AppColors.neonEnergyLight,
          ),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Water Tracker
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.info.withValues(alpha: 0.15),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.water_drop, color: AppColors.info),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              l10n.water,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            Text(
                              l10n.waterCups(log.waterCups),
                              style: TextStyle(color: Colors.grey[600], fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.add),
                        label: Text(l10n.add),
                        onPressed: () async {
                          await HapticUtils.lightImpact();
                          if (context.mounted) {
                            context.read<LifestyleCubit>().addWaterCup();
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // Healthy Meal Tracker
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.emeraldGreenLight.withValues(alpha: 0.15),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.restaurant, color: AppColors.emeraldGreenLight),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              l10n.healthyMeal,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            Text(
                              '${log.healthyMeals} meals (+5 pts each)',
                              style: TextStyle(color: Colors.grey[600], fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.add),
                        label: Text(l10n.add),
                        onPressed: () async {
                          await HapticUtils.mediumImpact();
                          if (context.mounted) {
                            context.read<LifestyleCubit>().addHealthyMeal();
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // Gym Session Tracker
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.neonEnergyLight.withValues(alpha: 0.15),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.fitness_center, color: AppColors.neonEnergyLight),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              l10n.gymSession,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            Text(
                              '+20 pts',
                              style: TextStyle(color: Colors.grey[600], fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: log.gymSession
                              ? AppColors.success
                              : AppColors.neonEnergyLight,
                        ),
                        onPressed: log.gymSession
                            ? null
                            : () async {
                                await HapticUtils.heavyImpact();
                                if (context.mounted) {
                                  context.read<LifestyleCubit>().toggleGymSession();
                                }
                              },
                        child: Text(log.gymSession ? l10n.done : l10n.completeTask),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),
              Text(
                'Sleep & Wake Goals',
                style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),

              Card(
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.bedtime, color: AppColors.midnightIndigoLight),
                      title: Text(l10n.targetBedtime),
                      subtitle: const Text('+10 points for sleeping on time'),
                      trailing: ElevatedButton(
                        onPressed: log.sleepOnTime
                            ? null
                            : () => context.read<LifestyleCubit>().logSleepOnTime(),
                        child: Text(log.sleepOnTime ? l10n.done : 'Log'),
                      ),
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(Icons.wb_sunny, color: AppColors.neonEnergyLight),
                      title: Text(l10n.targetWakeUp),
                      subtitle: const Text('+10 points for waking on time'),
                      trailing: ElevatedButton(
                        onPressed: log.wakeOnTime
                            ? null
                            : () => context.read<LifestyleCubit>().logWakeOnTime(),
                        child: Text(log.wakeOnTime ? l10n.done : 'Log'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
