import 'package:flutter_test/flutter_test.dart';
import 'package:life_os/features/gamification/data/models/ledger_entry_model.dart';
import 'package:life_os/features/gamification/data/repositories/gamification_repository.dart';
import 'package:life_os/features/schedule_study/data/models/attendance_record_model.dart';
import 'package:life_os/features/schedule_study/data/models/class_session_model.dart';
import 'package:life_os/features/schedule_study/data/models/schedule_item_model.dart';
import 'package:life_os/features/schedule_study/data/models/study_log_model.dart';
import 'package:life_os/features/schedule_study/data/models/subject_model.dart';
import 'package:life_os/features/schedule_study/data/repositories/schedule_repository.dart';
import 'package:life_os/features/schedule_study/domain/smart_day_planner.dart';
import 'package:life_os/features/schedule_study/presentation/cubits/schedule_cubit.dart';
import 'package:life_os/features/settings_backup/data/repositories/settings_repository.dart';
import 'package:life_os/services/notification_service.dart';

class MockScheduleRepository extends Fake implements ScheduleRepository {
  List<Subject> subjects = [];
  List<ClassSession> sessions = [];
  List<AttendanceRecord> attendance = [];
  List<StudyLogModel> studyLogs = [];
  List<ScheduleItemModel> items = [];

  @override
  List<Subject> getSubjects() => subjects;
  @override
  Future<void> addSubject(Subject subject) async => subjects.add(subject);
  @override
  Future<void> deleteSubject(String id) async => subjects.removeWhere((s) => s.id == id);
  @override
  Future<void> updateSubject(Subject subject) async {
    final idx = subjects.indexWhere((s) => s.id == subject.id);
    if (idx != -1) subjects[idx] = subject;
  }

  @override
  List<ClassSession> getSessions() => sessions;
  @override
  Future<void> addSession(ClassSession session) async => sessions.add(session);
  @override
  Future<void> deleteSession(String id) async => sessions.removeWhere((s) => s.id == id);
  @override
  Future<void> updateSession(ClassSession session) async {
    final idx = sessions.indexWhere((s) => s.id == session.id);
    if (idx != -1) sessions[idx] = session;
  }

  @override
  List<AttendanceRecord> getAttendanceRecords() => attendance;
  @override
  Future<void> recordAttendance(AttendanceRecord record) async => attendance.add(record);
  @override
  Future<void> deleteAttendance(String id) async => attendance.removeWhere((a) => a.id == id);

  @override
  List<StudyLogModel> getStudyLogs() => studyLogs;
  @override
  Future<void> addStudyLog(StudyLogModel log) async => studyLogs.add(log);

  @override
  List<ScheduleItemModel> getItems() => items;
  @override
  Future<void> addItem(ScheduleItemModel item) async => items.add(item);
  @override
  Future<void> updateItem(ScheduleItemModel item) async {
    final idx = items.indexWhere((i) => i.id == item.id);
    if (idx != -1) items[idx] = item;
  }
}

class MockGamificationRepository extends Fake implements GamificationRepository {
  List<LedgerEntryModel> ledger = [];

  @override
  List<LedgerEntryModel> getLedgerEntries() => ledger;
  @override
  Future<void> addLedgerEntry(LedgerEntryModel entry) async => ledger.add(entry);
  @override
  Future<LedgerEntryModel?> addReversal(String entryId, String reason) async {
    final original = ledger.firstWhere((e) => e.id == entryId);
    final rev = LedgerEntryModel(
      id: 'rev-${DateTime.now().millisecondsSinceEpoch}',
      points: -original.points,
      reason: reason,
      sourceFeature: 'schedule',
      timestamp: DateTime.now(),
      isReversal: true,
      reversalOf: entryId,
    );
    ledger.add(rev);
    return rev;
  }
}

class MockSettingsRepository extends Fake implements SettingsRepository {
  int commute = 45;
  int dayBoundary = 4;

  @override
  int getCommuteMinutes() => commute;
  @override
  Future<void> setCommuteMinutes(int minutes) async => commute = minutes;
  @override
  int getDayBoundaryHour() => dayBoundary;
  @override
  Future<void> setDayBoundaryHour(int hour) async => dayBoundary = hour;
}

