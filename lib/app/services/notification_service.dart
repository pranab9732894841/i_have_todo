import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:i_have_todo/app/utils/id_utils.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  final InitializationSettings initializationSettings = InitializationSettings(
    android: AndroidInitializationSettings('@mipmap/ic_launcher'),
  );

  final AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails(
    'your channel id',
    'your channel name',
    importance: Importance.max,
    priority: Priority.high,
    ticker: 'ticker',
  );

  void init() async {
    // request permission
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestExactAlarmsPermission();
    _configureLocalTimeZone();
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  void showNotification(String title, String body) async {
    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      NotificationDetails(android: androidPlatformChannelSpecifics),
    );
  }

  void cancelNotification() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }

  Future<void> _configureLocalTimeZone() async {
    tz.initializeTimeZones();
    final String timeZone = await FlutterNativeTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timeZone));
  }

  /// Set right date and time for notifications
  tz.TZDateTime _convertTime(DateTime date) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduleDate = tz.TZDateTime(
        tz.local, date.year, date.month, date.day, date.hour, date.minute);
    if (scheduleDate.isBefore(now)) {
      scheduleDate = scheduleDate.add(const Duration(minutes: 1));
    }
    return scheduleDate;
  }

  void scheduleNotification(
      int id, String title, String body, DateTime scheduledDate) {
    flutterLocalNotificationsPlugin.zonedSchedule(
      generateIdFromEpoch(id),
      title,
      body,
      _convertTime(scheduledDate),
      NotificationDetails(android: androidPlatformChannelSpecifics),
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }
}
