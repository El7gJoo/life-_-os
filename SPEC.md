Act as a Principal Flutter Engineer and Solution Architect. Build a complete, production-ready, clean-architected "Gamified Life OS" Flutter application, optimized for iOS (iPhone) and sideloaded (free Apple ID, 7-day certificate expiry).



==================================================

\## 1. ARCHITECTURE, TECH STACK \& CORE STANDARDS

==================================================

\- Architecture: Feature-First Clean Architecture: `core`, `features/gamification`, `features/schedule\_study`, `features/fiancee`, `features/finance`, `features/lifestyle`, `features/dashboard`, `features/settings\_backup`, `features/onboarding`, `features/stats`.

\- State management: `flutter\_bloc` (Cubits) with `Equatable` states.

\- Dependency injection: `get\_it`.

\- Persistence: `hive\_flutter` (or `sqflite`) behind Repository interfaces (domain layer) with Result/Either error handling. All data persists offline.

\- Localization: Arabic (RTL) and English (LTR) via `flutter\_localizations` + ARB files (no hard-coded strings). Instant language toggle in settings and app bar. Arabic font: Cairo (or Tajawal). Numbers must display correctly in both directions.

\- Theme: `ThemeMode.system / light / dark` selector persisted in settings, plus a quick toggle button in the app bar. Every category gradient must define BOTH light and dark variants with readable text contrast.

\- iOS native feel: `HapticFeedback` (lightImpact, mediumImpact, heavyImpact) on task completion, expense logging, reward unlocks.

\- Zero placeholders: complete, working code. No `// TODO`, no skipped implementations.

\- Provide exact pinned package versions, minimum iOS version, and the full iOS setup: `Podfile`, `AppDelegate.swift` (configured for flutter\_local\_notifications), and complete `Info.plist` keys (e.g. NSPhotoLibraryUsageDescription, NSFaceIDUsageDescription, notification-related keys).



==================================================

\## 2. CROSS-CUTTING REQUIREMENTS

==================================================

\- Points Ledger: instead of a single counter, record every point change (+/-) as a ledger entry with reason, source feature, and timestamp. `currentPoints` and `totalLifetimePoints` are derived from/validated against the ledger.

\- Undo: support undo for task completion, expense entry, and reward redemption, with automatic points adjustment via ledger reversal entries.

\- Day Boundary: configurable "new day starts at" hour (default 4 AM). Used for streaks, daily expense totals, daily resets, and the morning check-in. (Someone sleeping at 2 AM must not have their day end at midnight.)

\- Timezone: use `timezone` with `Africa/Cairo`; reschedule notifications on launch/resume to handle DST changes.

\- Backup JSON includes `schemaVersion` plus migration logic so old backups restore correctly into newer app versions.

\- Widget-ready architecture (no widget implementation yet): create a `WidgetDataProvider` exposing points balance, remaining tasks count, and next task, so `home\_widget` can be added later without refactoring.

\- Debug-mode Mock Data Seeder for testing.

\- Unit tests for: streak multiplier, sleep/wake calculator, +1h shift, notification scheduling window, ledger/undo.



==================================================

\## 3. FEATURE SPECIFICATIONS \& BUSINESS LOGIC

==================================================



\### A. Smart Gamification Engine

\- Central `GamificationCubit` tracking `currentPoints`, `totalLifetimePoints`, `currentStreakDays`.

\- Streak multiplier: completing core daily habits for 3 consecutive days activates a 1.5x or 2x multiplier starting on Day 4.

\- Streak Freeze: 1 free "rest day" per week that does not break the streak.

\- Ask-Before-Deducting: when `currentPoints >= 50`, NEVER deduct automatically. Show an interactive banner: "You have \[X] points! Do you want to spend 50 points now for a Bronze reward, or keep saving for a bigger reward (100 / 200+ pts)?"

\- Tiered random rewards: Bronze (50 pts, small daily treats), Silver (100 pts, medium), Gold (200 pts, major). Users can add/edit/delete custom rewards per tier. Seed sensible default rewards in each tier so the app is useful on first launch.

\- On redeem: deduct points (ledger entry), pick a reward with `dart:math` `Random()` from that tier, show a celebratory Confetti modal dialog, save to `ClaimedRewardsHistory` with timestamp.



\### B. Fiancée Hub \& Triple-Stage Countdown Notifications

\- Biometric lock (`local\_auth`, Face ID / Touch ID) protecting the whole Fiancée section and Gift Vault, with a setting to enable/disable it.

\- Daily Quality Time: scheduled block for a daily call/chat/date (+15 points on completion).

\- Important Dates: add special occasions (Birthday, Engagement Anniversary, Planned Date, custom). Live countdown (days/hours) per occasion. Occasions can repeat yearly and auto-reschedule after passing.

