import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/haptic_utils.dart';
import '../../../../core/widgets/category_background_wrapper.dart';
import '../../../../l10n/app_localizations.dart';
import '../cubits/lifestyle_cubit.dart';
import '../cubits/lifestyle_state.dart';

class LifestyleScreen extends StatelessWidget {
  const LifestyleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return CategoryBackgroundWrapper(
      category: CategoryTheme.lifestyle,
      child: BlocBuilder<LifestyleCubit, LifestyleState>(
        builder: (context, state) {
          final waterProgress = (state.waterCups / 8.0).clamp(0.0, 1.0);
          final totalPointsEarned = (state.healthyMeals * 5) +
              (state.gymSession ? 20 : 0) +
              (state.sleepOnTime ? 10 : 0) +
              (state.wakeOnTime ? 10 : 0) +
              (state.waterCups >= 8 ? 10 : 0);

          return Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              title: Text(l10n.lifestyle),
              backgroundColor: Colors.transparent,
              elevation: 0,
            ),
            body: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Today's summary card
                Card(
                  elevation: 3,
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
                          child: const Icon(Icons.flash_on, color: AppColors.neonEnergyLight, size: 28),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Lifestyle Daily Score',
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '+$totalPointsEarned points earned today',
                                style: TextStyle(color: Colors.grey[600], fontSize: 13),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: AppColors.neonEnergyLight.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '+$totalPointsEarned pts',
                            style: const TextStyle(
                              color: AppColors.neonEnergyLight,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Water Tracker Card
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Row(
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
                                    '${state.waterCups} / 8 cups ${state.waterCups >= 8 ? "🎯 Goal reached!" : ""}',
                                    style: TextStyle(color: Colors.grey[600], fontSize: 13),
                                  ),
                                ],
                              ),
                            ),
                            ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.info,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              ),
                              icon: const Icon(Icons.add, color: Colors.white, size: 18),
                              label: Text(l10n.add, style: const TextStyle(color: Colors.white)),
                              onPressed: () async {
                                await HapticUtils.lightImpact();
                                if (context.mounted) {
                                  context.read<LifestyleCubit>().addWaterCup();
                                }
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: LinearProgressIndicator(
                            value: waterProgress,
                            minHeight: 8,
                            backgroundColor: Colors.grey.withValues(alpha: 0.15),
                            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.info),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                // Healthy Meal Tracker Card
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
                                '${state.healthyMeals} meals logged (+5 pts each)',
                                style: TextStyle(color: Colors.grey[600], fontSize: 13),
                              ),
                            ],
                          ),
                        ),
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.emeraldGreenLight,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          icon: const Icon(Icons.add, color: Colors.white, size: 18),
                          label: Text(l10n.add, style: const TextStyle(color: Colors.white)),
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

                // Gym Session Tracker Card
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
                                state.gymSession ? 'Completed (+20 pts)' : '+20 pts when completed',
                                style: TextStyle(
                                  color: state.gymSession ? AppColors.success : Colors.grey[600],
                                  fontSize: 13,
                                  fontWeight: state.gymSession ? FontWeight.bold : FontWeight.normal,
                                ),
                              ),
                            ],
                          ),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: state.gymSession
                                ? AppColors.success
                                : AppColors.neonEnergyLight,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          onPressed: state.gymSession
                              ? null
                              : () async {
                                  await HapticUtils.heavyImpact();
                                  if (context.mounted) {
                                    context.read<LifestyleCubit>().toggleGymSession();
                                  }
                                },
                          child: Text(
                            state.gymSession ? l10n.done : l10n.completeTask,
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                          ),
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
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: Column(
                    children: [
                      ListTile(
                        leading: const CircleAvatar(
                          backgroundColor: Colors.transparent,
                          child: Icon(Icons.bedtime, color: AppColors.midnightIndigoLight),
                        ),
                        title: Text(l10n.targetBedtime),
                        subtitle: const Text('+10 points for sleeping on time'),
                        trailing: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: state.sleepOnTime ? AppColors.success : null,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          onPressed: state.sleepOnTime
                              ? null
                              : () async {
                                  await HapticUtils.mediumImpact();
                                  if (context.mounted) {
                                    context.read<LifestyleCubit>().logSleepOnTime();
                                  }
                                },
                          child: Text(state.sleepOnTime ? l10n.done : 'Log'),
                        ),
                      ),
                      const Divider(height: 1),
                      ListTile(
                        leading: const CircleAvatar(
                          backgroundColor: Colors.transparent,
                          child: Icon(Icons.wb_sunny, color: AppColors.neonEnergyLight),
                        ),
                        title: Text(l10n.targetWakeUp),
                        subtitle: const Text('+10 points for waking on time'),
                        trailing: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: state.wakeOnTime ? AppColors.success : null,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          onPressed: state.wakeOnTime
                              ? null
                              : () async {
                                  await HapticUtils.mediumImpact();
                                  if (context.mounted) {
                                    context.read<LifestyleCubit>().logWakeOnTime();
                                  }
                                },
                          child: Text(state.wakeOnTime ? l10n.done : 'Log'),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),
                Text(
                  'Recent Activity',
                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),

                if (state.allLogs.isEmpty)
                  Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: const Padding(
                      padding: EdgeInsets.all(24),
                      child: Center(
                        child: Text('No activity logged today yet.', style: TextStyle(color: Colors.grey)),
                      ),
                    ),
                  )
                else
                  ...state.allLogs.reversed.take(6).map(
                        (log) => Card(
                          margin: const EdgeInsets.only(bottom: 6),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          child: ListTile(
                            dense: true,
                            leading: Icon(_getActivityIcon(log.type), size: 20, color: AppColors.neonEnergyLight),
                            title: Text(_getActivityTitle(log.type)),
                            trailing: Text(
                              DateFormat('hh:mm a').format(log.timestamp),
                              style: const TextStyle(color: Colors.grey, fontSize: 12),
                            ),
                          ),
                        ),
                      ),
              ],
            ),
          );
        },
      ),
    );
  }

  IconData _getActivityIcon(String type) {
    switch (type) {
      case 'water':
        return Icons.water_drop;
      case 'meal':
        return Icons.restaurant;
      case 'workout':
        return Icons.fitness_center;
      case 'sleep_start':
        return Icons.bedtime;
      case 'wake':
        return Icons.wb_sunny;
      default:
        return Icons.check_circle_outline;
    }
  }

  String _getActivityTitle(String type) {
    switch (type) {
      case 'water':
        return 'Drank 1 cup of water';
      case 'meal':
        return 'Healthy meal (+5 pts)';
      case 'workout':
        return 'Workout session completed (+20 pts)';
      case 'sleep_start':
        return 'Slept on time (+10 pts)';
      case 'wake':
        return 'Woke up on time (+10 pts)';
      default:
        return 'Activity logged';
    }
  }
}
