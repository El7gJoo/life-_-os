import '../models/expense_model.dart';

abstract class FinanceRepository {
  List<ExpenseModel> getExpenses();
  Future<void> addExpense(ExpenseModel expense);
  Future<void> deleteExpense(String id);
  Map<String, dynamic> exportAll();
  Future<void> importAll(Map<String, dynamic> data);
}
