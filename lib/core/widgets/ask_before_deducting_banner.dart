import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../features/gamification/presentation/cubits/gamification_cubit.dart';
import '../../features/gamification/presentation/cubits/gamification_state.dart';
import '../../l10n/app_localizations.dart';
import '../constants/app_colors.dart';
import '../utils/haptic_utils.dart';

class AskBeforeDeductingBanner extends StatefulWidget {
  const AskBeforeDeductingBanner({super.key});

  @override
  State<AskBeforeDeductingBanner> createState() => _AskBeforeDeductingBannerState();
}

class _AskBeforeDeductingBannerState extends State<AskBeforeDeductingBanner> {
  bool _dismissed = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return BlocBuilder<GamificationCubit, GamificationState>(
      builder: (context, state) {
        if (_dismissed || state.currentPoints < 50) {
          return const SizedBox.shrink();
        }

        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFFFF3E0), Color(0xFFFFE0B2)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppColors.bronzeColor.withValues(alpha: 0.3),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      color: AppColors.bronzeColor,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.emoji_events,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      l10n.askBeforeDeducting(state.currentPoints),
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF5D4037),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, size: 18, color: Color(0xFF8D6E63)),
                    onPressed: () {
                      setState(() {
                        _dismissed = true;
                      });
                    },
                    tooltip: l10n.close,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'You have enough points to claim a Bronze reward (50 pts), or keep saving for Silver (100 pts) or Gold (200 pts)!',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: const Color(0xFF6D4C41),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.bronzeColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () async {
                        await HapticUtils.mediumImpact();
                        if (context.mounted) {
                          context.read<GamificationCubit>().redeemTier('bronze');
                        }
                      },
                      child: Text(
                        l10n.spendNow(50, l10n.bronze),
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFF5D4037),
                        side: const BorderSide(color: AppColors.bronzeColor),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          _dismissed = true;
                        });
                      },
                      child: Text(
                        l10n.keepSaving,
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                    ),
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
