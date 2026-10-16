import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../finance/presentation/cubits/finance_cubit.dart';
import '../../../finance/presentation/cubits/finance_state.dart';
import '../../../gamification/presentation/cubits/gamification_cubit.dart';
import '../../../gamification/presentation/cubits/gamification_state.dart';

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
          // Points Summary
          BlocBuilder<GamificationCubit, GamificationState>(
            builder: (context, state) {
              return Card(
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.pointsOverTime,
                        style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        height: 160,
                        child: LineChart(
                          LineChartData(
                            gridData: const FlGridData(show: false),
                            titlesData: const FlTitlesData(show: false),
                            borderData: FlBorderData(show: false),
                            lineBarsData: [
                              LineChartBarData(
                                spots: const [
                                  FlSpot(0, 10),
                                  FlSpot(1, 25),
                                  FlSpot(2, 40),
                                  FlSpot(3, 55),
                                  FlSpot(4, 70),
                                  FlSpot(5, 90),
                                  FlSpot(6, 120),
                                ],
                                isCurved: true,
                                color: AppColors.primary,
                                barWidth: 3,
                                dotData: const FlDotData(show: false),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),

          const SizedBox(height: 16),

          // Spending by Category
          BlocBuilder<FinanceCubit, FinanceState>(
            builder: (context, state) {
              return Card(
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.spendingByCategory,
                        style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        height: 160,
                        child: PieChart(
                          PieChartData(
                            sectionsSpace: 2,
                            centerSpaceRadius: 36,
                            sections: [
                              PieChartSectionData(
                                color: AppColors.primary,
                                value: 40,
                                title: 'Food',
                                radius: 45,
                                titleStyle: const TextStyle(fontSize: 12, color: Colors.white),
                              ),
                              PieChartSectionData(
                                color: AppColors.neonEnergyLight,
                                value: 25,
                                title: 'Gas',
                                radius: 45,
                                titleStyle: const TextStyle(fontSize: 12, color: Colors.white),
                              ),
                              PieChartSectionData(
                                color: AppColors.romanticRoseLight,
                                value: 20,
                                title: 'Drinks',
                                radius: 45,
                                titleStyle: const TextStyle(fontSize: 12, color: Colors.white),
                              ),
                              PieChartSectionData(
                                color: AppColors.emeraldGreenLight,
                                value: 15,
                                title: 'Other',
                                radius: 45,
                                titleStyle: const TextStyle(fontSize: 12, color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
