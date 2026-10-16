import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/date_utils.dart';
import '../../../../core/utils/haptic_utils.dart';
import '../../../../core/widgets/ask_before_deducting_banner.dart';
import '../../../../core/widgets/category_background_wrapper.dart';
import '../../../../core/widgets/morning_check_in_modal.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../fiancee/presentation/cubits/fiancee_cubit.dart';
import '../../../fiancee/presentation/cubits/fiancee_state.dart';
import '../../../finance/presentation/cubits/finance_cubit.dart';
import '../../../finance/presentation/cubits/finance_state.dart';
import '../../../gamification/presentation/widgets/gamification_bar.dart';
import '../../../lifestyle/presentation/cubits/lifestyle_cubit.dart';
import '../../../lifestyle/presentation/cubits/lifestyle_state.dart';
import '../../../schedule_study/presentation/cubits/schedule_cubit.dart';
import '../../../schedule_study/presentation/cubits/schedule_state.dart';
import '../../../settings_backup/presentation/screens/settings_screen.dart';
import '../../../stats/presentation/screens/stats_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  bool _checkedMorningModal = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_checkedMorningModal) {
      _checkedMorningModal = true;
      // Show check-in if morning hours
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final hour = DateTime.now().hour;
        if (hour >= 4 && hour <= 11 && mounted) {
          MorningCheckInModal.show(context);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return CategoryBackgroundWrapper(
      category: CategoryTheme.academic,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text(l10n.dashboard),
          backgroundColor: Colors.transparent,
          elevation: 0,
          actions: [
            IconButton(
              icon: const Icon(Icons.wb_sunny_outlined),
              tooltip: l10n.morningCheckIn,
              onPressed: () => MorningCheckInModal.show(context),
            ),
            IconButton(
              icon: const Icon(Icons.bar_chart),
              tooltip: l10n.stats,
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const StatsScreen()),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.settings_outlined),
              tooltip: l10n.settings,
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const SettingsScreen()),
                );
              },
            ),
          ],
        ),
        body: ListView(
          padding: const EdgeInsets.only(bottom: 24),
          children: [
            // Top Gamification Bar
            const GamificationBar(),

            // Ask-Before-Deducting Banner (shows if points >= 50)
            const AskBeforeDeductingBanner(),

            // Quick Daily Schedule Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    l10n.today,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton.icon(
                    icon: const Icon(Icons.wb_sunny, size: 16),
                    label: Text(l10n.morningCheckIn),
                    onPressed: () => MorningCheckInModal.show(context),
                  ),
                ],
              ),
            ),

            BlocBuilder<ScheduleCubit, ScheduleState>(
              builder: (context, state) {
                final uncompleted = state.items.where((i) => !i.isCompleted).toList();
                if (uncompleted.isEmpty) {
                  return Card(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Center(
                        child: Text(
                          l10n.noTasksToday,
                          style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey),
                        ),
                      ),
                    ),
                  );
                }
                return Column(
                  children: uncompleted.take(3).map((item) {
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      child: ListTile(
                        leading: IconButton(
                          icon: const Icon(Icons.circle_outlined, color: AppColors.primary),
                          onPressed: () async {
                            await HapticUtils.lightImpact();
                            if (context.mounted) {
                              context.read<ScheduleCubit>().toggleTaskCompletion(item.id);
                            }
                          },
                        ),
                        title: Text(item.title),
                        subtitle: Text(
                          '${DateFormat('hh:mm a').format(item.startTime)} - ${DateFormat('hh:mm a').format(item.endTime)}',
                        ),
                        trailing: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            item.type.toUpperCase(),
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                );
              },
            ),

            const SizedBox(height: 16),

            // Sleep Target Preview Card
            BlocBuilder<ScheduleCubit, ScheduleState>(
              builder: (context, state) {
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.bedtime, size: 16, color: AppColors.midnightIndigoLight),
                                const SizedBox(width: 4),
                                Text(l10n.targetBedtime, style: theme.textTheme.bodySmall),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              state.targetBedtime != null
                                  ? DateFormat('hh:mm a').format(state.targetBedtime!)
                                  : '--:--',
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                          ],
                        ),
                        const Icon(Icons.arrow_forward, color: Colors.grey),
                        Column(
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.wb_sunny, size: 16, color: AppColors.neonEnergyLight),
                                const SizedBox(width: 4),
                                Text(l10n.targetWakeUp, style: theme.textTheme.bodySmall),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              state.targetWakeUpTime != null
                                  ? DateFormat('hh:mm a').format(state.targetWakeUpTime!)
                                  : '--:--',
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 16),

            // Pocket Tracker Quick Balance Card
            BlocBuilder<FinanceCubit, FinanceState>(
              builder: (context, state) {
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              l10n.pocketTracker,
                              style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              '${state.remainingPocket.toStringAsFixed(1)} ${state.currency}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: state.remainingPocket >= 0
                                    ? AppColors.emeraldGreenLight
                                    : AppColors.error,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        LinearProgressIndicator(
                          value: state.startingBalance > 0
                              ? (state.remainingPocket / state.startingBalance).clamp(0.0, 1.0)
                              : 0.0,
                          backgroundColor: Colors.grey[200],
                          valueColor: AlwaysStoppedAnimation<Color>(
                            state.remainingPocket >= 0
                                ? AppColors.emeraldGreenLight
                                : AppColors.error,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${l10n.totalSpent}: ${state.totalSpentToday.toStringAsFixed(1)}',
                              style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey),
                            ),
                            Text(
                              '${l10n.startingBalance}: ${state.startingBalance.toStringAsFixed(1)}',
                              style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 16),

            // Fiancée Next Occasion Countdown Card
            BlocBuilder<FianceeCubit, FianceeState>(
              builder: (context, state) {
                if (state.occasions.isEmpty) return const SizedBox.shrink();
                final next = state.occasions.first;
                final days = AppDateUtils.daysUntil(next.date);

                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  child: ListTile(
                    leading: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.romanticRoseLight.withValues(alpha: 0.15),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.favorite, color: AppColors.romanticRoseLight),
                    ),
                    title: Text(next.title),
                    subtitle: Text(AppDateUtils.formatDisplayDate(next.date)),
                    trailing: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.romanticRoseLight.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        days >= 0 ? '$days days left' : 'Passed',
                        style: const TextStyle(
                          color: AppColors.romanticRoseLight,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 16),

            // Lifestyle Checklist Snapshot
            BlocBuilder<LifestyleCubit, LifestyleState>(
              builder: (context, state) {
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildStatChip(
                          icon: Icons.water_drop,
                          color: AppColors.info,
                          label: '${state.waterCups} cups',
                        ),
                        _buildStatChip(
                          icon: Icons.restaurant,
                          color: AppColors.emeraldGreenLight,
                          label: '${state.healthyMeals} meals',
                        ),
                        _buildStatChip(
                          icon: Icons.fitness_center,
                          color: AppColors.neonEnergyLight,
                          label: state.gymSession ? 'Workout Done' : 'No Gym Yet',
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatChip({
    required IconData icon,
    required Color color,
    required String label,
  }) {
    return Column(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}
