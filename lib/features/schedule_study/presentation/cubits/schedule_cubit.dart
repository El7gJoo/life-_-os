import 'package:collection/collection.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../gamification/data/models/ledger_entry_model.dart';
import '../../../gamification/data/repositories/gamification_repository.dart';
import '../../../settings_backup/data/repositories/settings_repository.dart';
import '../../../../services/notification_service.dart';
import '../../data/models/attendance_record_model.dart';
import '../../data/models/class_session_model.dart';
import '../../data/models/schedule_item_model.dart';
import '../../data/models/study_log_model.dart';
import '../../data/models/subject_model.dart';
import '../../data/repositories/schedule_repository.dart';
import '../../domain/smart_day_planner.dart';
import 'schedule_state.dart';

class ScheduleCubit extends Cubit<ScheduleState> {
  final ScheduleRepository _scheduleRepository;
  final GamificationRepository _gamificationRepository;
  final NotificationService _notificationService;
  final SettingsRepository _settingsRepository;

  ScheduleCubit(
    this._scheduleRepository,
    this._gamificationRepository,
    this._notificationService,
    this._settingsRepository,
  ) : super(ScheduleState(
          items: _scheduleRepository.getItems(),
          subjects: _scheduleRepository.getSubjects(),
          sessions: _scheduleRepository.getSessions(),
          attendanceRecords: _scheduleRepository.getAttendanceRecords(),
          studyLogs: _scheduleRepository.getStudyLogs(),
          selectedDate: DateTime.now(),
          commuteMinutes: _settingsRepository.getCommuteMinutes(),
        )) {
    _recalculateAll();
  }

  void refresh() {
    _recalculateAll();
  }

  void selectDate(DateTime date) {
    emit(state.copyWith(selectedDate: date));
    _recalculateAll();
  }

  void _recalculateAll() {
    final now = DateTime.now();
    final today = state.selectedDate;
    final items = _scheduleRepository.getItems();
    final subjects = _scheduleRepository.getSubjects();
    final sessions = _scheduleRepository.getSessions();
    final attendance = _scheduleRepository.getAttendanceRecords();
    final studyLogs = _scheduleRepository.getStudyLogs();
    final commute = _settingsRepository.getCommuteMinutes();

    // Today's sessions
    final todaySessions = sessions.where((s) => s.weekday == today.weekday).toList();

    // Tomorrow's sessions for bedtime calculation
    final tomorrow = today.add(const Duration(days: 1));
    final tomorrowSessions = sessions.where((s) => s.weekday == tomorrow.weekday).toList();

    // Smart DayPlanner Timeline
    final dayPlan = SmartDayPlanner.generateTimeline(
      today: today,
      todaySessions: todaySessions,
      commuteMinutes: commute,
      nextDaySessions: tomorrowSessions,
    );

    // Suggested Study Subject
    final suggestedSubject = SmartDayPlanner.suggestStudySubject(
      subjects: subjects,
      todaySessions: todaySessions,
      studyLogs: studyLogs,
      today: today,
    );

    // Now / Next Session calculation
    ClassSession? currentSession;
    ClassSession? nextSession;
    int? countdownMinutes;
    bool isCountingDownToStart = true;

    final todayWeekdaySessions = sessions.where((s) => s.weekday == now.weekday).toList();
    todayWeekdaySessions.sort((a, b) => a.startMinutes.compareTo(b.startMinutes));
    final nowMinutes = now.hour * 60 + now.minute;

    currentSession = todayWeekdaySessions.firstWhereOrNull(
      (s) => nowMinutes >= s.startMinutes && nowMinutes < s.endMinutes,
    );

    if (currentSession != null) {
      isCountingDownToStart = false;
      countdownMinutes = currentSession.endMinutes - nowMinutes;
    } else {
      nextSession = todayWeekdaySessions.firstWhereOrNull(
        (s) => s.startMinutes > nowMinutes,
      );
      if (nextSession != null) {
        isCountingDownToStart = true;
        countdownMinutes = nextSession.startMinutes - nowMinutes;
      }
    }

    emit(state.copyWith(
      items: items,
      subjects: subjects,
      sessions: sessions,
      attendanceRecords: attendance,
      studyLogs: studyLogs,
      commuteMinutes: commute,
      dayPlan: dayPlan,
      targetWakeUpTime: dayPlan.wakeUpTime,
      targetBedtime: dayPlan.bedtime,
      suggestedStudySubject: () => suggestedSubject,
      currentSession: () => currentSession,
      nextSession: () => nextSession,
      countdownMinutes: () => countdownMinutes,
      isCountingDownToStart: isCountingDownToStart,
    ));

    // Schedule milestone notifications
    _scheduleTimelineNotifications(dayPlan);
  }

