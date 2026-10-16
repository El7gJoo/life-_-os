import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../finance/presentation/cubits/finance_cubit.dart';
import '../../../finance/presentation/cubits/finance_state.dart';
import '../../../gamification/presentation/cubits/gamification_cubit.dart';
import '../../../gamification/presentation/cubits/gamification_state.dart';
import '../../../lifestyle/presentation/cubits/lifestyle_cubit.dart';
import '../../../lifestyle/presentation/cubits/lifestyle_state.dart';
import '../../../schedule_study/presentation/cubits/schedule_cubit.dart';
import '../../../schedule_study/presentation/cubits/schedule_state.dart';

class StatsScreen extends StatelessWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.stats),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Gamification Streak & Points Metrics
          BlocBuilder<GamificationCubit, GamificationState>(
            builder: (context, gamificationState) {
              return Card(
                elevation: 3,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            l10n.pointsOverTime,
                            style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              '${gamificationState.currentPoints} pts',
                              style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        height: 180,
                        child: _buildPointsLineChart(gamificationState),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),

          const SizedBox(height: 16),

          // Spending by Category Pie Chart
          BlocBuilder<FinanceCubit, FinanceState>(
            builder: (context, financeState) {
              return Card(
                elevation: 3,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            l10n.spendingByCategory,
                            style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'Spent: ${financeState.totalSpentToday.toStringAsFixed(1)} ${financeState.currency}',
                            style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      _buildSpendingPieChart(financeState),
                    ],
                  ),
                ),
              );
            },
          ),

          const SizedBox(height: 16),

          // Habit & Consistency Metrics (Study & Lifestyle)
          BlocBuilder<ScheduleCubit, ScheduleState>(
            builder: (context, scheduleState) {
              return BlocBuilder<LifestyleCubit, LifestyleState>(
                builder: (context, lifestyleState) {
                  final completedTasks = scheduleState.items.where((i) => i.isCompleted).length;
                  final totalTasks = scheduleState.items.length;
                  final taskRatio = totalTasks == 0 ? 0.0 : (completedTasks / totalTasks);

                  return Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Consistency & Habits',
                            style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: _buildStatTile(
                                  icon: Icons.checklist_rtl,
                                  color: AppColors.primary,
                                  title: 'Tasks Done',
                                  value: '$completedTasks / $totalTasks',
                                  subtitle: '${(taskRatio * 100).toStringAsFixed(0)}% completion',
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: _buildStatTile(
                                  icon: Icons.water_drop,
                                  color: AppColors.info,
                                  title: 'Water Intake',
                                  value: '${lifestyleState.waterCups} cups',
                                  subtitle: '${((lifestyleState.waterCups / 8.0).clamp(0.0, 1.0) * 100).toInt()}% goal',
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: _buildStatTile(
                                  icon: Icons.fitness_center,
                                  color: AppColors.neonEnergyLight,
                                  title: 'Workout',
                                  value: lifestyleState.gymSession ? 'Completed' : 'Pending',
                                  subtitle: lifestyleState.gymSession ? '+20 pts' : '0 pts',
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: _buildStatTile(
                                  icon: Icons.restaurant,
                                  color: AppColors.emeraldGreenLight,
                                  title: 'Healthy Meals',
                                  value: '${lifestyleState.healthyMeals} meals',
                                  subtitle: '+${lifestyleState.healthyMeals * 5} pts',
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPointsLineChart(GamificationState state) {
    // Generate spots for the last 7 days
    final now = DateTime.now();
    final spots = <FlSpot>[];
    final dayLabels = <String>[];

    for (int i = 6; i >= 0; i--) {
      final day = now.subtract(Duration(days: i));
      dayLabels.add(DateFormat('E').format(day));

      // Sum points on this day
      final dayPoints = state.ledgerEntries.where((entry) {
        return entry.timestamp.year == day.year &&
            entry.timestamp.month == day.month &&
            entry.timestamp.day == day.day;
      }).fold(0, (sum, e) => sum + e.points);

      spots.add(FlSpot((6 - i).toDouble(), dayPoints.toDouble()));
    }

    final maxY = spots.map((s) => s.y).reduce((a, b) => a > b ? a : b);
    final effectiveMaxY = maxY < 50 ? 50.0 : maxY + 10;

    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: effectiveMaxY / 4,
          getDrawingHorizontalLine: (val) => FlLine(
            color: Colors.grey.withValues(alpha: 0.2),
            strokeWidth: 1,
          ),
        ),
        titlesData: FlTitlesData(
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 32,
              interval: effectiveMaxY / 4,
              getTitlesWidget: (val, meta) => Text(
                val.toInt().toString(),
                style: const TextStyle(color: Colors.grey, fontSize: 10),
              ),
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 1,
              getTitlesWidget: (val, meta) {
                final idx = val.toInt();
                if (idx >= 0 && idx < dayLabels.length) {
                  return Text(
                    dayLabels[idx],
                    style: const TextStyle(color: Colors.grey, fontSize: 10),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ),
        borderData: FlBorderData(show: false),
        minX: 0,
        maxX: 6,
        minY: 0,
        maxY: effectiveMaxY,
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            color: AppColors.primary,
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: const FlDotData(show: true),
            belowBarData: BarAreaData(
              show: true,
              color: AppColors.primary.withValues(alpha: 0.15),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSpendingPieChart(FinanceState state) {
    if (state.expenses.isEmpty) {
      return Container(
        height: 160,
        alignment: Alignment.center,
        child: const Text('No expenses recorded yet', style: TextStyle(color: Colors.grey)),
      );
    }

    final categoryTotals = <String, double>{};
    for (final exp in state.expenses) {
      categoryTotals[exp.category] = (categoryTotals[exp.category] ?? 0.0) + exp.amount;
    }

    final colorMap = <String, Color>{
      'food': AppColors.primary,
      'gas': AppColors.neonEnergyLight,
      'drinks': AppColors.romanticRoseLight,
      'transport': AppColors.info,
      'other': AppColors.emeraldGreenLight,
    };

    final sections = <PieChartSectionData>[];
    categoryTotals.forEach((cat, total) {
      final color = colorMap[cat] ?? Colors.purple;
      sections.add(
        PieChartSectionData(
          color: color,
          value: total,
          title: total.toStringAsFixed(0),
          radius: 44,
          titleStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      );
    });

    return Column(
      children: [
        SizedBox(
          height: 160,
          child: PieChart(
            PieChartData(
              sectionsSpace: 2,
              centerSpaceRadius: 36,
              sections: sections,
            ),
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 6,
          children: categoryTotals.keys.map((cat) {
            final color = colorMap[cat] ?? Colors.purple;
            final amount = categoryTotals[cat]!;
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(width: 10, height: 10, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
                const SizedBox(width: 4),
                Text(
                  '${cat.toUpperCase()} (${amount.toStringAsFixed(0)} ${state.currency})',
                  style: const TextStyle(fontSize: 11),
                ),
              ],
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildStatTile({
    required IconData icon,
    required Color color,
    required String title,
    required String value,
    required String subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: color),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: color),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            style: const TextStyle(fontSize: 11, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
