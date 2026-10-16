import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import '../core/constants/app_constants.dart';

class NotificationService {
  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  bool _initialized = false;

  Future<void> initialize() async {
    if (kIsWeb) return;
    if (_initialized) return;

    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const darwinSettings = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: darwinSettings,
      macOS: darwinSettings,
    );

    await _notificationsPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (response) {
        // Handle notification actions like Snooze or Done
      },
    );

    _initialized = true;
  }

  Future<bool> requestPermissions() async {
    if (kIsWeb) return true;
    final iosPlatform = _notificationsPlugin
        .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>();
    if (iosPlatform != null) {
      final granted = await iosPlatform.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
      return granted ?? false;
    }

    final androidPlatform = _notificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
    if (androidPlatform != null) {
      final granted = await androidPlatform.requestNotificationsPermission();
      return granted ?? false;
    }

    return true;
  }

  Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
    String? payload,
  }) async {
    if (kIsWeb) return;

    // Guard against scheduling in the past
    if (scheduledDate.isBefore(DateTime.now())) return;

    final location = tz.getLocation(AppConstants.cairoTimezone);
    final tzDate = tz.TZDateTime.from(scheduledDate, location);

    const notificationDetails = NotificationDetails(
      android: AndroidNotificationDetails(
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
      ),
    );

    await _notificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      tzDate,
      notificationDetails,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      payload: payload,
    );
  }

  Future<void> cancelNotification(int id) async {
    if (kIsWeb) return;
    await _notificationsPlugin.cancel(id);
  }

  Future<void> cancelAll() async {
    if (kIsWeb) return;
    await _notificationsPlugin.cancelAll();
  }

  Future<void> schedule3StageOccasion({
    required int baseId,
    required String name,
    required DateTime occasionDate,
  }) async {
    if (kIsWeb) return;

    // Stage 1: 2 days before at 10:00 AM
    final stage1 = DateTime(
      occasionDate.year,
      occasionDate.month,
      occasionDate.day - 2,
      10,
      0,
    );
    await scheduleNotification(
      id: baseId * 10 + 1,
      title: 'Upcoming Occasion: $name in 2 Days',
      body: 'Prepare or buy gift, and make reservations!',
      scheduledDate: stage1,
    );

    // Stage 2: 1 day before at 18:00
    final stage2 = DateTime(
      occasionDate.year,
      occasionDate.month,
      occasionDate.day - 1,
      18,
      0,
    );
    await scheduleNotification(
      id: baseId * 10 + 2,
      title: 'Tomorrow: $name',
      body: 'Finalize plans and gift preparations for tomorrow!',
      scheduledDate: stage2,
    );

    // Stage 3: On the day at 9:00 AM
    final stage3 = DateTime(
      occasionDate.year,
      occasionDate.month,
      occasionDate.day,
      9,
      0,
    );
    await scheduleNotification(
      id: baseId * 10 + 3,
      title: 'Today: $name!',
      body: 'Time to celebrate! Have a wonderful day together.',
      scheduledDate: stage3,
    );
  }

  Future<void> schedulePeriodicReminders() async {
    // Schedule periodic reminders within rolling 7-day window
    final now = DateTime.now();
    for (int i = 0; i < 7; i++) {
      final day = now.add(Duration(days: i));
      // Water reminder at 11:00 AM
      final waterDate = DateTime(day.year, day.month, day.day, 11, 0);
      if (waterDate.isAfter(now)) {
        await scheduleNotification(
          id: 5000 + i,
          title: 'Hydration Check',
          body: "Don't forget to drink water!",
          scheduledDate: waterDate,
        );
      }

      // Expense logging reminder at 20:00
      final expenseDate = DateTime(day.year, day.month, day.day, 20, 0);
      if (expenseDate.isAfter(now)) {
        await scheduleNotification(
          id: 6000 + i,
          title: 'Expense Check-in',
          body: 'Take 30 seconds to log today’s pocket expenses.',
          scheduledDate: expenseDate,
        );
      }
    }
  }
}
