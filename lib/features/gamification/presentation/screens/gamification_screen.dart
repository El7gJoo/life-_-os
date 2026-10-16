import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/utils/haptic_utils.dart';
import '../../../../l10n/app_localizations.dart';
import '../cubits/gamification_cubit.dart';
import '../cubits/gamification_state.dart';
import '../widgets/reward_dialog.dart';

class GamificationScreen extends StatelessWidget {
  const GamificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return BlocConsumer<GamificationCubit, GamificationState>(
      listener: (context, state) {
        if (state.lastUnlockedReward != null) {
          RewardDialog.show(context, state.lastUnlockedReward!).then((_) {
            context.read<GamificationCubit>().clearLastUnlockedReward();
          });
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text(l10n.gamification),
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
              Text(
                l10n.redeemReward,
                style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),

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
                        backgroundColor: AppColors.primary.withOpacity(0.1),
                        child: const Icon(Icons.check, color: AppColors.primary),
                      ),
                      title: Text(cr.title),
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
                color: color.withOpacity(0.15),
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
}
