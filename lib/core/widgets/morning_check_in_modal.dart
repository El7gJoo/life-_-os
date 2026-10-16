import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../features/schedule_study/data/models/schedule_item_model.dart';
import '../../features/schedule_study/presentation/cubits/schedule_cubit.dart';
import '../../l10n/app_localizations.dart';
import '../constants/app_colors.dart';
import '../utils/haptic_utils.dart';

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
    final now = DateTime.now();
    var addedCount = 0;

    for (int i = 0; i < _taskControllers.length; i++) {
      final text = _taskControllers[i].text.trim();
      if (text.isNotEmpty) {
        final item = ScheduleItemModel(
          title: text,
          type: 'errand',
          startHour: _selectedTime.hour + (i * 1), // staggered
          startMinute: _selectedTime.minute,
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

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

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
            const SizedBox(height: 16),
            Text(
              l10n.morningCheckInMessage,
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
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
                    onPressed: () => _submit(context),
                    child: Text(l10n.save),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
