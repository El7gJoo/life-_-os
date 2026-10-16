import 'package:hive_flutter/hive_flutter.dart';
import '../../../../core/constants/app_constants.dart';
import '../models/attendance_record_model.dart';
import '../models/class_session_model.dart';
import '../models/schedule_item_model.dart';
import '../models/study_log_model.dart';
import '../models/subject_model.dart';
import 'schedule_repository.dart';

class ScheduleRepositoryImpl implements ScheduleRepository {
  final Box _box;
  final Box? _subjectsBox;
  final Box? _timetableBox;
  final Box? _attendanceBox;
  final Box? _studyLogsBox;

  ScheduleRepositoryImpl(
    this._box, {
    Box? subjectsBox,
    Box? timetableBox,
    Box? attendanceBox,
    Box? studyLogsBox,
  })  : _subjectsBox = subjectsBox,
        _timetableBox = timetableBox,
        _attendanceBox = attendanceBox,
        _studyLogsBox = studyLogsBox;

  Box get _subBox => _subjectsBox ?? Hive.box(AppConstants.subjectsBox);
  Box get _timeBox => _timetableBox ?? Hive.box(AppConstants.timetableBox);
  Box get _attBox => _attendanceBox ?? Hive.box(AppConstants.attendanceBox);
  Box get _studyBox => _studyLogsBox ?? Hive.box(AppConstants.studyLogsBox);

  // Legacy Schedule Items
  @override
  Future<void> addItem(ScheduleItemModel item) async {
    await _box.put(item.id, item.toJson());
  }

  @override
  List<ScheduleItemModel> getItems() {
    final list = <ScheduleItemModel>[];
    for (final key in _box.keys) {
      final value = _box.get(key);
      if (value is Map) {
        list.add(ScheduleItemModel.fromJson(Map<String, dynamic>.from(value)));
      }
    }
    list.sort((a, b) {
      if (a.startHour != b.startHour) return a.startHour.compareTo(b.startHour);
      return a.startMinute.compareTo(b.startMinute);
    });
    return list;
  }

  @override
  List<ScheduleItemModel> getItemsForDate(DateTime date) {
    return getItems().where((item) {
      if (item.isRecurring) return item.weekday == date.weekday;
      if (item.specificDate != null) {
        return item.specificDate!.year == date.year &&
            item.specificDate!.month == date.month &&
            item.specificDate!.day == date.day;
      }
      return false;
    }).toList();
  }

  @override
  List<ScheduleItemModel> getItemsForWeekday(int weekday) =>
      getItems().where((item) => item.weekday == weekday).toList();

  @override
  Future<void> updateItem(ScheduleItemModel item) async {
    await _box.put(item.id, item.toJson());
  }

  @override
  Future<void> deleteItem(String id) async {
    await _box.delete(id);
  }

  @override
  Future<void> markComplete(String id, {String? ledgerEntryId}) async {
    final raw = _box.get(id);
    if (raw is Map) {
      final model = ScheduleItemModel.fromJson(Map<String, dynamic>.from(raw));
      final updated = model.copyWith(
        isCompleted: true,
        completedAt: DateTime.now(),
        ledgerEntryId: ledgerEntryId,
      );
      await _box.put(id, updated.toJson());
    }
  }

  @override
  Future<void> undoComplete(String id) async {
    final raw = _box.get(id);
    if (raw is Map) {
      final model = ScheduleItemModel.fromJson(Map<String, dynamic>.from(raw));
      final updated = model.copyWith(
        isCompleted: false,
        completedAt: null,
        ledgerEntryId: null,
      );
      await _box.put(id, updated.toJson());
    }
  }

  @override
  Future<void> applyEmergencyShift({int shiftMinutes = 60}) async {
    final items = getItems();
    for (final item in items) {
      if (!item.isCompleted) {
        final updated = item.copyWith(shiftMinutes: item.shiftMinutes + shiftMinutes);
        await _box.put(updated.id, updated.toJson());
      }
    }
  }

  // Subjects
  @override
  Future<void> addSubject(Subject subject) async {
    await _subBox.put(subject.id, subject.toJson());
  }

  @override
  List<Subject> getSubjects() {
    final list = <Subject>[];
    for (final key in _subBox.keys) {
      final raw = _subBox.get(key);
      if (raw is Map) {
        list.add(Subject.fromJson(Map<String, dynamic>.from(raw)));
      }
    }
    list.sort((a, b) => a.name.compareTo(b.name));
    return list;
  }

  @override
  Subject? getSubjectById(String id) {
    final raw = _subBox.get(id);
    if (raw is Map) {
      return Subject.fromJson(Map<String, dynamic>.from(raw));
    }
    return null;
  }

