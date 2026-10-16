import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/theme/theme_cubit.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../settings_backup/presentation/cubits/settings_cubit.dart';
import '../../../settings_backup/presentation/cubits/settings_state.dart';

class OnboardingScreen extends StatefulWidget {
  final VoidCallback onComplete;

  const OnboardingScreen({super.key, required this.onComplete});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  final int _totalPages = 4;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<SettingsCubit, SettingsState>(
          builder: (context, state) {
            return Column(
              children: [
                Expanded(
                  child: PageView(
                    controller: _pageController,
                    onPageChanged: (idx) => setState(() => _currentPage = idx),
                    children: [
                      // Page 1: Welcome & Language
                      Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(24),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withValues(alpha: 0.12),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.rocket_launch, size: 72, color: AppColors.primary),
                            ),
                            const SizedBox(height: 24),
                            Text(
                              l10n.onboardingWelcome,
                              style: theme.textTheme.headlineMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              l10n.onboardingSubtitle,
                              style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 36),
                            Text(
                              l10n.onboardingLanguage,
                              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 16),
                            SegmentedButton<String>(
                              segments: [
                                ButtonSegment(value: 'en', label: Text(l10n.english)),
                                ButtonSegment(value: 'ar', label: Text(l10n.arabic)),
                              ],
                              selected: {state.languageCode},
                              onSelectionChanged: (selected) {
                                context.read<SettingsCubit>().setLanguageCode(selected.first);
                              },
                            ),
                          ],
                        ),
                      ),

                      // Page 2: Theme & Day Boundary
                      Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(24),
                              decoration: BoxDecoration(
                                color: AppColors.neonEnergyLight.withValues(alpha: 0.12),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.palette_outlined, size: 72, color: AppColors.neonEnergyLight),
                            ),
                            const SizedBox(height: 24),
                            Text(
                              l10n.onboardingTheme,
                              style: theme.textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 24),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ElevatedButton.icon(
                                  icon: const Icon(Icons.light_mode),
                                  label: Text(l10n.themeLight),
                                  onPressed: () =>
                                      context.read<ThemeCubit>().setTheme(ThemeMode.light),
                                ),
                                const SizedBox(width: 16),
                                ElevatedButton.icon(
                                  icon: const Icon(Icons.dark_mode),
                                  label: Text(l10n.themeDark),
                                  onPressed: () =>
                                      context.read<ThemeCubit>().setTheme(ThemeMode.dark),
                                ),
                              ],
                            ),
                            const SizedBox(height: 36),
                            Text(
                              l10n.onboardingDayBoundary,
                              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '${l10n.dayBoundaryHint} (Configured to ${state.dayBoundaryHour}:00 AM)',
                              style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),

                      // Page 3: Prep Time & Currency
                      Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(24),
                              decoration: BoxDecoration(
                                color: AppColors.emeraldGreenLight.withValues(alpha: 0.12),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.tune, size: 72, color: AppColors.emeraldGreenLight),
                            ),
                            const SizedBox(height: 24),
                            Text(
                              'Routine & Currency',
                              style: theme.textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 24),
                            ListTile(
                              leading: const Icon(Icons.timer_outlined, color: AppColors.primary),
                              title: Text(l10n.prepTime),
                              subtitle: Text(l10n.prepTimeMinutes(state.prepTimeMinutes)),
                              trailing: DropdownButton<int>(
                                value: state.prepTimeMinutes,
                                items: const [
                                  DropdownMenuItem(value: 30, child: Text('30m')),
                                  DropdownMenuItem(value: 45, child: Text('45m')),
                                  DropdownMenuItem(value: 60, child: Text('60m')),
                                  DropdownMenuItem(value: 90, child: Text('90m')),
                                ],
                                onChanged: (val) {
                                  if (val != null) {
                                    context.read<SettingsCubit>().setPrepTimeMinutes(val);
                                  }
                                },
                              ),
                            ),
                            const Divider(),
                            ListTile(
                              leading: const Icon(Icons.monetization_on, color: AppColors.emeraldGreenLight),
                              title: Text(l10n.currency),
                              subtitle: Text(state.currency),
                              trailing: DropdownButton<String>(
                                value: state.currency,
                                items: const [
                                  DropdownMenuItem(value: 'EGP', child: Text('EGP (ج.م)')),
                                  DropdownMenuItem(value: 'USD', child: Text('USD (\$)')),
                                  DropdownMenuItem(value: 'EUR', child: Text('EUR (€)')),
                                  DropdownMenuItem(value: 'SAR', child: Text('SAR (ر.س)')),
                                  DropdownMenuItem(value: 'AED', child: Text('AED (د.إ)')),
                                ],
                                onChanged: (val) {
                                  if (val != null) {
                                    context.read<SettingsCubit>().setCurrency(val);
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Page 4: Gamification & Rules Preview
                      Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(24),
                              decoration: BoxDecoration(
                                color: AppColors.goldColor.withValues(alpha: 0.15),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.emoji_events, size: 72, color: AppColors.goldColor),
                            ),
                            const SizedBox(height: 20),
                            Text(
                              'Gamify Your Life',
                              style: theme.textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 16),
                            _buildFeatureBullet(
                              icon: Icons.local_fire_department,
                              color: Colors.orange,
                              title: 'Streak Multipliers',
                              desc: 'Earn up to 2.0x points as your consecutive daily streak grows!',
                            ),
                            const SizedBox(height: 10),
                            _buildFeatureBullet(
                              icon: Icons.ac_unit,
                              color: Colors.cyan,
                              title: 'Streak Freeze Protection',
                              desc: 'One automated streak freeze keeps your momentum safe.',
                            ),
                            const SizedBox(height: 10),
                            _buildFeatureBullet(
                              icon: Icons.card_giftcard,
                              color: AppColors.romanticRoseLight,
                              title: 'Tiered Random Rewards',
                              desc: 'Unlock Bronze, Silver, Gold, and Platinum real-life rewards!',
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Bottom navigation controls
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (_currentPage > 0)
                        TextButton(
                          onPressed: () => _pageController.previousPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          ),
                          child: Text(l10n.back),
                        )
                      else
                        const SizedBox(width: 60),

                      // Indicators
                      Row(
                        children: List.generate(
                          _totalPages,
                          (index) => Container(
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            width: _currentPage == index ? 22 : 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: _currentPage == index
                                  ? AppColors.primary
                                  : Colors.grey.withValues(alpha: 0.3),
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),
                      ),

                      if (_currentPage < _totalPages - 1)
                        ElevatedButton(
                          onPressed: () => _pageController.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          ),
                          child: Text(l10n.next),
                        )
                      else
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          ),
                          onPressed: () async {
                            await context.read<SettingsCubit>().setOnboardingComplete(true);
                            widget.onComplete();
                          },
                          child: Text(
                            l10n.getStarted,
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildFeatureBullet({
    required IconData icon,
    required Color color,
    required String title,
    required String desc,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.15),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              const SizedBox(height: 2),
              Text(desc, style: const TextStyle(color: Colors.grey, fontSize: 12)),
            ],
          ),
        ),
      ],
    );
  }
}
