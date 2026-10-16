import 'package:intl/intl.dart';

class AppDateUtils {
  static DateTime getDayStart(DateTime dateTime, int dayBoundaryHour) {
    if (dateTime.hour < dayBoundaryHour) {
      // Before the boundary, so we're still in the previous day
      final previousDay = dateTime.subtract(const Duration(days: 1));
      return DateTime(previousDay.year, previousDay.month, previousDay.day, dayBoundaryHour);
    }
    return DateTime(dateTime.year, dateTime.month, dateTime.day, dayBoundaryHour);
  }

  static DateTime getDayEnd(DateTime dateTime, int dayBoundaryHour) {
    final start = getDayStart(dateTime, dayBoundaryHour);
    return start.add(const Duration(hours: 24));
  }

  static bool isSameLogicalDay(DateTime a, DateTime b, int dayBoundaryHour) {
    final startA = getDayStart(a, dayBoundaryHour);
    final startB = getDayStart(b, dayBoundaryHour);
    return startA == startB;
  }

  static String formatTime(DateTime dateTime) {
    return DateFormat('HH:mm').format(dateTime);
  }

  static String formatDate(DateTime dateTime) {
    return DateFormat('yyyy-MM-dd').format(dateTime);
  }

  static String formatDateTime(DateTime dateTime) {
    return DateFormat('yyyy-MM-dd HH:mm').format(dateTime);
  }

  static String formatDisplayDate(DateTime dateTime) {
    return DateFormat('MMM d, yyyy').format(dateTime);
  }

  static String formatDisplayDateTime(DateTime dateTime) {
    return DateFormat('MMM d, yyyy • HH:mm').format(dateTime);
  }

  static int daysUntil(DateTime target) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final targetDay = DateTime(target.year, target.month, target.day);
    return targetDay.difference(today).inDays;
  }

  static int hoursUntil(DateTime target) {
    return target.difference(DateTime.now()).inHours;
  }

  static String getWeekKey(DateTime date) {
    // Returns ISO week year-week string e.g. '2024-W01'
    final daysFromMonday = date.weekday - 1;
    final monday = date.subtract(Duration(days: daysFromMonday));
    return '${monday.year}-W${monday.weekOfYear.toString().padLeft(2, '0')}';
  }
}

extension DateTimeExtension on DateTime {
  int get weekOfYear {
    final startOfYear = DateTime(year, 1, 1);
    final firstMonday = startOfYear.weekday == 1
        ? startOfYear
        : startOfYear.add(Duration(days: 8 - startOfYear.weekday));
    if (isBefore(firstMonday)) return 52;
    return (difference(firstMonday).inDays ~/ 7) + 1;
  }
}
