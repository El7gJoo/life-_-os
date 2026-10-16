import 'package:equatable/equatable.dart';
import '../../data/models/expense_model.dart';

class FinanceState extends Equatable {
  final List<ExpenseModel> expenses;
  final double startingBalance;
  final double totalSpentToday;
  final double remainingPocket;
  final String currency;
  final double weeklyBudget;
  final double monthlyBudget;
  final double weeklySpent;
  final double monthlySpent;
  final String? budgetAlert;

  const FinanceState({
    required this.expenses,
    required this.startingBalance,
    required this.totalSpentToday,
    required this.remainingPocket,
    required this.currency,
    this.weeklyBudget = 0.0,
    this.monthlyBudget = 0.0,
    this.weeklySpent = 0.0,
    this.monthlySpent = 0.0,
    this.budgetAlert,
  });

  FinanceState copyWith({
    List<ExpenseModel>? expenses,
    double? startingBalance,
    double? totalSpentToday,
    double? remainingPocket,
    String? currency,
    double? weeklyBudget,
    double? monthlyBudget,
    double? weeklySpent,
    double? monthlySpent,
    String? budgetAlert,
    bool clearAlert = false,
  }) {
    return FinanceState(
      expenses: expenses ?? this.expenses,
      startingBalance: startingBalance ?? this.startingBalance,
      totalSpentToday: totalSpentToday ?? this.totalSpentToday,
      remainingPocket: remainingPocket ?? this.remainingPocket,
      currency: currency ?? this.currency,
      weeklyBudget: weeklyBudget ?? this.weeklyBudget,
      monthlyBudget: monthlyBudget ?? this.monthlyBudget,
      weeklySpent: weeklySpent ?? this.weeklySpent,
      monthlySpent: monthlySpent ?? this.monthlySpent,
      budgetAlert: clearAlert ? null : (budgetAlert ?? this.budgetAlert),
    );
  }

  @override
  List<Object?> get props => [
        expenses,
        startingBalance,
        totalSpentToday,
        remainingPocket,
        currency,
        weeklyBudget,
        monthlyBudget,
        weeklySpent,
        monthlySpent,
        budgetAlert,
      ];
}
