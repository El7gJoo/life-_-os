import 'dart:async';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:geolocator/geolocator.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/utils/haptic_utils.dart';
import '../../../../core/utils/rtl_utils.dart';
import '../../../../core/widgets/category_background_wrapper.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../services/proof_service.dart';
import '../../../settings_backup/data/repositories/settings_repository.dart';
import '../../data/models/schedule_item_model.dart';
import '../cubits/schedule_cubit.dart';
import '../cubits/schedule_state.dart';
import '../widgets/proof_capture_dialog.dart';
import 'subjects_screen.dart';
import 'timetable_screen.dart';

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
          final now = DateTime.now();
          final todayStr = '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
          final todaySessions = state.sessions.where((s) => s.weekday == now.weekday).toList()
            ..sort((a, b) => a.startMinutes.compareTo(b.startMinutes));

          return Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              title: Text(l10n.schedule2),
              backgroundColor: Colors.transparent,
              elevation: 0,
              actions: [
                IconButton(
                  tooltip: l10n.universityTimetable,
                  icon: const Icon(Icons.calendar_month),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const TimetableScreen()),
                    );
                  },
                ),
                IconButton(
                  tooltip: l10n.subjects,
                  icon: const Icon(Icons.menu_book),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const SubjectsScreen()),
                    );
                  },
                ),
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
                // Quick Navigation banner to University Timetable
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: ListTile(
                    leading: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.15),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.school, color: AppColors.primary),
                    ),
                    title: Text(
                      l10n.universityTimetable,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text('${state.sessions.length} sessions • ${state.subjects.length} subjects'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const TimetableScreen()),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 16),

                // Attendance Checklist Section (Part B6)
                if (todaySessions.isNotEmpty) ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        l10n.attendanceChecklist,
                        style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.emeraldGreenLight.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          l10n.attendedPoints(10),
                          style: const TextStyle(
                            color: AppColors.emeraldGreenLight,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  ...todaySessions.map((session) {
                    final subject = state.subjects.firstWhereOrNull((s) => s.id == session.subjectId);
                    final subjectColor = Color(subject?.colorValue ?? 0xFF2196F3);
                    final record = state.attendanceRecords.firstWhereOrNull(
                      (r) => r.sessionId == session.id && r.dateStr == todayStr,
                    );
                    final isAttended = record != null;

                    return Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(
                          color: isAttended
                              ? AppColors.emeraldGreenLight
                              : subjectColor.withValues(alpha: 0.4),
                          width: 1.5,
                        ),
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: subjectColor.withValues(alpha: 0.15),
                          child: Icon(
                            session.type == 'lab'
                                ? Icons.science
                                : session.type == 'section'
                                    ? Icons.group
                                    : Icons.school,
                            color: subjectColor,
                            size: 20,
                          ),
                        ),
                        title: Text(
                          subject?.name ?? 'University Class',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            decoration: isAttended ? TextDecoration.lineThrough : null,
                          ),
                        ),
                        subtitle: Text(
                          '${_formatSessionType(context, session.type)} • ${RtlUtils.formatTime(session.startHour, session.startMinute)} - ${RtlUtils.formatTime(session.endHour, session.endMinute)}',
                        ),
                        trailing: isAttended
                            ? Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: AppColors.emeraldGreenLight.withValues(alpha: 0.15),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      '${l10n.attended} ✓',
                                      style: const TextStyle(
                                        color: AppColors.emeraldGreenLight,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.undo, size: 18, color: Colors.grey),
                                    tooltip: l10n.undo,
                                    onPressed: () => context.read<ScheduleCubit>().undoAttendance(record.id),
                                  ),
                                ],
                              )
                            : ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primary,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                ),
                                onPressed: () async {
                                  final cubit = context.read<ScheduleCubit>();
                                  final settingsRepo = getIt<SettingsRepository>();
                                  final messenger = ScaffoldMessenger.of(context);
                                  await HapticUtils.heavyImpact();

                                  if (settingsRepo.isRequireProofEnabled()) {
                                    bool verifiedViaGps = false;
                                    // 1. Try GPS location check
                                    try {
                                      LocationPermission perm = await Geolocator.checkPermission();
                                      if (perm == LocationPermission.denied) {
                                        perm = await Geolocator.requestPermission();
                                      }
                                      if (perm != LocationPermission.denied && perm != LocationPermission.deniedForever) {
                                        final pos = await Geolocator.getCurrentPosition(
                                          locationSettings: const LocationSettings(
                                            accuracy: LocationAccuracy.high,
                                            timeLimit: Duration(seconds: 4),
                                          ),
                                        );
                                        final gpsResult = getIt<ProofService>().verifyAttendanceLocation(
                                          currentLat: pos.latitude,
                                          currentLng: pos.longitude,
                                        );
                                        if (gpsResult.isValid) {
                                          verifiedViaGps = true;
                                          final error = await cubit.checkInAttendance(
                                            session,
                                            verifiedReason: 'Verified attendance via location',
                                          );
                                          if (error != null) {
                                            messenger.showSnackBar(
                                              SnackBar(content: Text(error), backgroundColor: AppColors.warning),
                                            );
                                          } else {
                                            messenger.showSnackBar(
                                              SnackBar(
                                                content: Text('${l10n.proofVerified} (+10 pts)'),
                                                backgroundColor: AppColors.emeraldGreenLight,
                                              ),
                                            );
                                          }
                                          return;
                                        } else {
                                          final savedLat = settingsRepo.getUniversityLatitude() ?? 0;
                                          final savedLng = settingsRepo.getUniversityLongitude() ?? 0;
                                          final dist = ProofService.calculateDistanceMeters(
                                            pos.latitude,
                                            pos.longitude,
                                            savedLat,
                                            savedLng,
                                          ).toInt();
                                          messenger.showSnackBar(
                                            SnackBar(content: Text(l10n.locationMismatchFallback(dist))),
                                          );
                                        }
                                      } else {
                                        messenger.showSnackBar(
                                          SnackBar(content: Text(l10n.locationPermissionDenied)),
                                        );
                                      }
                                    } catch (_) {
                                      // Location error or timeout: fall back to camera
                                    }

                                    // 2. Fall back to Camera photo proof
                                    if (!verifiedViaGps && context.mounted) {
                                      final passed = await ProofCaptureDialog.show(
                                        context,
                                        type: 'attendance',
                                        targetId: session.id,
                                        subjectName: subject?.name,
                                      );
                                      if (passed && context.mounted) {
                                        final error = await cubit.checkInAttendance(
                                          session,
                                          verifiedReason: 'Verified attendance via photo proof',
                                        );
                                        if (error != null) {
                                          messenger.showSnackBar(
                                            SnackBar(content: Text(error), backgroundColor: AppColors.warning),
                                          );
                                        } else {
                                          messenger.showSnackBar(
                                            SnackBar(
                                              content: Text('${l10n.proofVerified} (+10 pts)'),
                                              backgroundColor: AppColors.emeraldGreenLight,
                                            ),
                                          );
                                        }
                                      }
                                    }
                                  } else {
                                    // Regular check-in when proof is OFF
                                    final error = await cubit.checkInAttendance(session);
                                    if (error != null) {
                                      messenger.showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            error == 'Attendance allowed after session starts'
                                                ? l10n.attendanceBeforeStart
                                                : error == 'Already marked as attended'
                                                    ? l10n.alreadyAttended
                                                    : error,
                                          ),
                                          backgroundColor: AppColors.warning,
                                        ),
                                      );
                                    } else {
                                      messenger.showSnackBar(
                                        SnackBar(
                                          content: Text('${l10n.attended}! +10 pts 🎉'),
                                          backgroundColor: AppColors.emeraldGreenLight,
                                        ),
                                      );
                                    }
                                  }
                                },
                                child: Text(
                                  l10n.attendedPoints(10),
                                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                ),
                              ),
                      ),
                    );
                  }),
                  const SizedBox(height: 16),
                ],

                // DayPlanner Timeline Milestones (Part B4 & B7)
                if (state.dayPlan != null) ...[
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.timeline, color: AppColors.primary),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Smart Day Timeline',
                                    style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              Text(
                                'Commute: ${state.commuteMinutes}m',
                                style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),

                          // Milestones Row
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _buildMilestoneItem(
                                icon: Icons.wb_sunny_outlined,
                                label: l10n.timelineWakeUp,
                                time: state.dayPlan!.wakeUpTime,
                                color: AppColors.neonEnergyLight,
                              ),
                              if (state.dayPlan!.leaveHomeTime != null)
                                _buildMilestoneItem(
                                  icon: Icons.directions_walk,
                                  label: l10n.timelineLeaveHome,
                                  time: state.dayPlan!.leaveHomeTime,
                                  color: AppColors.primary,
                                ),
                              if (state.dayPlan!.returnHomeTime != null)
                                _buildMilestoneItem(
                                  icon: Icons.home_outlined,
                                  label: l10n.timelineReturnHome,
                                  time: state.dayPlan!.returnHomeTime,
                                  color: AppColors.emeraldGreenLight,
                                ),
                              _buildMilestoneItem(
                                icon: Icons.bedtime_outlined,
                                label: l10n.timelineBedtime,
                                time: state.dayPlan!.bedtime,
                                color: AppColors.midnightIndigoLight,
                              ),
                            ],
                          ),

                          // Free Windows & Suggested Study
                          if (state.dayPlan!.freeWindows.isNotEmpty ||
                              state.dayPlan!.suggestedStudyBlocks.isNotEmpty) ...[
                            const SizedBox(height: 14),
                            const Divider(height: 1),
                            const SizedBox(height: 12),
                            Text(
                              'Study Opportunities Today',
                              style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            ...state.dayPlan!.suggestedStudyBlocks.map((block) {
                              return Container(
                                margin: const EdgeInsets.only(bottom: 6),
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withValues(alpha: 0.08),
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(Icons.auto_stories, color: AppColors.primary, size: 18),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        '${l10n.suggestedStudy(block.durationMinutes)}: ${DateFormat('hh:mm a').format(block.start)} - ${DateFormat('hh:mm a').format(block.end)}',
                                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                    TextButton(
                                      style: TextButton.styleFrom(padding: EdgeInsets.zero, visualDensity: VisualDensity.compact),
                                      onPressed: () {
                                        _showPomodoroTimer(
                                          context,
                                          ScheduleItemModel(
                                            title: state.suggestedStudySubject?.name ?? 'Study Block',
                                            type: 'study',
                                            startHour: block.start.hour,
                                            startMinute: block.start.minute,
                                            durationMinutes: block.durationMinutes,
                                          ),
                                        );
                                      },
                                      child: Text(l10n.startPomodoro, style: const TextStyle(fontSize: 12)),
                                    ),
                                  ],
                                ),
                              );
                            }),
                          ],
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],

                // Today's General Tasks Section
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

  Widget _buildMilestoneItem({
    required IconData icon,
    required String label,
    required DateTime? time,
    required Color color,
  }) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.15),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 11, color: Colors.grey),
        ),
        const SizedBox(height: 2),
        Text(
          time != null ? DateFormat('hh:mm a').format(time) : '--:--',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
        ),
      ],
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
    final settingsRepo = getIt<SettingsRepository>();
    if (settingsRepo.isRequireProofEnabled()) {
      if (!mounted) return;
      final passed = await ProofCaptureDialog.show(
        context,
        type: 'study',
        targetId: widget.item.id,
        subjectName: widget.item.title,
      );
      if (!passed || !mounted) return;
    }

    if (mounted) {
      final l10n = AppLocalizations.of(context);
      context.read<ScheduleCubit>().completePomodoro(widget.item.id);
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${l10n.taskCompleted} +20 pts 🎉'),
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