  @override
  Future<void> updateSubject(Subject subject) async {
    await _subBox.put(subject.id, subject.toJson());
  }

  @override
  Future<void> deleteSubject(String id) async {
    await _subBox.delete(id);
    // Also remove any sessions associated with this subject
    final sessions = getSessions().where((s) => s.subjectId == id).toList();
    for (final s in sessions) {
      await deleteSession(s.id);
    }
  }

  // Class Sessions
  @override
  Future<void> addSession(ClassSession session) async {
    await _timeBox.put(session.id, session.toJson());
  }

  @override
  List<ClassSession> getSessions() {
    final list = <ClassSession>[];
    for (final key in _timeBox.keys) {
      final raw = _timeBox.get(key);
      if (raw is Map) {
        list.add(ClassSession.fromJson(Map<String, dynamic>.from(raw)));
      }
    }
    list.sort((a, b) => a.startMinutes.compareTo(b.startMinutes));
    return list;
  }

  @override
  List<ClassSession> getSessionsForWeekday(int weekday) {
    return getSessions().where((s) => s.weekday == weekday).toList();
  }

  @override
  Future<void> updateSession(ClassSession session) async {
    await _timeBox.put(session.id, session.toJson());
  }

  @override
  Future<void> deleteSession(String id) async {
    await _timeBox.delete(id);
  }

  // Attendance Records
  @override
  Future<void> recordAttendance(AttendanceRecord record) async {
    await _attBox.put(record.id, record.toJson());
  }

  @override
  List<AttendanceRecord> getAttendanceRecords() {
    final list = <AttendanceRecord>[];
    for (final key in _attBox.keys) {
      final raw = _attBox.get(key);
      if (raw is Map) {
        list.add(AttendanceRecord.fromJson(Map<String, dynamic>.from(raw)));
      }
    }
    return list;
  }

  @override
  List<AttendanceRecord> getAttendanceForDate(String dateStr) {
    return getAttendanceRecords().where((r) => r.dateStr == dateStr).toList();
  }

  @override
  Future<void> deleteAttendance(String id) async {
    await _attBox.delete(id);
  }

  // Study Logs
  @override
  Future<void> addStudyLog(StudyLogModel log) async {
    await _studyBox.put(log.id, log.toJson());
  }

  @override
  List<StudyLogModel> getStudyLogs() {
    final list = <StudyLogModel>[];
    for (final key in _studyBox.keys) {
      final raw = _studyBox.get(key);
      if (raw is Map) {
        list.add(StudyLogModel.fromJson(Map<String, dynamic>.from(raw)));
      }
    }
    return list;
  }

  @override
  List<StudyLogModel> getStudyLogsForSubject(String subjectId) {
    return getStudyLogs().where((l) => l.subjectId == subjectId).toList();
  }

  // Export / Import
  @override
  Map<String, dynamic> exportAll() => {
        'items': getItems().map((i) => i.toJson()).toList(),
        'subjects': getSubjects().map((s) => s.toJson()).toList(),
        'sessions': getSessions().map((s) => s.toJson()).toList(),
        'attendance': getAttendanceRecords().map((a) => a.toJson()).toList(),
        'studyLogs': getStudyLogs().map((l) => l.toJson()).toList(),
      };

  @override
  Future<void> importAll(Map<String, dynamic> data) async {
    if (data['items'] is List) {
      await _box.clear();
      for (final item in data['items'] as List) {
        if (item is Map) {
          final model = ScheduleItemModel.fromJson(Map<String, dynamic>.from(item));
          await _box.put(model.id, model.toJson());
        }
      }
    }

    if (data['subjects'] is List) {
      await _subBox.clear();
      for (final item in data['subjects'] as List) {
        if (item is Map) {
          final model = Subject.fromJson(Map<String, dynamic>.from(item));
          await _subBox.put(model.id, model.toJson());
        }
      }
    }

    if (data['sessions'] is List) {
      await _timeBox.clear();
      for (final item in data['sessions'] as List) {
        if (item is Map) {
          final model = ClassSession.fromJson(Map<String, dynamic>.from(item));
          await _timeBox.put(model.id, model.toJson());
        }
      }
    }

    if (data['attendance'] is List) {
      await _attBox.clear();
      for (final item in data['attendance'] as List) {
        if (item is Map) {
          final model = AttendanceRecord.fromJson(Map<String, dynamic>.from(item));
          await _attBox.put(model.id, model.toJson());
        }
      }
    }

    if (data['studyLogs'] is List) {
      await _studyBox.clear();
      for (final item in data['studyLogs'] as List) {
        if (item is Map) {
          final model = StudyLogModel.fromJson(Map<String, dynamic>.from(item));
          await _studyBox.put(model.id, model.toJson());
        }
      }
    }
  }
}
