import 'package:equatable/equatable.dart';
import '../data/models/class_session_model.dart';
import '../data/models/study_log_model.dart';
import '../data/models/subject_model.dart';

class TimeWindow extends Equatable {
  final DateTime start;
  final DateTime end;
  final int durationMinutes;

  TimeWindow({required this.start, required this.end})
      : durationMinutes = end.difference(start).inMinutes;

  @override
  List<Object?> get props => [start, end, durationMinutes];
}

class StudyBlock extends Equatable {
  final DateTime start;
  final DateTime end;
  final int durationMinutes; // 25 or 45 min
  final String? subjectId;

  const StudyBlock({
    required this.start,
    required this.end,
    required this.durationMinutes,
    this.subjectId,
  });

  @override
  List<Object?> get props => [start, end, durationMinutes, subjectId];
}

class DayPlanOutput extends Equatable {
  final DateTime? wakeUpTime;
  final DateTime? leaveHomeTime;
  final DateTime? returnHomeTime;
  final DateTime? bedtime;
  final List<TimeWindow> freeWindows;
  final List<StudyBlock> suggestedStudyBlocks;

  const DayPlanOutput({
    this.wakeUpTime,
    this.leaveHomeTime,
    this.returnHomeTime,
    this.bedtime,
    this.freeWindows = const [],
    this.suggestedStudyBlocks = const [],
  });

  @override
  List<Object?> get props => [
        wakeUpTime,
        leaveHomeTime,
        returnHomeTime,
        bedtime,
        freeWindows,
        suggestedStudyBlocks,
      ];
}

class SmartDayPlanner {
  /// Pure logic timeline generator
  /// [today]: base date for calculations
  /// [todaySessions]: class sessions occurring on [today]
  /// [commuteMinutes]: travel time to university in minutes
  /// [morningRoutineMinutes]: routine time before leaving home (default 30)
  /// [sleepGoalHours]: target hours of sleep (default 8)
  /// [nextDaySessions]: class sessions on tomorrow (to calculate bedtime correctly)
  /// [nextDayCommuteMinutes]: commute time tomorrow
  static DayPlanOutput generateTimeline({
    required DateTime today,
    required List<ClassSession> todaySessions,
    required int commuteMinutes,
    int morningRoutineMinutes = 30,
    int sleepGoalHours = 8,
    List<ClassSession>? nextDaySessions,
    int? nextDayCommuteMinutes,
  }) {
    final nextDay = today.add(const Duration(days: 1));

    // Next day's wake-up time calculation
    DateTime nextDayWakeUp;
    if (nextDaySessions != null && nextDaySessions.isNotEmpty) {
      final sortedNext = List<ClassSession>.from(nextDaySessions)
        ..sort((a, b) => a.startMinutes.compareTo(b.startMinutes));
      final firstNext = sortedNext.first;
      final nextCommute = nextDayCommuteMinutes ?? commuteMinutes;
      final firstNextStart = DateTime(
        nextDay.year,
        nextDay.month,
        nextDay.day,
        firstNext.startHour,
        firstNext.startMinute,
      );
      final nextLeave = firstNextStart.subtract(Duration(minutes: nextCommute));
      nextDayWakeUp = nextLeave.subtract(Duration(minutes: morningRoutineMinutes));
    } else {
      // Default next day wake up at 8:00 AM
      nextDayWakeUp = DateTime(nextDay.year, nextDay.month, nextDay.day, 8, 0);
    }

    // Bedtime = next day's wake up - sleepGoal (default 8 hours)
    final bedtime = nextDayWakeUp.subtract(Duration(hours: sleepGoalHours));

    if (todaySessions.isEmpty) {
      // No sessions today
      return DayPlanOutput(
        wakeUpTime: DateTime(today.year, today.month, today.day, 8, 0),
        leaveHomeTime: null,
        returnHomeTime: null,
        bedtime: bedtime,
        freeWindows: const [],
        suggestedStudyBlocks: [
          StudyBlock(
            start: DateTime(today.year, today.month, today.day, 10, 0),
            end: DateTime(today.year, today.month, today.day, 10, 45),
            durationMinutes: 45,
          ),
          StudyBlock(
            start: DateTime(today.year, today.month, today.day, 16, 0),
            end: DateTime(today.year, today.month, today.day, 16, 45),
            durationMinutes: 45,
          ),
        ],
      );
    }

    // Sort today's sessions by start time
    final sorted = List<ClassSession>.from(todaySessions)
      ..sort((a, b) => a.startMinutes.compareTo(b.startMinutes));

    final first = sorted.first;
    final last = sorted.last;

    final firstStart = DateTime(
      today.year,
      today.month,
      today.day,
      first.startHour,
      first.startMinute,
    );

    final lastEnd = DateTime(
      today.year,
      today.month,
      today.day,
      last.endHour,
      last.endMinute,
    );

    final leaveHomeTime = firstStart.subtract(Duration(minutes: commuteMinutes));
    final wakeUpTime = leaveHomeTime.subtract(Duration(minutes: morningRoutineMinutes));
    final returnHomeTime = lastEnd.add(Duration(minutes: commuteMinutes));

    // Detect free windows (gaps between sessions >= 30 min)
    final freeWindows = <TimeWindow>[];
    final studyBlocks = <StudyBlock>[];

    for (int i = 0; i < sorted.length - 1; i++) {
      final currentEnd = DateTime(
        today.year,
        today.month,
        today.day,
        sorted[i].endHour,
        sorted[i].endMinute,
      );
      final nextStart = DateTime(
        today.year,
        today.month,
        today.day,
        sorted[i + 1].startHour,
        sorted[i + 1].startMinute,
      );

      final gap = nextStart.difference(currentEnd).inMinutes;
      if (gap >= 30) {
        final window = TimeWindow(start: currentEnd, end: nextStart);
        freeWindows.add(window);

        // Suggest study block in the free window
        if (gap >= 45) {
          final blockStart = currentEnd.add(const Duration(minutes: 5));
          studyBlocks.add(StudyBlock(
            start: blockStart,
            end: blockStart.add(const Duration(minutes: 45)),
            durationMinutes: 45,
          ));
        } else {
          final blockStart = currentEnd.add(const Duration(minutes: 5));
          studyBlocks.add(StudyBlock(
            start: blockStart,
            end: blockStart.add(const Duration(minutes: 25)),
            durationMinutes: 25,
          ));
        }
      }
    }

    // Post-return window (from return home to bedtime)
    final eveningStart = returnHomeTime.add(const Duration(minutes: 60)); // 1h rest/dinner
    final eveningEnd = bedtime.subtract(const Duration(minutes: 30)); // 30m wind-down

    if (eveningEnd.isAfter(eveningStart)) {
      final eveningGap = eveningEnd.difference(eveningStart).inMinutes;
      if (eveningGap >= 45) {
        studyBlocks.add(StudyBlock(
          start: eveningStart,
          end: eveningStart.add(const Duration(minutes: 45)),
          durationMinutes: 45,
        ));
      }
    }

    return DayPlanOutput(
      wakeUpTime: wakeUpTime,
      leaveHomeTime: leaveHomeTime,
      returnHomeTime: returnHomeTime,
      bedtime: bedtime,
      freeWindows: freeWindows,
      suggestedStudyBlocks: studyBlocks,
    );
  }

