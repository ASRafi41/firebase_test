import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tzdata;
import 'package:flutter_timezone/flutter_timezone.dart';

class NotificationService {
  final notificationPlugin = FlutterLocalNotificationsPlugin();
  bool _initialized = false;

  Future<void> initialize() async {
    if (_initialized) return;

    tzdata.initializeTimeZones();
    final timeZoneInfo = await FlutterTimezone.getLocalTimezone();
    final String timeZoneName = timeZoneInfo.identifier;
    final location = tz.getLocation(timeZoneName);
    tz.setLocalLocation(location);

    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const DarwinInitializationSettings iosSettings =
        DarwinInitializationSettings(
          requestAlertPermission: true,
          requestBadgePermission: true,
          requestSoundPermission: true,
        );
    const initSetting = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );
    await notificationPlugin.initialize(initSetting);
    _initialized = true;
  }

  NotificationDetails getNotificationDetails() {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        'channel_id',
        'channel_name',
        channelDescription: 'channel_description',
        importance: Importance.max,
        priority: Priority.high,
      ),
      iOS: DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      ),
    );
  }

  Future<void> showNotification(int id, String title, String body) async {
    await notificationPlugin.show(id, title, body, getNotificationDetails());
  }

  Future<void> scheduleNotification(
    int id,
    String title,
    String body,
    int hour,
    int minute,
  ) async {
    try {
      final now = tz.TZDateTime.now(tz.local);

      var scheduledDate = tz.TZDateTime(
        tz.local,
        now.year,
        now.month,
        now.day,
        hour,
        minute,
      );

      if (scheduledDate.isBefore(now)) {
        scheduledDate = scheduledDate.add(const Duration(days: 1));
      }

      final androidDetails = getNotificationDetails();
      try {
        await notificationPlugin.zonedSchedule(
          id,
          title,
          body,
          scheduledDate,
          androidDetails,
          androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
          // uiLocalNotificationDateInterpretation:
          //     UILocalNotificationDateInterpretation.absoluteTime,
          matchDateTimeComponents: DateTimeComponents.time,
        );
        print("Notification scheduled with exact alarm");
      } on PlatformException catch (e) {
        if (e.code == 'exact_alarms_not_permitted') {
          await notificationPlugin.zonedSchedule(
            id,
            title,
            body,
            scheduledDate,
            androidDetails,
            androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
            matchDateTimeComponents: DateTimeComponents.time,
          );
          print("Notification scheduled with inexact alarm");
        } else {
          rethrow;
        }
      }
    } catch (e) {
      print('Error scheduling notification: $e');
      rethrow;
    }
  }

  Future<void> cancelNotification(int id) async {
    await notificationPlugin.cancel(id);
  }
}
