import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/haptic_utils.dart';
import '../../../../l10n/app_localizations.dart';
import '../cubits/finance_cubit.dart';
import '../cubits/finance_state.dart';
import '../../data/models/expense_model.dart';

class FinanceScreen extends StatelessWidget {
  const FinanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return BlocBuilder<FinanceCubit, FinanceState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text(l10n.pocketTracker),
            backgroundColor: AppColors.emeraldGreenLight,
          ),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Balance overview card
              Card(
                elevation: 3,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Text(
                        l10n.remaining,
                        style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '${state.remainingPocket.toStringAsFixed(1)} ${state.currency}',
                        style: theme.textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: state.remainingPocket >= 0
                              ? AppColors.emeraldGreenLight
                              : AppColors.error,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            children: [
                              Text(l10n.startingBalance, style: theme.textTheme.bodySmall),
                              const SizedBox(height: 4),
                              Text(
                                '${state.startingBalance.toStringAsFixed(0)} ${state.currency}',
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Text(l10n.totalSpent, style: theme.textTheme.bodySmall),
                              const SizedBox(height: 4),
                              Text(
                                '${state.totalSpentToday.toStringAsFixed(1)} ${state.currency}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.error,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),
              Text(
                l10n.addExpense,
                style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),

              // Category chips
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _buildCategoryChip(context, l10n.gasFuel, '⛽', 'gas'),
                  _buildCategoryChip(context, l10n.universityFood, '🍔', 'food'),
                  _buildCategoryChip(context, l10n.coffeeDrinks, '☕', 'drinks'),
                  _buildCategoryChip(context, l10n.transport, '🚗', 'transport'),
                  _buildCategoryChip(context, l10n.other, '🛍️', 'other'),
                ],
              ),

              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    l10n.today,
                    style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              if (state.expenses.isEmpty)
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Center(
                      child: Text(
                        l10n.noData,
                        style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey),
                      ),
                    ),
                  ),
                )
              else
                ...state.expenses.map(
                  (expense) => Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: AppColors.emeraldGreenLight.withValues(alpha: 0.15),
                        child: const Icon(Icons.attach_money, color: AppColors.emeraldGreenLight),
                      ),
                      title: Text(expense.category.toUpperCase()),
                      subtitle: Text(
                        '${DateFormat('hh:mm a').format(expense.timestamp)}${expense.note != null && expense.note!.isNotEmpty ? ' • ${expense.note}' : ''}',
                      ),
                      trailing: Text(
                        '-${expense.amount.toStringAsFixed(1)} ${state.currency}',
                        style: const TextStyle(
                          color: AppColors.error,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCategoryChip(
    BuildContext context,
    String label,
    String emoji,
    String categoryKey,
  ) {
    return ActionChip(
      avatar: Text(emoji),
      label: Text(label),
      onPressed: () => _showAddExpenseDialog(context, label, categoryKey),
    );
  }

  void _showAddExpenseDialog(BuildContext context, String categoryName, String categoryKey) {
    final l10n = AppLocalizations.of(context);
    final amountController = TextEditingController();
    final noteController = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('${l10n.addExpense} ($categoryName)'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: amountController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              autofocus: true,
              decoration: InputDecoration(
                labelText: l10n.amount,
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: noteController,
              decoration: InputDecoration(
                labelText: l10n.note,
                border: const OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () async {
              final amount = double.tryParse(amountController.text.trim());
              if (amount != null && amount > 0) {
                await HapticUtils.lightImpact();
                if (context.mounted) {
                  context.read<FinanceCubit>().addExpense(ExpenseModel(
                        id: const Uuid().v4(),
                        amount: amount,
                        category: categoryKey,
                        note: noteController.text.trim(),
                        timestamp: DateTime.now(),
                      ));
                  Navigator.of(context).pop();
                }
              }
            },
            child: Text(l10n.save),
          ),
        ],
      ),
    );
  }
}
