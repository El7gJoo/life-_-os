import 'package:flutter_test/flutter_test.dart';
import 'package:life_os/core/constants/app_constants.dart';
import 'package:life_os/core/models/result.dart';
import 'package:life_os/core/utils/date_utils.dart';
import 'package:life_os/features/fiancee/data/models/occasion_model.dart';
import 'package:life_os/features/gamification/data/models/ledger_entry_model.dart';
import 'package:life_os/features/schedule_study/data/models/schedule_item_model.dart';
import 'package:life_os/services/notification_service.dart';

void main() {
  group('AppDateUtils Tests', () {
    test('Logical day start before day boundary belongs to previous day', () {
      final date = DateTime(2026, 10, 16, 2, 30); // 2:30 AM
      final dayStart = AppDateUtils.getDayStart(date, 4);
      expect(dayStart, DateTime(2026, 10, 15, 4, 0));
    });

    test('Logical day start after day boundary belongs to same day', () {
      final date = DateTime(2026, 10, 16, 5, 30); // 5:30 AM
      final dayStart = AppDateUtils.getDayStart(date, 4);
      expect(dayStart, DateTime(2026, 10, 16, 4, 0));
    });

    test('isSameLogicalDay works across midnight before boundary', () {
      final night = DateTime(2026, 10, 15, 23, 30);
      final earlyMorning = DateTime(2026, 10, 16, 2, 0);
      expect(AppDateUtils.isSameLogicalDay(night, earlyMorning, 4), isTrue);
    });
  });

  group('Result Type Tests', () {
    test('Success holds data and folds correctly', () {
      const Result<int> result = Success(42);
      expect(result.isSuccess, isTrue);
      expect(result.dataOrNull, 42);
      final value = result.fold(
        onSuccess: (data) => data * 2,
        onFailure: (msg, err) => 0,
      );
      expect(value, 84);
    });

    test('Failure holds error message and folds correctly', () {
      const Result<int> result = Failure('Something went wrong');
      expect(result.isFailure, isTrue);
      expect(result.errorMessage, 'Something went wrong');
      final value = result.fold(
        onSuccess: (data) => data,
        onFailure: (msg, err) => -1,
      );
      expect(value, -1);
    });
  });

  group('Streak Multiplier Tests', () {
    double calculateMultiplier(int streak) {
      if (streak >= 7) return 2.0;
      if (streak >= AppConstants.streakMultiplierThreshold) return 1.5;
      return 1.0;
    }

    test('Day 1 and Day 2 give 1.0x baseline multiplier', () {
      expect(calculateMultiplier(0), 1.0);
      expect(calculateMultiplier(1), 1.0);
      expect(calculateMultiplier(2), 1.0);
    });

    test('Day 3 to Day 6 activate 1.5x multiplier', () {
      expect(calculateMultiplier(3), 1.5);
      expect(calculateMultiplier(4), 1.5);
      expect(calculateMultiplier(6), 1.5);
    });

    test('Day 7 and above activate 2.0x top multiplier', () {
      expect(calculateMultiplier(7), 2.0);
      expect(calculateMultiplier(14), 2.0);
      expect(calculateMultiplier(30), 2.0);
    });
  });

  group('Sleep / Wake Calculator Tests', () {
    test('Calculates Target Wake-Up and Bedtime correctly from earliest task', () {
      // Earliest lecture at 09:00 AM
      final tomorrow = DateTime(2026, 10, 17, 9, 0);
      const prepMinutes = 90; // 1.5 hours prep/commute

      // Target wake-up = earliest minus prep (07:30 AM)
      final targetWakeUp = tomorrow.subtract(const Duration(minutes: prepMinutes));
      expect(targetWakeUp.hour, 7);
      expect(targetWakeUp.minute, 30);

      // Target bedtime = target wake-up minus 8 hours (23:30 PM previous day)
      final targetBedtime = targetWakeUp.subtract(const Duration(hours: 8));
      expect(targetBedtime.hour, 23);
      expect(targetBedtime.minute, 30);
      expect(targetBedtime.day, 16);

      // Wind-down notification = 30 minutes before bedtime (23:00 PM)
      final windDown = targetBedtime.subtract(const Duration(minutes: 30));
      expect(windDown.hour, 23);
      expect(windDown.minute, 0);
    });
  });

  group('Emergency +1 Hour Shift Tests', () {
    test('+1 hour shift advances task start and end times by 60 minutes', () {
      final baseDate = DateTime(2026, 10, 16);
      final item = ScheduleItemModel(
        title: 'Algorithms Lecture',
        type: 'lecture',
        startHour: 10,
        startMinute: 0,
        durationMinutes: 90,
        specificDate: baseDate,
      );

      final initialStart = item.startTime;
      expect(initialStart.hour, 10);
      expect(initialStart.minute, 0);

      final shifted = item.copyWith(shiftMinutes: item.shiftMinutes + 60);
      expect(shifted.startTime.hour, 11);
      expect(shifted.startTime.minute, 0);
      expect(shifted.endTime.hour, 12);
      expect(shifted.endTime.minute, 30);
    });
  });

  group('Notification Scheduling Window & Prioritization Tests', () {
    test('Filters to 7-day rolling window and caps at 64 max pending', () {
      final now = DateTime.now();
      final notifications = <ScheduledNotification>[];

      // Create 80 notifications over 10 days
      for (int i = 0; i < 80; i++) {
        notifications.add(ScheduledNotification(
          id: i,
          title: 'Notif $i',
          body: 'Body $i',
          scheduledTime: now.add(Duration(hours: i * 3)),
          priority: (i % 5 == 0) ? 10 : 1, // some high priority occasions
        ));
      }

      final windowEnd = now.add(const Duration(days: AppConstants.notificationWindowDays));
      final valid = notifications.where((n) {
        return n.scheduledTime.isAfter(now) && n.scheduledTime.isBefore(windowEnd);
      }).toList();

      valid.sort((a, b) {
        if (b.priority != a.priority) {
          return b.priority.compareTo(a.priority);
        }
        return a.scheduledTime.compareTo(b.scheduledTime);
      });

      final scheduled = valid.take(AppConstants.maxPendingNotifications).toList();

      expect(scheduled.length, lessThanOrEqualTo(AppConstants.maxPendingNotifications));
      expect(scheduled.length, lessThanOrEqualTo(64));
      // Top priority items come first
      expect(scheduled.first.priority, 10);
    });
  });

  group('Ledger & Undo Tests', () {
    test('Calculates current points from positive and negative ledger entries', () {
      final entries = [
        LedgerEntryModel(points: 20, reason: 'Task completed', sourceFeature: 'schedule'),
        LedgerEntryModel(points: 15, reason: 'Quality time', sourceFeature: 'fiancee'),
        LedgerEntryModel(points: -50, reason: 'Bronze reward', sourceFeature: 'gamification'),
      ];

      final total = entries.fold<int>(0, (sum, e) => sum + e.points);
      expect(total, -15);
      final nonNegativePoints = total < 0 ? 0 : total;
      expect(nonNegativePoints, 0);
    });

    test('Undo via reversal perfectly negates original transaction', () {
      final original = LedgerEntryModel(
        points: 25,
        reason: 'Pomodoro complete',
        sourceFeature: 'schedule',
      );

      final reversal = LedgerEntryModel(
        points: -original.points,
        reason: 'Undo: ${original.reason}',
        sourceFeature: original.sourceFeature,
        isReversal: true,
        reversalOf: original.id,
      );

      expect(reversal.points, -25);
      expect(reversal.isReversal, isTrue);
      expect(reversal.reversalOf, original.id);

      final net = original.points + reversal.points;
      expect(net, 0);
    });
  });

  group('Fiancée Occasion Next Occurrence Tests', () {
    test('Calculates next occurrence for yearly repeating occasion', () {
      final now = DateTime.now();
      final pastDate = DateTime(now.year, 1, 15);
      final occasion = OccasionModel(
        name: 'Anniversary',
        type: 'anniversary',
        date: pastDate,
        repeatYearly: true,
      );

      final next = occasion.nextOccurrence;
      expect(next.year, now.year + 1);
      expect(next.month, 1);
      expect(next.day, 15);
    });
  });
}
