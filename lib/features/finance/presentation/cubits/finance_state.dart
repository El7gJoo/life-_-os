import 'package:equatable/equatable.dart';
import '../../data/models/expense_model.dart';

class FinanceState extends Equatable {
  final List<ExpenseModel> expenses;
  final double startingBalance;
  final double totalSpentToday;
  final double remainingPocket;
  final String currency;

  const FinanceState({
    required this.expenses,
    required this.startingBalance,
    required this.totalSpentToday,
    required this.remainingPocket,
    required this.currency,
  });

  FinanceState copyWith({
    List<ExpenseModel>? expenses,
    double? startingBalance,
    double? totalSpentToday,
    double? remainingPocket,
    String? currency,
  }) {
    return FinanceState(
      expenses: expenses ?? this.expenses,
      startingBalance: startingBalance ?? this.startingBalance,
      totalSpentToday: totalSpentToday ?? this.totalSpentToday,
      remainingPocket: remainingPocket ?? this.remainingPocket,
      currency: currency ?? this.currency,
    );
  }

  @override
  List<Object?> get props => [
        expenses,
        startingBalance,
        totalSpentToday,
        remainingPocket,
        currency,
      ];
}
