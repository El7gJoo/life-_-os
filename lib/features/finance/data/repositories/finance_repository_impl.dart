import 'package:hive_flutter/hive_flutter.dart';
import '../models/expense_model.dart';
import 'finance_repository.dart';

class FinanceRepositoryImpl implements FinanceRepository {
  final Box _box;

  FinanceRepositoryImpl(this._box);

  @override
  List<ExpenseModel> getExpenses() {
    final list = <ExpenseModel>[];
    for (final key in _box.keys) {
      final data = _box.get(key);
      if (data is Map) {
        list.add(ExpenseModel.fromJson(data));
      }
    }
    list.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    return list;
  }

  @override
  Future<void> addExpense(ExpenseModel expense) async {
    await _box.put(expense.id, expense.toJson());
  }

  @override
  Future<void> deleteExpense(String id) async {
    await _box.delete(id);
  }

  @override
  Map<String, dynamic> exportAll() => Map<String, dynamic>.from(_box.toMap().map(
        (k, v) => MapEntry(k.toString(), v),
      ));

  @override
  Future<void> importAll(Map<String, dynamic> data) async {
    await _box.clear();
    await _box.putAll(data);
  }
}
