import '../models/attendance_record_model.dart';
import '../models/class_session_model.dart';
import '../models/schedule_item_model.dart';
import '../models/study_log_model.dart';
import '../models/subject_model.dart';

abstract class ScheduleRepository {
  // Legacy / General Schedule Items
  Future<void> addItem(ScheduleItemModel item);
  List<ScheduleItemModel> getItems();
  List<ScheduleItemModel> getItemsForDate(DateTime date);
  List<ScheduleItemModel> getItemsForWeekday(int weekday);
  Future<void> updateItem(ScheduleItemModel item);
  Future<void> deleteItem(String id);
  Future<void> markComplete(String id, {String? ledgerEntryId});
  Future<void> undoComplete(String id);
  Future<void> applyEmergencyShift({int shiftMinutes = 60});

  // Subjects
  Future<void> addSubject(Subject subject);
  List<Subject> getSubjects();
  Subject? getSubjectById(String id);
  Future<void> updateSubject(Subject subject);
  Future<void> deleteSubject(String id);

  // Timetable Class Sessions
  Future<void> addSession(ClassSession session);
  List<ClassSession> getSessions();
  List<ClassSession> getSessionsForWeekday(int weekday);
  Future<void> updateSession(ClassSession session);
  Future<void> deleteSession(String id);

  // Attendance Records
  Future<void> recordAttendance(AttendanceRecord record);
  List<AttendanceRecord> getAttendanceRecords();
  List<AttendanceRecord> getAttendanceForDate(String dateStr);
  Future<void> deleteAttendance(String id);

  // Study Logs
  Future<void> addStudyLog(StudyLogModel log);
  List<StudyLogModel> getStudyLogs();
  List<StudyLogModel> getStudyLogsForSubject(String subjectId);

  // Export / Import
  Map<String, dynamic> exportAll();
  Future<void> importAll(Map<String, dynamic> data);
}
