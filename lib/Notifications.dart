import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

Future<void> initNotifications() async {
  tz.initializeTimeZones();

  const AndroidInitializationSettings androidSettings =
  AndroidInitializationSettings('@mipmap/ic_launcher');

  const DarwinInitializationSettings iosSettings =
  DarwinInitializationSettings(
    requestAlertPermission: true,
    requestBadgePermission: true,
    requestSoundPermission: true,
  );

  const InitializationSettings initSettings = InitializationSettings(
    android: androidSettings,
    iOS: iosSettings,
  );

  await flutterLocalNotificationsPlugin.initialize(settings: initSettings);

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
      AndroidFlutterLocalNotificationsPlugin>()
      ?.requestNotificationsPermission();
}

// Calculate the next renewal date from a start date + interval string
DateTime getNextRenewalDate(DateTime startDate, String interval) {
  final now = DateTime.now();
  DateTime next = startDate;

  while (!next.isAfter(now)) {
    switch (interval) {
      case '1 Week':
        next = next.add(Duration(days: 7));
        break;
      case '2 Weeks':
        next = next.add(Duration(days: 14));
        break;
      case '1 Month':
        next = DateTime(next.year, next.month + 1, next.day);
        break;
      case '6 Months':
        next = DateTime(next.year, next.month + 6, next.day);
        break;
      case '1 Year':
        next = DateTime(next.year + 1, next.month, next.day);
        break;
      default:
        next = next.add(Duration(days: 30));
    }
  }

  return next;
}

// Schedule a notification 2 days before the next renewal
Future<void> scheduleRenewalNotification({
  required String docId,
  required String subscriptionName,
  required DateTime startDate,
  required String interval,
}) async {
  final nextRenewal = getNextRenewalDate(startDate, interval);
  final notifyAt = nextRenewal.subtract(Duration(days: 2));

  if (notifyAt.isBefore(DateTime.now())) return;

  final int notifId = docId.hashCode;

  await flutterLocalNotificationsPlugin.zonedSchedule(
    id: notifId,
    title: 'Upcoming Renewal',
    body: '$subscriptionName renews in 2 days.',
    scheduledDate: tz.TZDateTime.from(notifyAt, tz.local),
    notificationDetails: const NotificationDetails(
      android: AndroidNotificationDetails(
        'renewal_channel',
        'Subscription Renewals',
        channelDescription: 'Reminders before subscriptions renew',
        importance: Importance.high,
        priority: Priority.high,
      ),
      iOS: DarwinNotificationDetails(),
    ),
    androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    payload: docId,
  );
}

// Cancel a notification by doc ID
Future<void> cancelNotification(String docId) async {
  await flutterLocalNotificationsPlugin.cancel(id: docId.hashCode);
}