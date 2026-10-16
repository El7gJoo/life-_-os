import '../models/expense_model.dart';

abstract class FinanceRepository {
  Future<void> addExpense(ExpenseModel expense);
  List<ExpenseModel> getExpenses();
  List<ExpenseModel> getExpensesForDate(DateTime date, [int dayBoundaryHour = 4]);
  List<ExpenseModel> getExpensesForMonth(int year, int month);
  List<ExpenseModel> getExpensesForDateRange(DateTime start, DateTime end);
  Future<void> updateExpense(ExpenseModel expense);
  Future<void> deleteExpense(String id);
  double getTotalSpentToday([int dayBoundaryHour = 4]);
  Map<String, dynamic> exportAll();
  Future<void> importAll(Map<String, dynamic> data);
}
