import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/utils/haptic_utils.dart';
import '../../../../core/widgets/category_background_wrapper.dart';
import '../../../../l10n/app_localizations.dart';
import '../../data/models/reward_model.dart';
import '../cubits/gamification_cubit.dart';
import '../cubits/gamification_state.dart';
import '../widgets/reward_dialog.dart';

class GamificationScreen extends StatelessWidget {
  const GamificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return CategoryBackgroundWrapper(
      category: CategoryTheme.lifestyle,
      child: BlocConsumer<GamificationCubit, GamificationState>(
        listener: (context, state) {
          if (state.lastUnlockedReward != null) {
            final cubit = context.read<GamificationCubit>();
            RewardDialog.show(context, state.lastUnlockedReward!).then((_) {
              cubit.clearLastUnlockedReward();
            });
          }
        },
        builder: (context, state) {
          return Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              title: Text(l10n.gamification),
              backgroundColor: Colors.transparent,
              elevation: 0,
              actions: [
                IconButton(
                  icon: const Icon(Icons.settings_suggest_outlined),
                  tooltip: l10n.manageRewards,
                  onPressed: () => _showManageRewardsDialog(context, state),
                ),
              ],
            ),
            body: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Points overview card
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Text(
                          l10n.currentPoints,
                          style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${state.currentPoints}',
                          style: theme.textTheme.displaySmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Column(
                              children: [
                                Text(
                                  l10n.streak,
                                  style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey),
                                ),
                                Text(
                                  '${state.currentStreakDays} days',
                                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                Text(
                                  l10n.multiplier,
                                  style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey),
                                ),
                                Text(
                                  '${state.activeMultiplier}x',
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.neonEnergyLight,
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                Text(
                                  l10n.totalPoints,
                                  style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey),
                                ),
                                Text(
                                  '${state.totalLifetimePoints}',
                                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      l10n.redeemReward,
                      style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    TextButton.icon(
                      icon: const Icon(Icons.tune, size: 16),
                      label: Text(l10n.manageRewards),
                      onPressed: () => _showManageRewardsDialog(context, state),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // Bronze
                _buildTierCard(
                  context: context,
                  tier: 'bronze',
                  tierName: l10n.bronze,
                  cost: AppConstants.bronzePointsCost,
                  color: AppColors.bronzeColor,
                  icon: Icons.coffee,
                  currentPoints: state.currentPoints,
                ),
                const SizedBox(height: 12),

                // Silver
                _buildTierCard(
                  context: context,
                  tier: 'silver',
                  tierName: l10n.silver,
                  cost: AppConstants.silverPointsCost,
                  color: AppColors.silverColor,
                  icon: Icons.restaurant,
                  currentPoints: state.currentPoints,
                ),
                const SizedBox(height: 12),

                // Gold
                _buildTierCard(
                  context: context,
                  tier: 'gold',
                  tierName: l10n.gold,
                  cost: AppConstants.goldPointsCost,
                  color: AppColors.goldColor,
                  icon: Icons.card_giftcard,
                  currentPoints: state.currentPoints,
                ),

                const SizedBox(height: 24),
                Text(
                  l10n.rewardHistory,
                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),

                if (state.claimedRewards.isEmpty)
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Center(
                        child: Text(
                          l10n.noRewardsYet,
                          style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey),
                        ),
                      ),
                    ),
                  )
                else
                  ...state.claimedRewards.map(
                    (cr) => Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                          child: const Icon(Icons.check, color: AppColors.primary),
                        ),
                        title: Text(cr.rewardName),
                        subtitle: Text('${cr.tier.toUpperCase()} • ${cr.pointsSpent} pts'),
                        trailing: Text(
                          '${cr.claimedAt.month}/${cr.claimedAt.day}',
                          style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey),
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

  Widget _buildTierCard({
    required BuildContext context,
    required String tier,
    required String tierName,
    required int cost,
    required Color color,
    required IconData icon,
    required int currentPoints,
  }) {
    final l10n = AppLocalizations.of(context);
    final canRedeem = currentPoints >= cost;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    tierName,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Text(
                    '$cost ${l10n.points}',
                    style: TextStyle(color: Colors.grey[600], fontSize: 14),
                  ),
                ],
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: canRedeem ? color : Colors.grey[300],
                foregroundColor: canRedeem ? Colors.white : Colors.grey[600],
                elevation: canRedeem ? 2 : 0,
              ),
              onPressed: canRedeem
                  ? () async {
                      await HapticUtils.heavyImpact();
                      if (context.mounted) {
                        await context.read<GamificationCubit>().redeemTier(tier);
                      }
                    }
                  : null,
              child: Text(l10n.redeem),
            ),
          ],
        ),
      ),
    );
  }

  void _showManageRewardsDialog(BuildContext context, GamificationState state) {
    final l10n = AppLocalizations.of(context);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        minChildSize: 0.4,
        builder: (ctx, scrollController) {
          final theme = Theme.of(ctx);
          return Container(
            decoration: BoxDecoration(
              color: theme.scaffoldBackgroundColor,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: ListView(
              controller: scrollController,
              padding: const EdgeInsets.all(20),
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      l10n.manageRewards,
                      style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add_circle, color: AppColors.primary, size: 30),
                      onPressed: () => _showAddRewardDialog(context),
                      tooltip: l10n.addReward,
                    ),
                  ],
                ),
                const Divider(),
                ...state.rewards.map((reward) {
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    child: ListTile(
                      leading: Icon(
                        Icons.card_giftcard,
                        color: reward.tier == 'gold'
                            ? AppColors.goldColor
                            : reward.tier == 'silver'
                                ? AppColors.silverColor
                                : AppColors.bronzeColor,
                      ),
                      title: Text(reward.name),
                      subtitle: Text(reward.tier.toUpperCase()),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete_outline, color: Colors.grey),
                        onPressed: () {
                          context.read<GamificationCubit>().deleteReward(reward.id);
                        },
                      ),
                    ),
                  );
                }),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showAddRewardDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final nameController = TextEditingController();
    String selectedTier = 'bronze';

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setState) => AlertDialog(
          title: Text(l10n.addReward),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                autofocus: true,
                decoration: InputDecoration(
                  labelText: l10n.rewardName,
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                initialValue: selectedTier,
                decoration: InputDecoration(
                  labelText: l10n.rewardTier,
                  border: const OutlineInputBorder(),
                ),
                items: [
                  DropdownMenuItem(value: 'bronze', child: Text(l10n.bronze)),
                  DropdownMenuItem(value: 'silver', child: Text(l10n.silver)),
                  DropdownMenuItem(value: 'gold', child: Text(l10n.gold)),
                ],
                onChanged: (val) {
                  if (val != null) setState(() => selectedTier = val);
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: Text(l10n.cancel),
            ),
            ElevatedButton(
              onPressed: () {
                final name = nameController.text.trim();
                if (name.isNotEmpty) {
                  context.read<GamificationCubit>().addReward(
                        RewardModel(name: name, tier: selectedTier),
                      );
                  Navigator.of(ctx).pop();
                }
              },
              child: Text(l10n.add),
            ),
          ],
        ),
      ),
    );
  }
}
