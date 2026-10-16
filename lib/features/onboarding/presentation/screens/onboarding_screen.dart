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
                            const Icon(Icons.rocket_launch, size: 80, color: AppColors.primary),
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
                            Text(l10n.onboardingLanguage, style: theme.textTheme.titleMedium),
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
                            const Icon(Icons.palette_outlined, size: 80, color: AppColors.primary),
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
                            Text(l10n.onboardingDayBoundary, style: theme.textTheme.titleMedium),
                            const SizedBox(height: 8),
                            Text(
                              l10n.dayBoundaryHint,
                              style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey),
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
                          2,
                          (index) => Container(
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            width: _currentPage == index ? 20 : 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: _currentPage == index
                                  ? AppColors.primary
                                  : Colors.grey[300],
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),
                      ),

                      if (_currentPage < 1)
                        ElevatedButton(
                          onPressed: () => _pageController.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          ),
                          child: Text(l10n.next),
                        )
                      else
                        ElevatedButton(
                          onPressed: () async {
                            await context.read<SettingsCubit>().setOnboardingComplete(true);
                            widget.onComplete();
                          },
                          child: Text(l10n.getStarted),
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
}