  Future<void> _scheduleTimelineNotifications(DayPlanOutput plan) async {
    final now = DateTime.now();

    if (plan.wakeUpTime != null && plan.wakeUpTime!.isAfter(now)) {
      await _notificationService.scheduleNotification(
        id: 7001,
        title: 'Good Morning! ☀️',
        body: 'Time to wake up and get ready for your day!',
        scheduledDate: plan.wakeUpTime!,
      );
    }

    if (plan.leaveHomeTime != null && plan.leaveHomeTime!.isAfter(now)) {
      await _notificationService.scheduleNotification(
        id: 7002,
        title: 'Time to Leave for University 🚗',
        body: 'Leave now to arrive comfortably before your first session.',
        scheduledDate: plan.leaveHomeTime!,
      );
    }

    if (plan.returnHomeTime != null && plan.returnHomeTime!.isAfter(now)) {
      await _notificationService.scheduleNotification(
        id: 7003,
        title: 'Welcome Home! 🏠',
        body: 'University sessions complete. Take some rest before your study block.',
        scheduledDate: plan.returnHomeTime!,
      );
    }

    if (plan.bedtime != null) {
      final windDown = plan.bedtime!.subtract(const Duration(minutes: 30));
      if (windDown.isAfter(now)) {
        await _notificationService.scheduleNotification(
          id: 7004,
          title: 'Wind-Down for Bed 🌙',
          body: 'Target bedtime in 30 minutes to secure your 8 hours of sleep!',
          scheduledDate: windDown,
        );
      }
    }
  }

  // Commute duration setting
  Future<void> setCommuteMinutes(int minutes) async {
    await _settingsRepository.setCommuteMinutes(minutes);
    refresh();
  }

  // Subjects Management
  Future<void> addSubject(Subject subject) async {
    await _scheduleRepository.addSubject(subject);
    refresh();
  }

  Future<void> updateSubject(Subject subject) async {
    await _scheduleRepository.updateSubject(subject);
    refresh();
  }

  Future<void> deleteSubject(String id) async {
    await _scheduleRepository.deleteSubject(id);
    refresh();
  }

  // Class Sessions Management
  Future<void> addSession(ClassSession session) async {
    await _scheduleRepository.addSession(session);
    refresh();
  }

  Future<void> updateSession(ClassSession session) async {
    await _scheduleRepository.updateSession(session);
    refresh();
  }

  Future<void> deleteSession(String id) async {
    await _scheduleRepository.deleteSession(id);
    refresh();
  }

  // Attendance Anti-Cheat & Tracking
  Future<String?> checkInAttendance(ClassSession session) async {
    final now = DateTime.now();
    final todayStr = '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';

    // Anti-cheat 1: Check if today is the scheduled weekday
    if (session.weekday != now.weekday) {
      return 'Session is scheduled for another day';
    }

    // Anti-cheat 2: Cannot check in before session start time
    final nowMinutes = now.hour * 60 + now.minute;
    if (nowMinutes < session.startMinutes) {
      return 'Attendance allowed after session starts';
    }

    // Anti-cheat 3: Only once per session per day
    final existing = state.attendanceRecords.firstWhereOrNull(
      (a) => a.sessionId == session.id && a.dateStr == todayStr,
    );
    if (existing != null) {
      return 'Already marked as attended';
    }

    // Award +10 points
    final subject = state.subjects.firstWhereOrNull((s) => s.id == session.subjectId);
    final subjectName = subject?.name ?? 'University Class';
    final typeName = session.type == 'section'
        ? 'Section'
        : session.type == 'lab'
            ? 'Lab'
            : 'Lecture';

    final ledgerEntry = LedgerEntryModel(
      points: 10,
      reason: 'Attended $subjectName ($typeName)',
      sourceFeature: 'schedule',
      timestamp: now,
    );
    await _gamificationRepository.addLedgerEntry(ledgerEntry);

    // Save attendance record
    final record = AttendanceRecord(
      id: const Uuid().v4(),
      sessionId: session.id,
      dateStr: todayStr,
      timestamp: now,
      pointsAwarded: 10,
      ledgerEntryId: ledgerEntry.id,
    );
    await _scheduleRepository.recordAttendance(record);

    refresh();
    return null; // success
  }

