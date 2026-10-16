import 'package:hive_flutter/hive_flutter.dart';
import '../../../../core/utils/date_utils.dart';
import '../models/expense_model.dart';
import 'finance_repository.dart';

class FinanceRepositoryImpl implements FinanceRepository {
  final Box _box;

  FinanceRepositoryImpl(this._box);

  @override
  Future<void> addExpense(ExpenseModel expense) async {
    await _box.put(expense.id, expense.toJson());
  }

  @override
  List<ExpenseModel> getExpenses() {
    final list = <ExpenseModel>[];
    for (final key in _box.keys) {
      final value = _box.get(key);
      if (value is Map) {
        list.add(ExpenseModel.fromJson(Map<String, dynamic>.from(value)));
      }
    }
    list.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    return list;
  }

  @override
  List<ExpenseModel> getExpensesForDate(DateTime date, [int dayBoundaryHour = 4]) =>
      getExpenses()
          .where((e) => AppDateUtils.isSameLogicalDay(e.timestamp, date, dayBoundaryHour))
          .toList();

  @override
  List<ExpenseModel> getExpensesForMonth(int year, int month) =>
      getExpenses()
          .where((e) => e.timestamp.year == year && e.timestamp.month == month)
          .toList();

  @override
  List<ExpenseModel> getExpensesForDateRange(DateTime start, DateTime end) =>
      getExpenses()
          .where((e) => !e.timestamp.isBefore(start) && !e.timestamp.isAfter(end))
          .toList();

  @override
  Future<void> updateExpense(ExpenseModel expense) async {
    await _box.put(expense.id, expense.toJson());
  }

  @override
  Future<void> deleteExpense(String id) async {
    await _box.delete(id);
  }

  @override
  double getTotalSpentToday([int dayBoundaryHour = 4]) {
    return getExpensesForDate(DateTime.now(), dayBoundaryHour)
        .fold(0.0, (sum, e) => sum + e.amount);
  }

  @override
  Map<String, dynamic> exportAll() => {
        'expenses': getExpenses().map((e) => e.toJson()).toList(),
      };

  @override
  Future<void> importAll(Map<String, dynamic> data) async {
    if (data['expenses'] is List) {
      await _box.clear();
      for (final item in data['expenses'] as List) {
        if (item is Map) {
          final expense = ExpenseModel.fromJson(Map<String, dynamic>.from(item));
          await _box.put(expense.id, expense.toJson());
        }
      }
    }
  }
}
