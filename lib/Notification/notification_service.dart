import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
  FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    tz.initializeTimeZones();

    const AndroidInitializationSettings androidSettings =
    AndroidInitializationSettings('icon');

    const DarwinInitializationSettings iosSettings =
    DarwinInitializationSettings();

    const InitializationSettings settings =
    InitializationSettings(android: androidSettings, iOS: iosSettings);

    await _notificationsPlugin.initialize(settings);

    // Request permissions (Important for Android 13+ and iOS)
    await requestPermissions();
  }

  static Future<void> requestPermissions() async {
    final androidImplementation =
    _notificationsPlugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();

    if (androidImplementation != null) {
      await androidImplementation.requestNotificationsPermission();
    }

    final iosImplementation =
    _notificationsPlugin.resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>();

    if (iosImplementation != null) {
      await iosImplementation.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
    }
  }

  static Future<void> showNotification(String title, String body) async {
    const AndroidNotificationDetails androidDetails =
    AndroidNotificationDetails('channel_id', 'channel_name',
        importance: Importance.high, priority: Priority.high, icon: 'icon');

    const DarwinNotificationDetails iosDetails =
    DarwinNotificationDetails();

    const NotificationDetails details =
    NotificationDetails(android: androidDetails, iOS: iosDetails);

    await _notificationsPlugin.show(0, title, body, details);
  }

  static Future<void> scheduleDailyNotification(
      int hour, int minute, String title, String body) async {
    final tz.TZDateTime scheduledTime = _nextInstanceOfTime(hour, minute);

    print("Scheduling notification at: $scheduledTime");

    const AndroidNotificationDetails androidDetails =
    AndroidNotificationDetails('channel_id', 'channel_name',
        importance: Importance.high, priority: Priority.high, icon: 'icon');

    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails();

    const NotificationDetails details =
    NotificationDetails(android: androidDetails, iOS: iosDetails);

    try {
      await _notificationsPlugin.zonedSchedule(
        hour * 100 + minute, // Unique ID
        title,
        body,
        scheduledTime,
        details,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        matchDateTimeComponents: DateTimeComponents.time,
      );
      print("Notification scheduled successfully.");
    } catch (e) {
      print("Failed to schedule notification: $e");
    }
  }

  static tz.TZDateTime _nextInstanceOfTime(int hour, int minute) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledTime =
    tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);

    if (scheduledTime.isBefore(now)) {
      scheduledTime = scheduledTime.add(const Duration(days: 1));
    }

    return scheduledTime;
  }

  static Future<void> scheduleNotifications() async {
    List<int> notificationTimes = [1, 7, 10, 12, 16, 21];

    for (int hour in notificationTimes) {
     await scheduleDailyNotification(
          hour, 0, 'Let\'s get you hydrated', 'It\'s time to drink water!');
    }
  }
}