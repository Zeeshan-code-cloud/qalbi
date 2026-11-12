import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
 import 'package:timezone/data/latest.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

class AdhanNotificationService {
  final FlutterLocalNotificationsPlugin plugin =
      FlutterLocalNotificationsPlugin();

  static const int _idBase = 700000;

  Future<void> initialize() async {
    tz_data.initializeTimeZones();

    final timezoneInfo = await FlutterTimezone.getLocalTimezone();

    tz.setLocalLocation(tz.getLocation(timezoneInfo.identifier));

    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );

    const iosSettings = DarwinInitializationSettings();

    const settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await plugin.initialize(settings: settings);
  }

  Future<bool> requestPermissions() async {
    final android = plugin.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();

    final ios = plugin
        .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin
        >();

    final androidGranted =
        await android?.requestNotificationsPermission() ?? true;

    final iosGranted =
        await ios?.requestPermissions(alert: true, badge: true, sound: true) ??
        true;

    return androidGranted && iosGranted;
  }

  Future<void> requestExactAlarmPermission() async {
    final android = plugin.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();

    await android?.requestExactAlarmsPermission();
  }

  Future<void> schedulePrayerNotifications({
    required Map<DateTime, Map<String, String>> schedules,
    required Map<String, bool> enabledPrayers,
  }) async {
    // Remove previous prayer schedules only.
    final pending = await plugin.pendingNotificationRequests();

    for (final notification in pending) {
      if (notification.id >= _idBase && notification.id < _idBase + 200000) {
        await plugin.cancel(id: notification.id);
      }
    }

    final now = tz.TZDateTime.now(tz.local);

    for (final entry in schedules.entries) {
      final date = entry.key;
      final prayerTimes = entry.value;

      int prayerIndex = 0;

      for (final prayer in prayerTimes.entries) {
        final prayerName = prayer.key;
        final prayerTime = prayer.value;

        final isEnabled = enabledPrayers[prayerName] ?? true;

        if (!isEnabled) {
          prayerIndex++;
          continue;
        }

        final parts = prayerTime.split(':');

        final hour = int.parse(parts[0]);
        final minute = int.parse(parts[1]);

        final scheduledDate = tz.TZDateTime(
          tz.local,
          date.year,
          date.month,
          date.day,
          hour,
          minute,
        );

        if (scheduledDate.isAfter(now)) {
          final dayNumber = DateTime.utc(
            date.year,
            date.month,
            date.day,
          ).difference(DateTime.utc(2020)).inDays;

          final notificationId = _idBase + dayNumber * 10 + prayerIndex;

          await plugin.zonedSchedule(
            id: notificationId,
            scheduledDate: scheduledDate,
            notificationDetails: NotificationDetails(
              android: AndroidNotificationDetails(
                'adhan_channel',
                'Adhan Notifications',
                channelDescription:
                    'Its time for prayer',
                importance: Importance.max,
                priority: Priority.high,
                playSound: true,
                sound: RawResourceAndroidNotificationSound("adhan"),
              ),
              iOS: DarwinNotificationDetails(
                presentAlert: true,
                presentBadge: true,
                presentSound: true,
              ),
            ),

            androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
            payload: prayerName,
          );
        }

        prayerIndex++;
      }
    }
  }

  Future<void> cancelAllPrayerNotifications() async {
    final pending = await plugin.pendingNotificationRequests();

    for (final notification in pending) {
      if (notification.id >= _idBase && notification.id < _idBase + 200000) {
        await plugin.cancel(id: notification.id);
      }
    }
  }
}