\- Mandatory 3-stage notifications for every occasion: (1) 2 days before: prepare/buy gift/make reservations; (2) 1 day before: finalize plans for tomorrow; (3) on the day at 9:00 AM: celebration reminder.

\- Gift \& Notes Vault: private quick-note list for things she likes, favorite items, gift ideas.



\### C. Daily Pocket Tracker \& Quick Expense Chips

\- Starting Pocket Balance input (e.g. 500 EGP).

\- One-tap category chips: Gas/Fuel ⛽, University Food 🍔, Coffee/Drinks ☕, Transport 🚗, Other 🛍️. Tap a chip, type the amount, save.

\- Real-time math: Starting Balance -> Total Spent -> Remaining in Pocket.

\- Timestamped log: Date, Time (HH:mm), Category, Note, Amount.

\- End-of-day rollover: if Remaining >= 0 at close, award +15 points and ask whether to roll the remainder into a "Savings Vault" or into tomorrow's starting balance.

\- Weekly/monthly budget with alerts when approaching the limit.

\- CSV export: button in the Finance section to export by month or custom date range. UTF-8 WITH BOM (so Arabic opens correctly in Excel). Columns: Date, Time, Category, Note, Amount, Currency. Add a summary section with totals per category. File name `expenses\_YYYY-MM.csv`, shared via `share\_plus` (AirDrop / Files / Mail).



\### D. University Timetable, Pomodoro, Sleep Calculator, Emergency Shift

\- Recurring weekly lectures and study blocks.

\- Pomodoro timer (25/45 min): tapping a study block opens it; completion auto-marks the task done and awards +20 points.

\- Auto Sleep/Wake calculator: inspect tomorrow's earliest lecture/task, subtract configurable prep/commute time (default 90 min) for Target Wake-Up Time, subtract 8 hours for Target Bedtime, wind-down notification 30 min before bedtime. On-time sleep/wake logging awards +10 points.

\- Daily Morning Check-in Modal on first open each morning (respecting the day boundary): "Good morning! Do you have any extra errands or tasks outside your regular schedule today?" Merge added items into today's timeline.

\- Emergency "+1 Hour Shift" button: pushes all remaining uncompleted study/routine tasks and their notifications forward by 1 hour.



\### E. Health, Nutrition \& Workout

\- Daily checklist: healthy meals (+5 pts each), water cups, workout/gym session (+20 pts).



\### F. Stats

\- Weekly/monthly stats screen using `fl\_chart`: spending by category, points over time, study and gym consistency.



\### G. Dynamic Category Backgrounds

\- `CategoryBackgroundWrapper` for each main tab: Academic Blue (University), Romantic Rose/Warm Gold (Fiancée), Emerald (Finance), Neon Energy (Gym), Midnight Indigo (Sleep). Each with light and dark variants. Support custom background images from the iPhone gallery (`image\_picker`).



\### H. Notification Engine (`flutter\_local\_notifications` + `timezone`)

\- Full iOS permission initialization.

\- Exact-time scheduling for lectures, fiancée calls, bedtime, and 3-stage occasion alerts.

\- Periodic reminders every few hours: log recent expenses, drink water, check remaining tasks.

\- iOS allows only 64 pending notifications: implement a Notification Scheduler that schedules ONLY a rolling 7-day window and fully reschedules on every app launch/resume (with prioritization so occasion alerts are never dropped).

\- Notification actions: "Done" and "Snooze 1 hour" where applicable.



\### I. Settings, Backup \& Onboarding

\- JSON Export/Import of ALL data (points ledger, schedules, logs, rewards, history, settings) via `share\_plus` / `file\_picker` / clipboard.

\- Weekly auto-backup reminder and a "Back up now" reminder before the sideload certificate expires (every 7 days).

\- Quick onboarding flow: language, theme, prep/commute time, currency, day-boundary hour, default rewards.



==================================================

\## 4. STEP-BY-STEP DELIVERY (write COMPLETE code for every file)

==================================================

1\. Step 1: `pubspec.yaml` (pinned versions), iOS `Podfile`, `AppDelegate.swift`, `Info.plist`, ARB localization files (AR/EN) and generation config, theme setup, and Dependency Injection setup.

2\. Step 2: Data models, Local Storage Service (JSON Backup/Restore with schemaVersion + migrations), Repository interfaces/implementations, Points Ledger, and `NotificationService` (3-stage countdown logic, rolling 7-day scheduler, periodic reminders, Africa/Cairo timezone).

3\. Step 3: All Cubits (`GamificationCubit`, `ScheduleCubit`, `FianceeCubit`, `FinanceCubit`, `LifestyleCubit`, `SettingsCubit`), `WidgetDataProvider`, CSV export service, and unit tests.

4\. Step 4: Core UI components (`CategoryBackgroundWrapper`, top Gamification progress bar, Reward Redemption dialog, Morning Check-in modal) and all feature screens (including Onboarding and Stats).



Work in phases as instructed by the user in chat. Write complete code for every file.

