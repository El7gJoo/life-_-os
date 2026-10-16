import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../features/schedule_study/data/models/schedule_item_model.dart';
import '../../features/schedule_study/presentation/cubits/schedule_cubit.dart';
import '../../features/schedule_study/presentation/cubits/schedule_state.dart';
import '../../l10n/app_localizations.dart';
import '../constants/app_colors.dart';
import '../utils/haptic_utils.dart';
import '../utils/rtl_utils.dart';

class MorningCheckInModal extends StatefulWidget {
  const MorningCheckInModal({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const MorningCheckInModal(),
    );
  }

  @override
  State<MorningCheckInModal> createState() => _MorningCheckInModalState();
}

class _MorningCheckInModalState extends State<MorningCheckInModal> {
  final List<TextEditingController> _taskControllers = [TextEditingController()];
  TimeOfDay _selectedTime = const TimeOfDay(hour: 12, minute: 0);
  int _selectedCommute = 45;
  String? _selectedSubjectId;
  bool _initialized = false;

  @override
  void dispose() {
    for (final c in _taskControllers) {
      c.dispose();
    }
    super.dispose();
  }

  void _addTaskField() {
    setState(() {
      _taskControllers.add(TextEditingController());
    });
  }

  Future<void> _submit(BuildContext context) async {
    final scheduleCubit = context.read<ScheduleCubit>();
    final scheduleState = scheduleCubit.state;
    final now = DateTime.now();
    final hasSessionsToday = scheduleState.sessions.any((s) => s.weekday == now.weekday);

    // Save commute time if there are sessions today
    if (hasSessionsToday) {
      await scheduleCubit.setCommuteMinutes(_selectedCommute);
    }

    // Add extra errands/tasks
    var addedCount = 0;
    for (int i = 0; i < _taskControllers.length; i++) {
      final text = _taskControllers[i].text.trim();
      if (text.isNotEmpty) {
        final item = ScheduleItemModel(
          title: text,
          type: 'errand',
          startHour: _selectedTime.hour + (i * 1),
          startMinute: _selectedTime.minute,
          durationMinutes: 45,
          specificDate: DateTime(now.year, now.month, now.day),
        );
        await scheduleCubit.addItem(item);
        addedCount++;
      }
    }

    // If a subject was selected for today, add a study session task if none exists
    if (_selectedSubjectId != null && _selectedSubjectId != 'none') {
      final subject = scheduleState.subjects.firstWhereOrNull((s) => s.id == _selectedSubjectId);
      if (subject != null) {
        final item = ScheduleItemModel(
          title: 'Study: ${subject.name}',
          type: 'study',
          startHour: 17, // default 5:00 PM
          startMinute: 0,
          durationMinutes: 45,
          specificDate: DateTime(now.year, now.month, now.day),
        );
        await scheduleCubit.addItem(item);
        addedCount++;
      }
    }

    if (addedCount > 0) {
      await HapticUtils.mediumImpact();
    }

    if (context.mounted) {
      Navigator.of(context).pop();
    }
  }

  void _showCustomCommuteDialog(BuildContext context) {
    final controller = TextEditingController(text: _selectedCommute.toString());
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Custom Commute Time'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          autofocus: true,
          decoration: const InputDecoration(
            labelText: 'Minutes',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final val = int.tryParse(controller.text.trim());
              if (val != null && val > 0) {
                setState(() => _selectedCommute = val);
                Navigator.of(ctx).pop();
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return BlocBuilder<ScheduleCubit, ScheduleState>(
      builder: (context, state) {
        final now = DateTime.now();
        final hasSessionsToday = state.sessions.any((s) => s.weekday == now.weekday);

        // Pre-fill commute and suggested subject once
        if (!_initialized) {
          _initialized = true;
          _selectedCommute = state.commuteMinutes;
          _selectedSubjectId = state.suggestedStudySubject?.id ?? 'none';
        }

        return Container(
          padding: EdgeInsets.only(
            top: 24,
            left: 20,
            right: 20,
            bottom: bottomInset + 24,
          ),
          decoration: BoxDecoration(
            color: theme.scaffoldBackgroundColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.neonEnergyLight.withValues(alpha: 0.15),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.wb_sunny_rounded,
                        color: AppColors.neonEnergyLight,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.goodMorning,
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            l10n.morningCheckIn,
                            style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),

                // Question 1: Commute Duration (Part B3, shown only if has sessions today)
                if (hasSessionsToday) ...[
                  const SizedBox(height: 20),
                  Text(
                    l10n.commuteQuestion,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    children: [
                      ...[30, 45, 60, 90].map((mins) {
                        final isSelected = _selectedCommute == mins;
                        return ChoiceChip(
                          label: Text(RtlUtils.ltr('${mins}m')),
                          selected: isSelected,
                          selectedColor: AppColors.primary,
                          labelStyle: TextStyle(
                            color: isSelected ? Colors.white : null,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          ),
                          onSelected: (_) => setState(() => _selectedCommute = mins),
                        );
                      }),
                      ActionChip(
                        avatar: const Icon(Icons.edit, size: 14),
                        label: Text(
                          ![30, 45, 60, 90].contains(_selectedCommute)
                              ? '${RtlUtils.ltr(_selectedCommute)}m'
                              : 'Custom',
                        ),
                        onPressed: () => _showCustomCommuteDialog(context),
                      ),
                    ],
                  ),
                ],

                // Question 2: Daily Study Subject Question (Part B5)
                if (state.subjects.isNotEmpty) ...[
                  const SizedBox(height: 20),
                  Text(
                    l10n.studyQuestion,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      ...state.subjects.map((sub) {
                        final isSelected = _selectedSubjectId == sub.id;
                        final isSuggested = state.suggestedStudySubject?.id == sub.id;

                        return ChoiceChip(
                          avatar: isSuggested
                              ? const Icon(Icons.auto_awesome, size: 16, color: Colors.amber)
                              : null,
                          label: Text(
                            isSuggested ? '${sub.name} ✨' : sub.name,
                          ),
                          selected: isSelected,
                          selectedColor: AppColors.primary,
                          labelStyle: TextStyle(
                            color: isSelected ? Colors.white : null,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          ),
                          onSelected: (_) => setState(() => _selectedSubjectId = sub.id),
                        );
                      }),
                      ChoiceChip(
                        label: Text(l10n.noStudyToday),
                        selected: _selectedSubjectId == 'none',
                        onSelected: (_) => setState(() => _selectedSubjectId = 'none'),
                      ),
                    ],
                  ),
                ],

                // Question 3: Any extra tasks / errands today?
                const SizedBox(height: 20),
                Text(
                  l10n.morningCheckInMessage,
                  style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 12),
                ...List.generate(_taskControllers.length, (index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: TextField(
                      controller: _taskControllers[index],
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.check_circle_outline),
                        hintText: '${l10n.taskName} ${index + 1}',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  );
                }),
                TextButton.icon(
                  icon: const Icon(Icons.add),
                  label: Text(l10n.addTask),
                  onPressed: _addTaskField,
                ),
                const SizedBox(height: 8),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.access_time),
                  title: const Text('Start Time for Errands'),
                  trailing: TextButton(
                    child: Text(
                      _selectedTime.format(context),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    onPressed: () async {
                      final picked = await showTimePicker(
                        context: context,
                        initialTime: _selectedTime,
                      );
                      if (picked != null) {
                        setState(() {
                          _selectedTime = picked;
                        });
                      }
                    },
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: Text(l10n.cancel),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
                        onPressed: () => _submit(context),
                        child: Text(l10n.save, style: const TextStyle(color: Colors.white)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
