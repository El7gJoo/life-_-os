import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/haptic_utils.dart';
import '../../../../core/widgets/category_background_wrapper.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../services/csv_export_service.dart';
import '../../data/models/expense_model.dart';
import '../cubits/finance_cubit.dart';
import '../cubits/finance_state.dart';

class FinanceScreen extends StatelessWidget {
  const FinanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return CategoryBackgroundWrapper(
      category: CategoryTheme.finance,
      child: BlocBuilder<FinanceCubit, FinanceState>(
        builder: (context, state) {
          return Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              title: Text(l10n.pocketTracker),
              backgroundColor: Colors.transparent,
              elevation: 0,
              actions: [
                IconButton(
                  tooltip: 'Set Budget',
                  icon: const Icon(Icons.tune),
                  onPressed: () => _showBudgetLimitsDialog(context, state),
                ),
                IconButton(
                  tooltip: 'Export CSV',
                  icon: const Icon(Icons.file_download_outlined),
                  onPressed: () => _exportCsv(context, state),
                ),
              ],
            ),
            body: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Budget Alert Banner
                if (state.budgetAlert != null) ...[
                  Card(
                    color: AppColors.warning.withValues(alpha: 0.15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: const BorderSide(color: AppColors.warning, width: 1.5),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      child: Row(
                        children: [
                          const Icon(Icons.warning_amber_rounded, color: AppColors.warning, size: 28),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Budget Warning',
                                  style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.warning),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  state.budgetAlert!,
                                  style: theme.textTheme.bodySmall,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                ],

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
                            InkWell(
                              onTap: () => _showEditStartingBalanceDialog(context, state.startingBalance),
                              borderRadius: BorderRadius.circular(8),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(l10n.startingBalance, style: theme.textTheme.bodySmall),
                                        const SizedBox(width: 4),
                                        const Icon(Icons.edit, size: 13, color: Colors.grey),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '${state.startingBalance.toStringAsFixed(0)} ${state.currency}',
                                      style: const TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
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
                        const SizedBox(height: 16),
                        const Divider(height: 1),
                        const SizedBox(height: 12),
                        // End-of-day Rollover button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.emeraldGreenLight,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            ),
                            icon: const Icon(Icons.auto_awesome, color: Colors.white, size: 18),
                            label: const Text(
                              'End-of-Day Rollover (+15 pts)',
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                            ),
                            onPressed: () => _confirmRollover(context, state),
                          ),
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
                    Text(
                      '${state.expenses.length} records',
                      style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                if (state.expenses.isEmpty)
                  Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
                  ...state.expenses.reversed.map(
                    (expense) => Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: AppColors.emeraldGreenLight.withValues(alpha: 0.15),
                          child: Icon(_getCategoryIcon(expense.category), color: AppColors.emeraldGreenLight),
                        ),
                        title: Text(
                          expense.category.toUpperCase(),
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                        subtitle: Text(
                          '${DateFormat('hh:mm a').format(expense.timestamp)}${expense.note != null && expense.note!.isNotEmpty ? ' • ${expense.note}' : ''}',
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '-${expense.amount.toStringAsFixed(1)} ${state.currency}',
                              style: const TextStyle(
                                color: AppColors.error,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete_outline, size: 18, color: Colors.grey),
                              onPressed: () => _confirmDeleteExpense(context, expense),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'gas':
        return Icons.local_gas_station;
      case 'food':
        return Icons.restaurant;
      case 'drinks':
        return Icons.coffee;
      case 'transport':
        return Icons.directions_car;
      default:
        return Icons.shopping_bag;
    }
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
      builder: (dialogCtx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
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
            onPressed: () => Navigator.of(dialogCtx).pop(),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.emeraldGreenLight),
            onPressed: () async {
              final amount = double.tryParse(amountController.text.trim());
              if (amount != null && amount > 0) {
                await HapticUtils.lightImpact();
                if (dialogCtx.mounted) {
                  dialogCtx.read<FinanceCubit>().addExpense(ExpenseModel(
                        id: const Uuid().v4(),
                        amount: amount,
                        category: categoryKey,
                        note: noteController.text.trim().isEmpty ? null : noteController.text.trim(),
                        timestamp: DateTime.now(),
                      ));
                  Navigator.of(dialogCtx).pop();
                }
              }
            },
            child: Text(l10n.save, style: const TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showEditStartingBalanceDialog(BuildContext context, double currentBalance) {
    final l10n = AppLocalizations.of(context);
    final controller = TextEditingController(text: currentBalance.toStringAsFixed(0));

    showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(l10n.startingBalance),
        content: TextField(
          controller: controller,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          autofocus: true,
          decoration: InputDecoration(
            labelText: 'New Daily Starting Balance',
            border: const OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogCtx).pop(),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.emeraldGreenLight),
            onPressed: () {
              final val = double.tryParse(controller.text.trim());
              if (val != null && val >= 0) {
                dialogCtx.read<FinanceCubit>().updateStartingBalance(val);
                Navigator.of(dialogCtx).pop();
              }
            },
            child: Text(l10n.save, style: const TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showBudgetLimitsDialog(BuildContext context, FinanceState state) {
    final weeklyController = TextEditingController(
      text: state.weeklyBudget > 0 ? state.weeklyBudget.toStringAsFixed(0) : '',
    );
    final monthlyController = TextEditingController(
      text: state.monthlyBudget > 0 ? state.monthlyBudget.toStringAsFixed(0) : '',
    );

    showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Budget Limits & Alerts'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: weeklyController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Weekly Budget (${state.currency})',
                hintText: 'e.g. 500',
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: monthlyController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Monthly Budget (${state.currency})',
                hintText: 'e.g. 2000',
                border: const OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogCtx).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.emeraldGreenLight),
            onPressed: () {
              final w = double.tryParse(weeklyController.text.trim()) ?? 0.0;
              final m = double.tryParse(monthlyController.text.trim()) ?? 0.0;
              dialogCtx.read<FinanceCubit>().setWeeklyBudget(w);
              dialogCtx.read<FinanceCubit>().setMonthlyBudget(m);
              Navigator.of(dialogCtx).pop();
            },
            child: const Text('Save', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _confirmRollover(BuildContext context, FinanceState state) {
    if (state.remainingPocket < 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cannot rollover: Daily budget was exceeded.')),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('End-of-Day Rollover (+15 pts)'),
        content: Text(
          'You have ${state.remainingPocket.toStringAsFixed(1)} ${state.currency} remaining.\n\nChoose how you want to handle your leftover balance:',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogCtx).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              final cubit = dialogCtx.read<FinanceCubit>();
              final navigator = Navigator.of(dialogCtx);
              final messenger = ScaffoldMessenger.of(context);
              await HapticUtils.heavyImpact();
              await cubit.closeDayRollover(rollToSavings: false);
              navigator.pop();
              messenger.showSnackBar(
                const SnackBar(content: Text('Rolled to tomorrow\'s starting balance! +15 pts earned 🎉')),
              );
            },
            child: const Text('Keep for Tomorrow'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.emeraldGreenLight),
            onPressed: () async {
              final cubit = dialogCtx.read<FinanceCubit>();
              final navigator = Navigator.of(dialogCtx);
              final messenger = ScaffoldMessenger.of(context);
              await HapticUtils.heavyImpact();
              await cubit.closeDayRollover(rollToSavings: true);
              navigator.pop();
              messenger.showSnackBar(
                const SnackBar(content: Text('Transferred to Savings Vault! +15 pts earned 💰')),
              );
            },
            child: const Text('Send to Savings Vault', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _confirmDeleteExpense(BuildContext context, ExpenseModel expense) {
    final l10n = AppLocalizations.of(context);
    showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        title: Text(l10n.delete),
        content: Text('Delete ${expense.category} expense of ${expense.amount.toStringAsFixed(1)}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogCtx).pop(),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            onPressed: () {
              dialogCtx.read<FinanceCubit>().deleteExpense(expense.id);
              Navigator.of(dialogCtx).pop();
            },
            child: Text(l10n.delete, style: const TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Future<void> _exportCsv(BuildContext context, FinanceState state) async {
    try {
      await CsvExportService().exportExpensesToCsv(
        expenses: state.expenses,
        currency: state.currency,
      );
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Export failed: $e')),
        );
      }
    }
  }
}
