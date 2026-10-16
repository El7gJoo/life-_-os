import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/haptic_utils.dart';
import '../../../../l10n/app_localizations.dart';
import '../cubits/schedule_cubit.dart';
import '../cubits/schedule_state.dart';

class ScheduleScreen extends StatelessWidget {
  const ScheduleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return BlocBuilder<ScheduleCubit, ScheduleState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text(l10n.schedule2),
            actions: [
              IconButton(
                tooltip: l10n.emergencyShift,
                icon: const Icon(Icons.forward_10),
                onPressed: () => _confirmEmergencyShift(context),
              ),
            ],
          ),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Sleep Calculator Card
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.bedtime, color: AppColors.midnightIndigoLight),
                          const SizedBox(width: 8),
                          Text(
                            l10n.sleepCalculator,
                            style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            children: [
                              Text(l10n.targetBedtime, style: theme.textTheme.bodySmall),
                              const SizedBox(height: 4),
                              Text(
                                state.targetBedtime != null
                                    ? DateFormat('hh:mm a').format(state.targetBedtime!)
                                    : '--:--',
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.midnightIndigoLight,
                                ),
                              ),
                            ],
                          ),
                          const Icon(Icons.arrow_forward, color: Colors.grey),
                          Column(
                            children: [
                              Text(l10n.targetWakeUp, style: theme.textTheme.bodySmall),
                              const SizedBox(height: 4),
                              Text(
                                state.targetWakeUpTime != null
                                    ? DateFormat('hh:mm a').format(state.targetWakeUpTime!)
                                    : '--:--',
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.neonEnergyLight,
                                ),
                              ),
                            ],
                          ),
                        ],
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
                    l10n.today,
                    style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  TextButton.icon(
                    icon: const Icon(Icons.add),
                    label: Text(l10n.addTask),
                    onPressed: () {
                      // Add task dialog
                    },
                  ),
                ],
              ),
              const SizedBox(height: 8),

              if (state.items.isEmpty)
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Center(
                      child: Text(
                        l10n.noTasksToday,
                        style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey),
                      ),
                    ),
                  ),
                )
              else
                ...state.items.map(
                  (item) => Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      leading: Checkbox(
                        value: item.isCompleted,
                        onChanged: (_) async {
                          await HapticUtils.mediumImpact();
                          if (context.mounted) {
                            context.read<ScheduleCubit>().toggleTaskCompletion(item.id);
                          }
                        },
                      ),
                      title: Text(
                        item.title,
                        style: TextStyle(
                          decoration: item.isCompleted ? TextDecoration.lineThrough : null,
                        ),
                      ),
                      subtitle: Text(
                        '${DateFormat('hh:mm a').format(item.startTime)} - ${DateFormat('hh:mm a').format(item.endTime)}',
                      ),
                      trailing: item.type == 'study'
                          ? IconButton(
                              icon: const Icon(Icons.timer, color: AppColors.primary),
                              onPressed: () async {
                                await HapticUtils.lightImpact();
                                if (context.mounted) {
                                  context.read<ScheduleCubit>().completePomodoro(item.id);
                                }
                              },
                            )
                          : null,
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  void _confirmEmergencyShift(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(l10n.emergencyShift),
        content: Text(l10n.emergencyShiftConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.no),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.read<ScheduleCubit>().emergencyShiftOneHour();
            },
            child: Text(l10n.yes),
          ),
        ],
      ),
    );
  }
}