  Future<void> undoAttendance(String attendanceId) async {
    final record = state.attendanceRecords.firstWhereOrNull((a) => a.id == attendanceId);
    if (record != null) {
      if (record.ledgerEntryId != null) {
        await _gamificationRepository.addReversal(
          record.ledgerEntryId!,
          'Undo: Attendance',
        );
      }
      await _scheduleRepository.deleteAttendance(attendanceId);
      refresh();
    }
  }

  // Study Logging
  Future<void> logStudySession(String subjectId, int minutes) async {
    final log = StudyLogModel(
      id: const Uuid().v4(),
      subjectId: subjectId,
      date: DateTime.now(),
      minutes: minutes,
    );
    await _scheduleRepository.addStudyLog(log);

    final subject = state.subjects.firstWhereOrNull((s) => s.id == subjectId);
    final ledgerEntry = LedgerEntryModel(
      points: AppConstants.pomodoroPoints,
      reason: 'Study Session: ${subject?.name ?? "General"} ($minutes min)',
      sourceFeature: 'schedule',
      timestamp: DateTime.now(),
    );
    await _gamificationRepository.addLedgerEntry(ledgerEntry);
    refresh();
  }

  // Legacy Schedule Task Methods
  Future<void> addItem(ScheduleItemModel item) async {
    await _scheduleRepository.addItem(item);
    await _notificationService.scheduleNotification(
      id: item.id.hashCode & 0x7FFFFFFF,
      title: 'Upcoming Task: ${item.title}',
      body: 'Scheduled for ${item.startTime.hour.toString().padLeft(2, '0')}:${item.startTime.minute.toString().padLeft(2, '0')}',
      scheduledDate: item.startTime,
    );
    refresh();
  }

  Future<void> toggleTaskCompletion(String id) async {
    final item = state.items.firstWhereOrNull((i) => i.id == id);
    if (item == null) return;

    if (!item.isCompleted) {
      final ledgerEntry = LedgerEntryModel(
        points: AppConstants.taskCompletionPoints,
        reason: 'Completed task: ${item.title}',
        sourceFeature: 'schedule',
        timestamp: DateTime.now(),
      );
      await _gamificationRepository.addLedgerEntry(ledgerEntry);
      await _scheduleRepository.markComplete(id, ledgerEntryId: ledgerEntry.id);
    } else {
      if (item.ledgerEntryId != null) {
        await _gamificationRepository.addReversal(
          item.ledgerEntryId!,
          'Undo: ${item.title}',
        );
      }
      await _scheduleRepository.undoComplete(id);
    }
    refresh();
  }

  Future<void> completePomodoro(String taskId) async {
    final item = state.items.firstWhereOrNull((i) => i.id == taskId);

    final ledgerEntry = LedgerEntryModel(
      points: AppConstants.pomodoroPoints,
      reason: 'Completed Pomodoro session: ${item?.title ?? "Study"}',
      sourceFeature: 'schedule',
      timestamp: DateTime.now(),
    );
    await _gamificationRepository.addLedgerEntry(ledgerEntry);

    if (item != null && !item.isCompleted) {
      await _scheduleRepository.markComplete(taskId, ledgerEntryId: ledgerEntry.id);
    }

    refresh();
  }

  Future<void> emergencyShiftOneHour() async {
    await _scheduleRepository.applyEmergencyShift(shiftMinutes: 60);
    final now = DateTime.now();
    for (final item in _scheduleRepository.getItems()) {
      if (!item.isCompleted && item.startTime.isAfter(now)) {
        await _notificationService.scheduleNotification(
          id: item.id.hashCode & 0x7FFFFFFF,
          title: 'Shifted Task: ${item.title}',
          body: 'Scheduled for ${item.startTime.hour.toString().padLeft(2, '0')}:${item.startTime.minute.toString().padLeft(2, '0')}',
          scheduledDate: item.startTime,
        );
      }
    }
    refresh();
  }
}