  /// Suggestion algorithm for daily study subject (pure testable function)
  /// 1. Exam within <= 14 days gets highest priority (sorted by closest examDate).
  /// 2. Subject that has a session today gets second priority.
  /// 3. Subject not studied for the longest time gets third priority.
  /// Tie-breaker: alphabetical.
  static Subject? suggestStudySubject({
    required List<Subject> subjects,
    required List<ClassSession> todaySessions,
    required List<StudyLogModel> studyLogs,
    required DateTime today,
  }) {
    if (subjects.isEmpty) return null;

    final todayDate = DateTime(today.year, today.month, today.day);

    // Score subjects based on the 3 tiers
    final scored = subjects.map((subject) {
      // 1. Exam tier (exam within <= 14 days from today)
      int examTier = 0; // 0 = no upcoming exam <= 14 days
      int daysUntilExam = 9999;
      if (subject.examDate != null) {
        final examDay = DateTime(
          subject.examDate!.year,
          subject.examDate!.month,
          subject.examDate!.day,
        );
        final diff = examDay.difference(todayDate).inDays;
        if (diff >= 0 && diff <= 14) {
          examTier = 1;
          daysUntilExam = diff;
        }
      }

      // 2. Has session today
      final hasSessionToday = todaySessions.any((s) => s.subjectId == subject.id);

      // 3. Days since last studied
      final logsForSubject = studyLogs.where((l) => l.subjectId == subject.id).toList();
      int daysSinceLastStudied = 9999;
      if (logsForSubject.isNotEmpty) {
        logsForSubject.sort((a, b) => b.date.compareTo(a.date));
        final lastDate = DateTime(
          logsForSubject.first.date.year,
          logsForSubject.first.date.month,
          logsForSubject.first.date.day,
        );
        daysSinceLastStudied = todayDate.difference(lastDate).inDays;
        if (daysSinceLastStudied < 0) daysSinceLastStudied = 0;
      }

      return _ScoredSubject(
        subject: subject,
        hasExamWithin14Days: examTier == 1,
        daysUntilExam: daysUntilExam,
        hasSessionToday: hasSessionToday,
        daysSinceLastStudied: daysSinceLastStudied,
      );
    }).toList();

    scored.sort((a, b) {
      // Rule 1: Exam within <= 14 days
      if (a.hasExamWithin14Days && !b.hasExamWithin14Days) return -1;
      if (!a.hasExamWithin14Days && b.hasExamWithin14Days) return 1;
      if (a.hasExamWithin14Days && b.hasExamWithin14Days) {
        if (a.daysUntilExam != b.daysUntilExam) {
          return a.daysUntilExam.compareTo(b.daysUntilExam); // closest exam first
        }
      }

      // Rule 2: Session today
      if (a.hasSessionToday && !b.hasSessionToday) return -1;
      if (!a.hasSessionToday && b.hasSessionToday) return 1;

      // Rule 3: Longest since last studied (largest days first)
      if (a.daysSinceLastStudied != b.daysSinceLastStudied) {
        return b.daysSinceLastStudied.compareTo(a.daysSinceLastStudied);
      }

      // Tie breaker: Alphabetical by name
      return a.subject.name.compareTo(b.subject.name);
    });

    return scored.first.subject;
  }
}

class _ScoredSubject {
  final Subject subject;
  final bool hasExamWithin14Days;
  final int daysUntilExam;
  final bool hasSessionToday;
  final int daysSinceLastStudied;

  _ScoredSubject({
    required this.subject,
    required this.hasExamWithin14Days,
    required this.daysUntilExam,
    required this.hasSessionToday,
    required this.daysSinceLastStudied,
  });
}
