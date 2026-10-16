import 'package:flutter_test/flutter_test.dart';
import 'package:life_os/core/models/result.dart';
import 'package:life_os/core/utils/date_utils.dart';

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
}
