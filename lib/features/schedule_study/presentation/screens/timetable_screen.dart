import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/rtl_utils.dart';
import '../../../../core/widgets/category_background_wrapper.dart';
import '../../../../l10n/app_localizations.dart';
import '../../data/models/class_session_model.dart';
import '../cubits/schedule_cubit.dart';
import '../cubits/schedule_state.dart';
import 'subjects_screen.dart';

class TimetableScreen extends StatefulWidget {
  const TimetableScreen({super.key});

  @override
  State<TimetableScreen> createState() => _TimetableScreenState();
}

class _TimetableScreenState extends State<TimetableScreen> {
  // Egyptian week: Saturday (6), Sunday (7), Monday (1), Tuesday (2), Wednesday (3), Thursday (4), Friday (5)
  static const List<int> _egyptianWeekdays = [6, 7, 1, 2, 3, 4, 5];
  int _selectedWeekday = 6; // default Saturday

  @override
  void initState() {
    super.initState();
    final todayWeekday = DateTime.now().weekday;
    if (_egyptianWeekdays.contains(todayWeekday)) {
      _selectedWeekday = todayWeekday;
    }
  }

  String _getWeekdayName(BuildContext context, int weekday) {
    switch (weekday) {
      case 6:
        return 'Saturday';
      case 7:
        return 'Sunday';
      case 1:
        return 'Monday';
      case 2:
        return 'Tuesday';
      case 3:
        return 'Wednesday';
      case 4:
        return 'Thursday';
      case 5:
        return 'Friday';
      default:
        return '';
    }
  }

