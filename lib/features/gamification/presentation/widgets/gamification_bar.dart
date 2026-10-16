import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../l10n/app_localizations.dart';
import '../cubits/gamification_cubit.dart';
import '../cubits/gamification_state.dart';

class GamificationBar extends StatelessWidget {
  const GamificationBar({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return BlocBuilder<GamificationCubit, GamificationState>(
      builder: (context, state) {
        final currentPoints = state.currentPoints;
        final streak = state.currentStreakDays;
        final multiplier = state.activeMultiplier;

        // Progress to next tier
        double progress = 0.0;
        String nextTier = l10n.bronze;
        int targetPoints = AppConstants.bronzePointsCost;

        if (currentPoints < AppConstants.bronzePointsCost) {
          progress = currentPoints / AppConstants.bronzePointsCost;
          nextTier = l10n.bronze;
          targetPoints = AppConstants.bronzePointsCost;
        } else if (currentPoints < AppConstants.silverPointsCost) {
          progress = (currentPoints - AppConstants.bronzePointsCost) /
              (AppConstants.silverPointsCost - AppConstants.bronzePointsCost);
          nextTier = l10n.silver;
          targetPoints = AppConstants.silverPointsCost;
        } else if (currentPoints < AppConstants.goldPointsCost) {
          progress = (currentPoints - AppConstants.silverPointsCost) /
              (AppConstants.goldPointsCost - AppConstants.silverPointsCost);
          nextTier = l10n.gold;
          targetPoints = AppConstants.goldPointsCost;
        } else {
          progress = 1.0;
          nextTier = l10n.gold;
          targetPoints = AppConstants.goldPointsCost;
        }

        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: theme.cardTheme.color ?? theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.stars_rounded, color: AppColors.goldColor, size: 24),
                      const SizedBox(width: 8),
                      Text(
                        '$currentPoints ${l10n.points}',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.neonEnergyLight.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.local_fire_department,
                            color: AppColors.neonEnergyLight, size: 18),
                        const SizedBox(width: 4),
                        Text(
                          '$streak ${l10n.streak}',
                          style: theme.textTheme.labelMedium?.copyWith(
                            color: AppColors.neonEnergyLight,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (multiplier > 1.0) ...[
                          const SizedBox(width: 4),
                          Text(
                            '(${multiplier}x)',
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: AppColors.neonEnergyLight,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: LinearProgressIndicator(
                  value: progress.clamp(0.0, 1.0),
                  minHeight: 6,
                  backgroundColor: theme.colorScheme.onSurface.withOpacity(0.1),
                  valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
                ),
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Next: $nextTier ($targetPoints pts)',
                    style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey),
                  ),
                  Text(
                    '${(progress * 100).toInt()}%',
                    style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
