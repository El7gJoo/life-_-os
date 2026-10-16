import 'package:flutter_test/flutter_test.dart';
import 'package:life_os/core/models/result.dart';
import 'package:life_os/core/utils/date_utils.dart';
import 'package:life_os/features/fiancee/data/models/occasion_model.dart';
import 'package:life_os/features/gamification/data/models/ledger_entry_model.dart';
import 'package:life_os/features/schedule_study/data/models/schedule_item_model.dart';

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

  group('Gamification Ledger Tests', () {
    test('LedgerEntryModel handles earned points vs undo reversal', () {
      final entry = LedgerEntryModel(
        points: 20,
        reason: 'Pomodoro complete',
        sourceFeature: 'schedule',
      );
      expect(entry.points, 20);
      expect(entry.isReversal, isFalse);

      final reversal = LedgerEntryModel(
        points: -entry.points,
        reason: 'Reversal of ${entry.reason}',
        sourceFeature: entry.sourceFeature,
        isReversal: true,
        reversalOf: entry.id,
      );
      expect(reversal.points, -20);
      expect(reversal.isReversal, isTrue);
      expect(reversal.reversalOf, entry.id);
    });
  });

  group('Schedule Model & Shift Tests', () {
    test('Emergency shift pushes task start time forward', () {
      final baseDate = DateTime(2026, 10, 16);
      final item = ScheduleItemModel(
        title: 'Study Architecture',
        type: 'study',
        startHour: 10,
        startMinute: 0,
        durationMinutes: 90,
        specificDate: baseDate,
      );

      final initialStart = item.startTime;
      expect(initialStart.hour, 10);
      expect(initialStart.minute, 0);

      final shiftedItem = item.copyWith(shiftMinutes: item.shiftMinutes + 60);
      final shiftedStart = shiftedItem.startTime;
      expect(shiftedStart.hour, 11);
      expect(shiftedStart.minute, 0);
      expect(shiftedItem.endTime.hour, 12);
      expect(shiftedItem.endTime.minute, 30);
    });
  });

  group('Fiancée Occasion Next Occurrence Tests', () {
    test('Calculates next occurrence for yearly repeating occasion', () {
      final now = DateTime.now();
      // Occasion in the past this year
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