class MockNotificationService extends Fake implements NotificationService {
  @override
  Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    DateTime? scheduledTime,
    DateTime? scheduledDate,
    String? payload,
    bool hasDoneAction = false,
    bool hasSnoozeAction = false,
    int priority = 1,
  }) async {}

  @override
  Future<void> cancelNotification(int id) async {}
}

void main() {
  group('SmartDayPlanner Domain Unit Tests', () {
    test('generateTimeline calculates wake-up, leave, return, and bedtime accurately', () {
      final now = DateTime(2026, 10, 17, 8, 0); // Saturday
      final sessions = [
        const ClassSession(
          id: 's1',
          subjectId: 'sub1',
          type: 'lecture',
          weekday: 6, // Saturday
          startMinutes: 540, // 9:00 AM
          endMinutes: 660, // 11:00 AM
        ),
        const ClassSession(
          id: 's2',
          subjectId: 'sub2',
          type: 'section',
          weekday: 6, // Saturday
          startMinutes: 720, // 12:00 PM
          endMinutes: 840, // 2:00 PM
        ),
      ];

      final nextDaySessions = [
        const ClassSession(
          id: 's3',
          subjectId: 'sub1',
          type: 'lecture',
          weekday: 7, // Sunday
          startMinutes: 600, // 10:00 AM
          endMinutes: 720,
        ),
      ];

      final plan = SmartDayPlanner.generateTimeline(
        today: now,
        todaySessions: sessions,
        commuteMinutes: 45,
        nextDaySessions: nextDaySessions,
      );

      // 9:00 AM (540m) - 45m commute = 8:15 AM leave
      expect(plan.leaveHomeTime, isNotNull);
      expect(plan.leaveHomeTime!.hour, 8);
      expect(plan.leaveHomeTime!.minute, 15);

      // 8:15 AM - 30m prep = 7:45 AM wake up
      expect(plan.wakeUpTime, isNotNull);
      expect(plan.wakeUpTime!.hour, 7);
      expect(plan.wakeUpTime!.minute, 45);

      // Last session ends at 2:00 PM (840m) + 45m commute = 2:45 PM (885m) return
      expect(plan.returnHomeTime, isNotNull);
      expect(plan.returnHomeTime!.hour, 14);
      expect(plan.returnHomeTime!.minute, 45);

      // Next day first session at 10:00 AM (600m) - 45m commute - 30m prep = 8:45 AM (525m)
      // Bedtime is 8h (480m) before 8:45 AM = 0:45 AM (or 12:45 AM)
      expect(plan.bedtime, isNotNull);
      expect(plan.bedtime!.hour, 0);
      expect(plan.bedtime!.minute, 45);

      // Free windows detected
      expect(plan.freeWindows.isNotEmpty, isTrue);
      // Study blocks suggested
      expect(plan.suggestedStudyBlocks.isNotEmpty, isTrue);
    });

    test('suggestStudySubject prioritizes exams within 14 days closest first', () {
      final now = DateTime(2026, 10, 17);
      final sub1 = Subject(
        id: '1',
        name: 'Calculus',
        colorValue: 0xFF000000,
        examDate: now.add(const Duration(days: 10)),
      );
      final sub2 = Subject(
        id: '2',
        name: 'Physics',
        colorValue: 0xFF000000,
        examDate: now.add(const Duration(days: 3)), // Closest exam
      );
      final sub3 = Subject(
        id: '3',
        name: 'CS',
        colorValue: 0xFF000000,
        examDate: now.add(const Duration(days: 20)), // > 14 days
      );

      final suggested = SmartDayPlanner.suggestStudySubject(
        subjects: [sub1, sub2, sub3],
        todaySessions: [],
        studyLogs: [],
        today: now,
      );

      expect(suggested, isNotNull);
      expect(suggested!.id, '2'); // Physics is closest
    });

    test('suggestStudySubject prioritizes sessions today when no exams <= 14d', () {
      final now = DateTime(2026, 10, 17);
      final sub1 = const Subject(
        id: '1',
        name: 'Calculus',
        colorValue: 0xFF000000,
      );
      final sub2 = const Subject(
        id: '2',
        name: 'Physics',
        colorValue: 0xFF000000,
      );

      final sessionToday = const ClassSession(
        id: 's1',
        subjectId: '2', // Physics has session today
        type: 'lecture',
        weekday: 6,
        startMinutes: 540,
        endMinutes: 660,
      );

      final suggested = SmartDayPlanner.suggestStudySubject(
        subjects: [sub1, sub2],
        todaySessions: [sessionToday],
        studyLogs: [],
        today: now,
      );

      expect(suggested, isNotNull);
      expect(suggested!.id, '2'); // Physics prioritized
    });

    test('suggestStudySubject prioritizes least studied and alphabetical tie breaker', () {
      final now = DateTime(2026, 10, 17);
      final subA = const Subject(id: 'a', name: 'Algorithms', colorValue: 0xFF000000);
      final subB = const Subject(id: 'b', name: 'Biology', colorValue: 0xFF000000);

      // Both have no sessions today and no exams
      // Sub A has 60 minutes study log, Sub B has 0 minutes
      final logs = [
        StudyLogModel(
          id: 'l1',
          subjectId: 'a',
          date: now,
          minutes: 60,
        ),
      ];

      final suggested = SmartDayPlanner.suggestStudySubject(
        subjects: [subA, subB],
        todaySessions: [],
        studyLogs: logs,
        today: now,
      );

      expect(suggested, isNotNull);
      expect(suggested!.id, 'b'); // Biology is least studied
    });
  });

  group('ScheduleCubit Attendance Anti-Cheat Tests', () {
    late MockScheduleRepository scheduleRepo;
    late MockGamificationRepository gamificationRepo;
    late MockSettingsRepository settingsRepo;
    late MockNotificationService notificationService;
    late ScheduleCubit cubit;

    setUp(() {
      scheduleRepo = MockScheduleRepository();
      gamificationRepo = MockGamificationRepository();
      settingsRepo = MockSettingsRepository();
      notificationService = MockNotificationService();

      cubit = ScheduleCubit(
        scheduleRepo,
        gamificationRepo,
        notificationService,
        settingsRepo,
      );
    });

    test('attendance check-in rejected before session start time', () async {
      final now = DateTime.now();
      final sessionStartMinutes = now.hour * 60 + now.minute + 30; // Starts 30 mins in future

      final futureSession = ClassSession(
        id: 'future-1',
        subjectId: 'sub-1',
        type: 'lecture',
        weekday: now.weekday,
        startMinutes: sessionStartMinutes,
        endMinutes: sessionStartMinutes + 90,
      );

      scheduleRepo.sessions = [futureSession];
      cubit.refresh();

      final error = await cubit.checkInAttendance(futureSession);

      expect(error, isNotNull);
      expect(gamificationRepo.ledger.isEmpty, isTrue);
      expect(scheduleRepo.attendance.isEmpty, isTrue);
    });

    test('attendance check-in accepted after session starts and awards +10 points', () async {
      final now = DateTime.now();
      final sessionStartMinutes = (now.hour * 60 + now.minute - 10).clamp(0, 1440); // Started 10 mins ago

      final pastSession = ClassSession(
        id: 'active-1',
        subjectId: 'sub-1',
        type: 'lecture',
        weekday: now.weekday,
        startMinutes: sessionStartMinutes,
        endMinutes: sessionStartMinutes + 90,
      );

      scheduleRepo.sessions = [pastSession];
      cubit.refresh();

      final error = await cubit.checkInAttendance(pastSession);

      expect(error, isNull);
      expect(gamificationRepo.ledger.length, 1);
      expect(gamificationRepo.ledger.first.points, 10);
      expect(scheduleRepo.attendance.length, 1);
      expect(scheduleRepo.attendance.first.sessionId, 'active-1');
    });

    test('duplicate attendance check-in rejected on the same day', () async {
      final now = DateTime.now();
      final sessionStartMinutes = (now.hour * 60 + now.minute - 10).clamp(0, 1440);

      final activeSession = ClassSession(
        id: 'active-dup',
        subjectId: 'sub-1',
        type: 'lecture',
        weekday: now.weekday,
        startMinutes: sessionStartMinutes,
        endMinutes: sessionStartMinutes + 90,
      );

      scheduleRepo.sessions = [activeSession];
      cubit.refresh();

      // First check-in succeeds
      final first = await cubit.checkInAttendance(activeSession);
      expect(first, isNull);
      expect(gamificationRepo.ledger.length, 1);

      // Second check-in on the same day is rejected
      final second = await cubit.checkInAttendance(activeSession);
      expect(second, isNotNull);
      expect(gamificationRepo.ledger.length, 1); // No new points awarded
    });
  });
}