  String _getWeekdayShortName(BuildContext context, int weekday) {
    switch (weekday) {
      case 6:
        return 'Sat';
      case 7:
        return 'Sun';
      case 1:
        return 'Mon';
      case 2:
        return 'Tue';
      case 3:
        return 'Wed';
      case 4:
        return 'Thu';
      case 5:
        return 'Fri';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return CategoryBackgroundWrapper(
      category: CategoryTheme.academic,
      child: BlocBuilder<ScheduleCubit, ScheduleState>(
        builder: (context, state) {
          final sessionsForDay = state.sessions
              .where((s) => s.weekday == _selectedWeekday)
              .toList()
            ..sort((a, b) => a.startMinutes.compareTo(b.startMinutes));

          return Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              title: Text(l10n.universityTimetable),
              backgroundColor: Colors.transparent,
              elevation: 0,
              actions: [
                IconButton(
                  icon: const Icon(Icons.menu_book),
                  tooltip: l10n.subjects,
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const SubjectsScreen()),
                    );
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  tooltip: l10n.addSession,
                  onPressed: () => _showSessionDialog(context, state),
                ),
              ],
            ),
            body: Column(
              children: [
                // Day selector bar (Egyptian Week)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    child: Row(
                      children: _egyptianWeekdays.map((day) {
                        final isSelected = day == _selectedWeekday;
                        final count = state.sessions.where((s) => s.weekday == day).length;

                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: ChoiceChip(
                            label: Text(
                              count > 0
                                  ? '${_getWeekdayShortName(context, day)} ($count)'
                                  : _getWeekdayShortName(context, day),
                            ),
                            selected: isSelected,
                            selectedColor: AppColors.primary,
                            labelStyle: TextStyle(
                              color: isSelected ? Colors.white : null,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            ),
                            onSelected: (_) => setState(() => _selectedWeekday = day),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),

                const Divider(height: 1),

                Expanded(
                  child: sessionsForDay.isEmpty
                      ? Center(
                          child: Padding(
                            padding: const EdgeInsets.all(24),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.calendar_month_outlined, size: 64, color: Colors.grey),
                                const SizedBox(height: 16),
                                Text(
                                  '${l10n.noData} (${_getWeekdayName(context, _selectedWeekday)})',
                                  style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey),
                                ),
                                const SizedBox(height: 16),
                                ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
                                  icon: const Icon(Icons.add, color: Colors.white),
                                  label: Text(l10n.addSession, style: const TextStyle(color: Colors.white)),
                                  onPressed: () => _showSessionDialog(context, state),
                                ),
                              ],
                            ),
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: sessionsForDay.length,
                          itemBuilder: (context, index) {
                            final session = sessionsForDay[index];
                            final subject = state.subjects.firstWhereOrNull((s) => s.id == session.subjectId);
                            final color = Color(subject?.colorValue ?? 0xFF2196F3);

                            // Check overlap warning with another session
                            final hasOverlap = sessionsForDay.any((other) => session.overlapsWith(other));

                            return Card(
                              margin: const EdgeInsets.only(bottom: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                                side: BorderSide(
                                  color: hasOverlap ? AppColors.warning : color.withValues(alpha: 0.6),
                                  width: hasOverlap ? 2.0 : 1.5,
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (hasOverlap) ...[
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                        margin: const EdgeInsets.only(bottom: 8),
                                        decoration: BoxDecoration(
                                          color: AppColors.warning.withValues(alpha: 0.15),
                                          borderRadius: BorderRadius.circular(6),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const Icon(Icons.warning_amber_rounded,
                                                color: AppColors.warning, size: 16),
                                            const SizedBox(width: 4),
                                            Flexible(
                                              child: Text(
                                                l10n.sessionOverlapWarning,
                                                style: const TextStyle(
                                                  color: AppColors.warning,
                                                  fontSize: 11,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                    Row(
                                      children: [
                                        Container(
                                          width: 12,
                                          height: 12,
                                          decoration: BoxDecoration(
                                            color: color,
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            subject?.name ?? 'Unknown Subject',
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                          decoration: BoxDecoration(
                                            color: color.withValues(alpha: 0.15),
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          child: Text(
                                            _formatSessionType(context, session.type),
                                            style: TextStyle(
                                              color: color,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    Row(
                                      children: [
                                        const Icon(Icons.access_time, size: 16, color: Colors.grey),
                                        const SizedBox(width: 6),
                                        Text(
                                          '${RtlUtils.formatTime(session.startHour, session.startMinute)} - ${RtlUtils.formatTime(session.endHour, session.endMinute)} (${session.durationMinutes}m)',
                                          style: TextStyle(color: Colors.grey[700], fontSize: 13),
                                        ),
                                        if (session.location != null && session.location!.isNotEmpty) ...[
                                          const SizedBox(width: 12),
                                          const Icon(Icons.location_on_outlined, size: 16, color: Colors.grey),
                                          const SizedBox(width: 4),
                                          Flexible(
                                            child: Text(
                                              session.location!,
                                              style: TextStyle(color: Colors.grey[700], fontSize: 13),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        IconButton(
                                          icon: const Icon(Icons.edit_outlined, size: 18),
                                          tooltip: l10n.edit,
                                          onPressed: () => _showSessionDialog(context, state, session: session),
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.delete_outline, size: 18, color: Colors.grey),
                                          tooltip: l10n.delete,
                                          onPressed: () => _confirmDeleteSession(context, session),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  String _formatSessionType(BuildContext context, String type) {
    final l10n = AppLocalizations.of(context);
    switch (type) {
      case 'lecture':
        return l10n.lecture;
      case 'section':
        return l10n.section;
      case 'lab':
        return l10n.lab;
      default:
        return type;
    }
  }

  void _showSessionDialog(BuildContext context, ScheduleState state, {ClassSession? session}) {
    final l10n = AppLocalizations.of(context);
    if (state.subjects.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.noSubjectsYet)),
      );
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => const SubjectsScreen()),
      );
      return;
    }

    String selectedSubjectId = session?.subjectId ?? state.subjects.first.id;
    String selectedType = session?.type ?? 'lecture';
    int selectedWeekday = session?.weekday ?? _selectedWeekday;
    int startMinutes = session?.startMinutes ?? 540; // 9:00 AM
    int endMinutes = session?.endMinutes ?? 630; // 10:30 AM
    final locationController = TextEditingController(text: session?.location ?? '');
    String? validationError;

    showDialog(
      context: context,
      builder: (dialogCtx) => StatefulBuilder(
        builder: (context, setDialogState) {
          // Check overlap in real-time
          final otherSessions = state.sessions.where((s) => s.id != (session?.id ?? '') && s.weekday == selectedWeekday);
          final hasOverlap = otherSessions.any((s) => startMinutes < s.endMinutes && s.startMinutes < endMinutes);

          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            title: Text(session == null ? l10n.addSession : l10n.edit),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (hasOverlap) ...[
                    Container(
                      padding: const EdgeInsets.all(8),
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: AppColors.warning.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppColors.warning),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.warning_amber_rounded, color: AppColors.warning, size: 20),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              l10n.sessionOverlapWarning,
                              style: const TextStyle(color: AppColors.warning, fontSize: 12),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],

                  if (validationError != null) ...[
                    Text(
                      validationError!,
                      style: const TextStyle(color: AppColors.error, fontSize: 12),
                    ),
                    const SizedBox(height: 8),
                  ],

                  // Subject dropdown
                  DropdownButtonFormField<String>(
                    initialValue: selectedSubjectId,
                    decoration: InputDecoration(
                      labelText: l10n.subjects,
                      border: const OutlineInputBorder(),
                    ),
                    items: state.subjects.map((sub) {
                      return DropdownMenuItem(
                        value: sub.id,
                        child: Row(
                          children: [
                            Container(
                              width: 10,
                              height: 10,
                              decoration: BoxDecoration(
                                color: Color(sub.colorValue),
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(sub.name),
                          ],
                        ),
                      );
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) setDialogState(() => selectedSubjectId = val);
                    },
                  ),

                  const SizedBox(height: 12),

                  // Session Type dropdown
                  DropdownButtonFormField<String>(
                    initialValue: selectedType,
                    decoration: InputDecoration(
                      labelText: l10n.sessionType,
                      border: const OutlineInputBorder(),
                    ),
                    items: [
                      DropdownMenuItem(value: 'lecture', child: Text(l10n.lecture)),
                      DropdownMenuItem(value: 'section', child: Text(l10n.section)),
                      DropdownMenuItem(value: 'lab', child: Text(l10n.lab)),
                    ],
                    onChanged: (val) {
                      if (val != null) setDialogState(() => selectedType = val);
                    },
                  ),

                  const SizedBox(height: 12),

                  // Weekday dropdown
                  DropdownButtonFormField<int>(
                    initialValue: selectedWeekday,
                    decoration: InputDecoration(
                      labelText: l10n.weekday,
                      border: const OutlineInputBorder(),
                    ),
                    items: _egyptianWeekdays.map((day) {
                      return DropdownMenuItem(
                        value: day,
                        child: Text(_getWeekdayName(context, day)),
                      );
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) setDialogState(() => selectedWeekday = val);
                    },
                  ),

                  const SizedBox(height: 12),

                  // Time Pickers
                  Row(
                    children: [
                      Expanded(
                        child: ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Text(l10n.startTime, style: const TextStyle(fontSize: 12)),
                          subtitle: Text(
                            RtlUtils.formatTime(startMinutes ~/ 60, startMinutes % 60),
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          onTap: () async {
                            final picked = await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay(hour: startMinutes ~/ 60, minute: startMinutes % 60),
                            );
                            if (picked != null) {
                              setDialogState(() {
                                startMinutes = picked.hour * 60 + picked.minute;
                              });
                            }
                          },
                        ),
                      ),
                      const Icon(Icons.arrow_forward, color: Colors.grey),
                      Expanded(
                        child: ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Text(l10n.endTime, style: const TextStyle(fontSize: 12)),
                          subtitle: Text(
                            RtlUtils.formatTime(endMinutes ~/ 60, endMinutes % 60),
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          onTap: () async {
                            final picked = await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay(hour: endMinutes ~/ 60, minute: endMinutes % 60),
                            );
                            if (picked != null) {
                              setDialogState(() {
                                endMinutes = picked.hour * 60 + picked.minute;
                              });
                            }
                          },
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  TextField(
                    controller: locationController,
                    decoration: InputDecoration(
                      labelText: l10n.location,
                      border: const OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(dialogCtx).pop(),
                child: Text(l10n.cancel),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
                onPressed: () {
                  // Validate end after start
                  if (endMinutes <= startMinutes) {
                    setDialogState(() => validationError = l10n.invalidTimeRange);
                    return;
                  }

                  final cubit = dialogCtx.read<ScheduleCubit>();
                  final location = locationController.text.trim().isEmpty ? null : locationController.text.trim();

                  if (session == null) {
                    cubit.addSession(ClassSession(
                      id: const Uuid().v4(),
                      subjectId: selectedSubjectId,
                      type: selectedType,
                      weekday: selectedWeekday,
                      startMinutes: startMinutes,
                      endMinutes: endMinutes,
                      location: location,
                    ));
                  } else {
                    cubit.updateSession(session.copyWith(
                      subjectId: selectedSubjectId,
                      type: selectedType,
                      weekday: selectedWeekday,
                      startMinutes: startMinutes,
                      endMinutes: endMinutes,
                      location: location,
                    ));
                  }
                  Navigator.of(dialogCtx).pop();
                },
                child: Text(l10n.save, style: const TextStyle(color: Colors.white)),
              ),
            ],
          );
        },
      ),
    );
  }

  void _confirmDeleteSession(BuildContext context, ClassSession session) {
    final l10n = AppLocalizations.of(context);
    showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        title: Text(l10n.delete),
        content: Text(l10n.confirmDelete),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogCtx).pop(),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            onPressed: () {
              dialogCtx.read<ScheduleCubit>().deleteSession(session.id);
              Navigator.of(dialogCtx).pop();
            },
            child: Text(l10n.delete, style: const TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
