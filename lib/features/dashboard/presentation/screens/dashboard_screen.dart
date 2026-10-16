import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/date_utils.dart';
import '../../../../core/utils/haptic_utils.dart';
import '../../../../core/utils/rtl_utils.dart';
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
import 'package:collection/collection.dart';
import '../../../schedule_study/presentation/cubits/schedule_cubit.dart';
import '../../../schedule_study/presentation/cubits/schedule_state.dart';
import '../../../schedule_study/presentation/screens/schedule_screen.dart';
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

            // University & Daily Schedule Section
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

            // Now / Next Session Card & Smart Day Timeline
            BlocBuilder<ScheduleCubit, ScheduleState>(
              builder: (context, state) {
                return Column(
                  children: [
                    _buildNowNextCard(context, state, l10n, theme),
                    if (state.dayPlan != null)
                      _buildDayPlanTimeline(context, state, l10n, theme),
                    const SizedBox(height: 8),
                    _buildTodayTasksList(context, state, l10n, theme),
                  ],
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
                              RtlUtils.formatCurrency(state.remainingPocket, state.currency),
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
                              '${l10n.totalSpent}: ${RtlUtils.formatCurrency(state.totalSpentToday, state.currency)}',
                              style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey),
                            ),
                            Text(
                              '${l10n.startingBalance}: ${RtlUtils.formatCurrency(state.startingBalance, state.currency, decimals: 0)}',
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
                        days == 0
                            ? l10n.todayExclamation
                            : days > 0
                                ? l10n.daysLeft(days)
                                : l10n.passed,
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
                          label: l10n.waterCups(state.waterCups),
                        ),
                        _buildStatChip(
                          icon: Icons.restaurant,
                          color: AppColors.emeraldGreenLight,
                          label: '${RtlUtils.ltr(state.healthyMeals)} ${l10n.meals}',
                        ),
                        _buildStatChip(
                          icon: Icons.fitness_center,
                          color: AppColors.neonEnergyLight,
                          label: state.gymSession ? l10n.done : l10n.gymSession,
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

  Widget _buildNowNextCard(
    BuildContext context,
    ScheduleState state,
    AppLocalizations l10n,
    ThemeData theme,
  ) {
    final current = state.currentSession;
    final next = state.nextSession;
    final minutes = state.countdownMinutes ?? 0;

    if (current == null && next == null) {
      return Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: ListTile(
          leading: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.grey.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.event_available, color: Colors.grey),
          ),
          title: Text(
            l10n.noUpcomingSessions,
            style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey),
          ),
          trailing: const Icon(Icons.chevron_right, color: Colors.grey),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const ScheduleScreen()),
            );
          },
        ),
      );
    }

    final isNow = current != null;
    final session = isNow ? current : next!;
    final subject = state.subjects.firstWhereOrNull((s) => s.id == session.subjectId);
    final subjectColor = subject != null ? Color(subject.colorValue) : AppColors.primary;
    final subjectName = subject?.name ?? l10n.subjects;

    String typeLabel;
    switch (session.type) {
      case 'lecture':
        typeLabel = l10n.lecture;
        break;
      case 'section':
        typeLabel = l10n.section;
        break;
      case 'lab':
        typeLabel = l10n.lab;
        break;
      default:
        typeLabel = session.type;
    }

    final title = isNow ? l10n.nowCard : l10n.nextCard;
    final countdownStr = isNow
        ? l10n.endsIn(RtlUtils.ltr('${minutes}m'))
        : l10n.startsIn(RtlUtils.ltr('${minutes}m'));

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const ScheduleScreen()),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: subjectColor.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                  border: Border.all(color: subjectColor, width: 2),
                ),
                child: Icon(
                  isNow ? Icons.school : Icons.schedule,
                  color: subjectColor,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: (isNow ? AppColors.emeraldGreenLight : AppColors.primary).withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            title,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: isNow ? AppColors.emeraldGreenLight : AppColors.primary,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          typeLabel,
                          style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subjectName,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      countdownStr,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: isNow ? AppColors.emeraldGreenLight : AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDayPlanTimeline(
    BuildContext context,
    ScheduleState state,
    AppLocalizations l10n,
    ThemeData theme,
  ) {
    final plan = state.dayPlan;
    if (plan == null) return const SizedBox.shrink();

    final milestones = <Widget>[];

    if (plan.wakeUpTime != null) {
      milestones.add(_buildTimelineNode(
        icon: Icons.wb_sunny_outlined,
        color: AppColors.neonEnergyLight,
        label: l10n.timelineWakeUp,
        time: DateFormat('hh:mm a').format(plan.wakeUpTime!),
      ));
    }

    if (plan.leaveHomeTime != null) {
      milestones.add(_buildTimelineNode(
        icon: Icons.directions_car,
        color: AppColors.info,
        label: l10n.timelineLeaveHome,
        time: DateFormat('hh:mm a').format(plan.leaveHomeTime!),
      ));
    }

    if (plan.returnHomeTime != null) {
      milestones.add(_buildTimelineNode(
        icon: Icons.home,
        color: AppColors.emeraldGreenLight,
        label: l10n.timelineReturnHome,
        time: DateFormat('hh:mm a').format(plan.returnHomeTime!),
      ));
    }

    if (plan.suggestedStudyBlocks.isNotEmpty) {
      final totalStudyMinutes = plan.suggestedStudyBlocks.fold(0, (sum, b) => sum + b.durationMinutes);
      milestones.add(_buildTimelineNode(
        icon: Icons.menu_book,
        color: AppColors.primary,
        label: l10n.suggestedStudy(totalStudyMinutes),
        time: '${plan.suggestedStudyBlocks.length} blocks',
      ));
    }

    if (plan.bedtime != null) {
      milestones.add(_buildTimelineNode(
        icon: Icons.bedtime,
        color: AppColors.midnightIndigoLight,
        label: l10n.timelineBedtime,
        time: DateFormat('hh:mm a').format(plan.bedtime!),
      ));
    }

    if (milestones.isEmpty) return const SizedBox.shrink();

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: milestones.expand((w) => [w, const SizedBox(width: 8)]).toList()..removeLast(),
          ),
        ),
      ),
    );
  }

  Widget _buildTimelineNode({
    required IconData icon,
    required Color color,
    required String label,
    required String time,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 6),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: TextStyle(fontSize: 10, color: color, fontWeight: FontWeight.bold),
              ),
              Text(
                time,
                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTodayTasksList(
    BuildContext context,
    ScheduleState state,
    AppLocalizations l10n,
    ThemeData theme,
  ) {
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
  }
}
