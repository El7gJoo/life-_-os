import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;
import '../core/constants/app_constants.dart';

class ScheduledNotification {
  final int id;
  final String title;
  final String body;
  final DateTime scheduledTime;
  final String? payload;
  final int priority; // higher = schedule first when hitting 64 limit
  final bool hasDoneAction;
  final bool hasSnoozeAction;

  const ScheduledNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.scheduledTime,
    this.payload,
    this.priority = 0,
    this.hasDoneAction = false,
    this.hasSnoozeAction = false,
  });
}

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _plugin = FlutterLocalNotificationsPlugin();
  bool _initialized = false;

  final List<ScheduledNotification> _pendingNotifications = [];

  Future<void> initialize() async {
    if (kIsWeb || _initialized) return;

    tz_data.initializeTimeZones();

    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');

    final darwinActions = <DarwinNotificationAction>[
      DarwinNotificationAction.plain('done_action', 'Done'),
      DarwinNotificationAction.plain('snooze_action', 'Snooze 1 Hour'),
    ];

    final darwinCategories = <DarwinNotificationCategory>[
      DarwinNotificationCategory(
        'life_os_actions',
        actions: darwinActions,
      ),
    ];

    final darwinSettings = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
      notificationCategories: darwinCategories,
    );

    final initSettings = InitializationSettings(
      android: androidSettings,
      iOS: darwinSettings,
      macOS: darwinSettings,
    );

    await _plugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (response) {
        // Handle action responses
      },
    );

    _initialized = true;
  }

  Future<bool> requestPermissions() async {
    if (kIsWeb) return true;
    final iosPlatform = _plugin
        .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>();
    if (iosPlatform != null) {
      final granted = await iosPlatform.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
      return granted ?? false;
    }

    final androidPlatform = _plugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
    if (androidPlatform != null) {
      final granted = await androidPlatform.requestNotificationsPermission();
      return granted ?? false;
    }

    return true;
  }

  void addPendingNotification(ScheduledNotification item) {
    _pendingNotifications.removeWhere((p) => p.id == item.id);
    _pendingNotifications.add(item);
  }

  Future<void> rescheduleAll() async {
    if (kIsWeb || !_initialized) return;
    await _plugin.cancelAll();

    final now = DateTime.now();
    final windowEnd = now.add(const Duration(days: AppConstants.notificationWindowDays));

    final validNotifications = _pendingNotifications.where((n) {
      return n.scheduledTime.isAfter(now) && n.scheduledTime.isBefore(windowEnd);
    }).toList();

    // Prioritize: higher priority first
    validNotifications.sort((a, b) {
      if (b.priority != a.priority) {
        return b.priority.compareTo(a.priority);
      }
      return a.scheduledTime.compareTo(b.scheduledTime);
    });

    final limited = validNotifications.take(AppConstants.maxPendingNotifications);

    for (final notif in limited) {
      await _scheduleNative(notif);
    }
  }

  Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    DateTime? scheduledTime,
    DateTime? scheduledDate,
    String? payload,
    bool hasDoneAction = false,
    bool hasSnoozeAction = false,
    int priority = 1,
  }) async {
    final time = scheduledTime ?? scheduledDate ?? DateTime.now();
    final item = ScheduledNotification(
      id: id,
      title: title,
      body: body,
      scheduledTime: time,
      payload: payload,
      priority: priority,
      hasDoneAction: hasDoneAction,
      hasSnoozeAction: hasSnoozeAction,
    );
    addPendingNotification(item);

    if (!kIsWeb && _initialized && time.isAfter(DateTime.now())) {
      await _scheduleNative(item);
    }
  }

  Future<void> _scheduleNative(ScheduledNotification item) async {
    final tzDate = _cairoDT(item.scheduledTime);

    final notificationDetails = NotificationDetails(
      android: const AndroidNotificationDetails(
        'life_os_channel',
        'Life OS Notifications',
        channelDescription: 'Notifications for tasks, schedule, and occasions',
        importance: Importance.high,
        priority: Priority.high,
      ),
      iOS: DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
        categoryIdentifier: (item.hasDoneAction || item.hasSnoozeAction)
            ? 'life_os_actions'
            : null,
      ),
    );

    await _plugin.zonedSchedule(
      item.id,
      item.title,
      item.body,
      tzDate,
      notificationDetails,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      payload: item.payload,
    );
  }

  Future<void> scheduleOccasionAlerts({
    required String occasionId,
    required String occasionName,
    required DateTime occasionDate,
  }) async {
    // 2 days before at 9 AM (Priority 10 - top priority)
    final stage1 = DateTime(
      occasionDate.year,
      occasionDate.month,
      occasionDate.day - 2,
      9,
      0,
    );
    await scheduleNotification(
      id: _stableId(occasionId, 1),
      title: 'Upcoming Occasion: $occasionName',
      body: 'In 2 days! Prepare or buy a gift and make reservations.',
      scheduledTime: stage1,
      priority: 10,
    );

    // 1 day before at 9 AM (Priority 10)
    final stage2 = DateTime(
      occasionDate.year,
      occasionDate.month,
      occasionDate.day - 1,
      9,
      0,
    );
    await scheduleNotification(
      id: _stableId(occasionId, 2),
      title: 'Tomorrow: $occasionName',
      body: 'Finalize plans and gift preparations for tomorrow!',
      scheduledTime: stage2,
      priority: 10,
    );

    // On the day at 9 AM (Priority 10)
    final stage3 = DateTime(
      occasionDate.year,
      occasionDate.month,
      occasionDate.day,
      9,
      0,
    );
    await scheduleNotification(
      id: _stableId(occasionId, 3),
      title: 'Today: $occasionName!',
      body: 'Time to celebrate! Have a wonderful day together.',
      scheduledTime: stage3,
      priority: 10,
    );
  }

  Future<void> schedule3StageOccasion({
    required int baseId,
    required String name,
    required DateTime occasionDate,
  }) {
    return scheduleOccasionAlerts(
      occasionId: baseId.toString(),
      occasionName: name,
      occasionDate: occasionDate,
    );
  }

  Future<void> schedulePeriodicReminders() async {
    final now = DateTime.now();
    for (int i = 0; i < AppConstants.notificationWindowDays; i++) {
      final day = now.add(Duration(days: i));

      // Hydration check at 11:00 AM (Priority 2)
      final waterDate = DateTime(day.year, day.month, day.day, 11, 0);
      if (waterDate.isAfter(now)) {
        await scheduleNotification(
          id: 5000 + i,
          title: 'Hydration Check',
          body: "Don't forget to drink water!",
          scheduledTime: waterDate,
          priority: 2,
        );
      }

      // Expense logging reminder at 20:00 (Priority 2)
      final expenseDate = DateTime(day.year, day.month, day.day, 20, 0);
      if (expenseDate.isAfter(now)) {
        await scheduleNotification(
          id: 6000 + i,
          title: 'Daily Expense Check-in',
          body: 'Take 30 seconds to log today’s pocket expenses.',
          scheduledTime: expenseDate,
          priority: 2,
        );
      }
    }
  }

  Future<void> scheduleBedtimeReminder(DateTime bedtime) async {
    // 30 min before bedtime
    final reminderTime = bedtime.subtract(const Duration(minutes: 30));
    if (reminderTime.isAfter(DateTime.now())) {
      await scheduleNotification(
        id: 4000,
        title: 'Wind-Down for Bed',
        body: 'Target bedtime in 30 minutes. Time to disconnect and relax.',
        scheduledTime: reminderTime,
        priority: 5,
      );
    }
  }

  Future<void> cancelOccasionAlerts(String occasionId) async {
    for (int offset = 1; offset <= 3; offset++) {
      await cancelNotification(_stableId(occasionId, offset));
    }
  }

  Future<void> cancelNotification(int id) async {
    _pendingNotifications.removeWhere((p) => p.id == id);
    if (!kIsWeb && _initialized) {
      await _plugin.cancel(id);
    }
  }

  Future<void> cancelAll() async {
    _pendingNotifications.clear();
    if (!kIsWeb && _initialized) {
      await _plugin.cancelAll();
    }
  }

  int _stableId(String source, [int offset = 0]) {
    return (source.hashCode.abs() % 10000) + offset;
  }

  tz.TZDateTime _cairoDT(DateTime dt) {
    try {
      final cairo = tz.getLocation(AppConstants.cairoTimezone);
      return tz.TZDateTime.from(dt, cairo);
    } catch (_) {
      return tz.TZDateTime.from(dt, tz.local);
    }
  }
}
