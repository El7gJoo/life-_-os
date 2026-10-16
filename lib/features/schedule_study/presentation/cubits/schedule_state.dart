import 'package:equatable/equatable.dart';
import '../../data/models/attendance_record_model.dart';
import '../../data/models/class_session_model.dart';
import '../../data/models/schedule_item_model.dart';
import '../../data/models/study_log_model.dart';
import '../../data/models/subject_model.dart';
import '../../domain/smart_day_planner.dart';

class ScheduleState extends Equatable {
  final List<ScheduleItemModel> items;
  final List<Subject> subjects;
  final List<ClassSession> sessions;
  final List<AttendanceRecord> attendanceRecords;
  final List<StudyLogModel> studyLogs;
  final DateTime selectedDate;
  final DateTime? targetWakeUpTime;
  final DateTime? targetBedtime;
  final DayPlanOutput? dayPlan;
  final int commuteMinutes;
  final Subject? suggestedStudySubject;
  final ClassSession? currentSession;
  final ClassSession? nextSession;
  final int? countdownMinutes;
  final bool isCountingDownToStart;

  const ScheduleState({
    required this.items,
    this.subjects = const [],
    this.sessions = const [],
    this.attendanceRecords = const [],
    this.studyLogs = const [],
    required this.selectedDate,
    this.targetWakeUpTime,
    this.targetBedtime,
    this.dayPlan,
    this.commuteMinutes = 45,
    this.suggestedStudySubject,
    this.currentSession,
    this.nextSession,
    this.countdownMinutes,
    this.isCountingDownToStart = true,
  });

  ScheduleState copyWith({
    List<ScheduleItemModel>? items,
    List<Subject>? subjects,
    List<ClassSession>? sessions,
    List<AttendanceRecord>? attendanceRecords,
    List<StudyLogModel>? studyLogs,
    DateTime? selectedDate,
    DateTime? targetWakeUpTime,
    DateTime? targetBedtime,
    DayPlanOutput? dayPlan,
    int? commuteMinutes,
    Subject? Function()? suggestedStudySubject,
    ClassSession? Function()? currentSession,
    ClassSession? Function()? nextSession,
    int? Function()? countdownMinutes,
    bool? isCountingDownToStart,
  }) {
    return ScheduleState(
      items: items ?? this.items,
      subjects: subjects ?? this.subjects,
      sessions: sessions ?? this.sessions,
      attendanceRecords: attendanceRecords ?? this.attendanceRecords,
      studyLogs: studyLogs ?? this.studyLogs,
      selectedDate: selectedDate ?? this.selectedDate,
      targetWakeUpTime: targetWakeUpTime ?? this.targetWakeUpTime,
      targetBedtime: targetBedtime ?? this.targetBedtime,
      dayPlan: dayPlan ?? this.dayPlan,
      commuteMinutes: commuteMinutes ?? this.commuteMinutes,
      suggestedStudySubject: suggestedStudySubject != null
          ? suggestedStudySubject()
          : this.suggestedStudySubject,
      currentSession: currentSession != null ? currentSession() : this.currentSession,
      nextSession: nextSession != null ? nextSession() : this.nextSession,
      countdownMinutes:
          countdownMinutes != null ? countdownMinutes() : this.countdownMinutes,
      isCountingDownToStart: isCountingDownToStart ?? this.isCountingDownToStart,
    );
  }

  @override
  List<Object?> get props => [
        items,
        subjects,
        sessions,
        attendanceRecords,
        studyLogs,
        selectedDate,
        targetWakeUpTime,
        targetBedtime,
        dayPlan,
        commuteMinutes,
        suggestedStudySubject,
        currentSession,
        nextSession,
        countdownMinutes,
        isCountingDownToStart,
      ];
}
