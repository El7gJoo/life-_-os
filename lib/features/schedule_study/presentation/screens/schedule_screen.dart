import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/utils/haptic_utils.dart';
import '../../../../core/widgets/category_background_wrapper.dart';
import '../../../../l10n/app_localizations.dart';
import '../../data/models/schedule_item_model.dart';
import '../cubits/schedule_cubit.dart';
import '../cubits/schedule_state.dart';

class ScheduleScreen extends StatelessWidget {
  const ScheduleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return CategoryBackgroundWrapper(
      category: CategoryTheme.academic,
      child: BlocBuilder<ScheduleCubit, ScheduleState>(
        builder: (context, state) {
          return Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              title: Text(l10n.schedule2),
              backgroundColor: Colors.transparent,
              elevation: 0,
              actions: [
                IconButton(
                  tooltip: l10n.emergencyShift,
                  icon: const Icon(Icons.forward_10),
                  onPressed: () => _confirmEmergencyShift(context),
                ),
                IconButton(
                  tooltip: l10n.addTask,
                  icon: const Icon(Icons.add),
                  onPressed: () => _showAddTaskDialog(context),
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
                      onPressed: () => _showAddTaskDialog(context),
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
                          '${DateFormat('hh:mm a').format(item.startTime)} - ${DateFormat('hh:mm a').format(item.endTime)} • ${item.type.toUpperCase()}',
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (item.type == 'study')
                              IconButton(
                                icon: const Icon(Icons.timer_outlined, color: AppColors.primary),
                                tooltip: l10n.startPomodoro,
                                onPressed: () {
                                  _showPomodoroTimer(context, item);
                                },
                              ),
                          ],
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

  void _showAddTaskDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final titleController = TextEditingController();
    String selectedType = 'task';
    TimeOfDay selectedTime = const TimeOfDay(hour: 9, minute: 0);
    int durationMinutes = 60;
    bool isRecurring = false;
    int selectedWeekday = DateTime.now().weekday;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setState) => AlertDialog(
          title: Text(l10n.addTask),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  autofocus: true,
                  decoration: InputDecoration(
                    labelText: l10n.taskName,
                    border: const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  initialValue: selectedType,
                  decoration: const InputDecoration(
                    labelText: 'Type',
                    border: OutlineInputBorder(),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'task', child: Text('Task')),
                    DropdownMenuItem(value: 'study', child: Text('Study / Pomodoro')),
                    DropdownMenuItem(value: 'lecture', child: Text('University Lecture')),
                    DropdownMenuItem(value: 'errand', child: Text('Errand')),
                  ],
                  onChanged: (val) {
                    if (val != null) setState(() => selectedType = val);
                  },
                ),
                const SizedBox(height: 12),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.access_time),
                  title: const Text('Start Time'),
                  trailing: TextButton(
                    child: Text(
                      selectedTime.format(ctx),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    onPressed: () async {
                      final picked = await showTimePicker(
                        context: ctx,
                        initialTime: selectedTime,
                      );
                      if (picked != null) {
                        setState(() => selectedTime = picked);
                      }
                    },
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Duration (min)'),
                    DropdownButton<int>(
                      value: durationMinutes,
                      items: const [
                        DropdownMenuItem(value: 25, child: Text('25 min')),
                        DropdownMenuItem(value: 45, child: Text('45 min')),
                        DropdownMenuItem(value: 60, child: Text('60 min')),
                        DropdownMenuItem(value: 90, child: Text('90 min')),
                        DropdownMenuItem(value: 120, child: Text('120 min')),
                      ],
                      onChanged: (val) {
                        if (val != null) setState(() => durationMinutes = val);
                      },
                    ),
                  ],
                ),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Weekly Recurring'),
                  value: isRecurring,
                  onChanged: (val) => setState(() => isRecurring = val),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: Text(l10n.cancel),
            ),
            ElevatedButton(
              onPressed: () async {
                final title = titleController.text.trim();
                if (title.isNotEmpty) {
                  final now = DateTime.now();
                  final item = ScheduleItemModel(
                    title: title,
                    type: selectedType,
                    startHour: selectedTime.hour,
                    startMinute: selectedTime.minute,
                    durationMinutes: durationMinutes,
                    isRecurring: isRecurring,
                    weekday: isRecurring ? selectedWeekday : 0,
                    specificDate: isRecurring ? null : DateTime(now.year, now.month, now.day),
                  );
                  await context.read<ScheduleCubit>().addItem(item);
                  if (ctx.mounted) Navigator.of(ctx).pop();
                }
              },
              child: Text(l10n.save),
            ),
          ],
        ),
      ),
    );
  }

  void _showPomodoroTimer(BuildContext context, ScheduleItemModel item) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => _PomodoroTimerDialog(item: item),
    );
  }
}

class _PomodoroTimerDialog extends StatefulWidget {
  final ScheduleItemModel item;

  const _PomodoroTimerDialog({required this.item});

  @override
  State<_PomodoroTimerDialog> createState() => _PomodoroTimerDialogState();
}

class _PomodoroTimerDialogState extends State<_PomodoroTimerDialog> {
  int _minutes = 25;
  int _secondsLeft = 25 * 60;
  bool _isRunning = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _minutes = widget.item.durationMinutes <= 30 ? 25 : 45;
    _secondsLeft = _minutes * 60;
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _toggleTimer() {
    if (_isRunning) {
      _timer?.cancel();
      setState(() => _isRunning = false);
    } else {
      setState(() => _isRunning = true);
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (_secondsLeft > 0) {
          setState(() => _secondsLeft--);
        } else {
          timer.cancel();
          _onComplete();
        }
      });
    }
  }

  Future<void> _onComplete() async {
    await HapticUtils.heavyImpact();
    if (mounted) {
      context.read<ScheduleCubit>().completePomodoro(widget.item.id);
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Pomodoro Completed! +${AppConstants.pomodoroPoints} points awarded!'),
          backgroundColor: AppColors.success,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final min = (_secondsLeft ~/ 60).toString().padLeft(2, '0');
    final sec = (_secondsLeft % 60).toString().padLeft(2, '0');
    final progress = 1.0 - (_secondsLeft / (_minutes * 60));

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Text(widget.item.title, textAlign: TextAlign.center),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ChoiceChip(
                label: const Text('25 min'),
                selected: _minutes == 25,
                onSelected: (selected) {
                  if (selected && !_isRunning) {
                    setState(() {
                      _minutes = 25;
                      _secondsLeft = 25 * 60;
                    });
                  }
                },
              ),
              const SizedBox(width: 8),
              ChoiceChip(
                label: const Text('45 min'),
                selected: _minutes == 45,
                onSelected: (selected) {
                  if (selected && !_isRunning) {
                    setState(() {
                      _minutes = 45;
                      _secondsLeft = 45 * 60;
                    });
                  }
                },
              ),
            ],
          ),
          const SizedBox(height: 20),
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 140,
                height: 140,
                child: CircularProgressIndicator(
                  value: progress,
                  strokeWidth: 8,
                  backgroundColor: Colors.grey[200],
                  valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
                ),
              ),
              Text(
                '$min:$sec',
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            _timer?.cancel();
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _toggleTimer,
          child: Text(_isRunning ? 'Pause' : 'Start'),
        ),
        TextButton(
          onPressed: _onComplete,
          child: const Text('Finish Now'),
        ),
      ],
    );
  }
}
