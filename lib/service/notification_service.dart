import 'dart:async';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:tasks/model/task.dart';
import 'package:timezone/timezone.dart' as tz;

final StreamController<NotificationResponse> selectNotificationStream =
    StreamController<NotificationResponse>.broadcast();

@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse notificationResponse) {
  print("Tapped");
}

class NotificationService {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  DidReceiveBackgroundNotificationResponseCallback?
  onDidReceiveNotificationResponse() {}

  Future<void> initialise() async {
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings("app_icon");
    const IOSInitializationSettings iosSettings = IOSInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    final InitializationSettings settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await flutterLocalNotificationsPlugin.initialize(
      settings: settings,
      onDidReceiveNotificationResponse:
          (NotificationResponse notificationResponse) {
            selectNotificationStream.add(notificationResponse);
          },
      onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
    );
  }

  Future<void> scheduleNotification(Task task) async {
    await flutterLocalNotificationsPlugin.zonedSchedule(
      id: task.id!,
      title: task.title,
      body: task.description.substring(0, 50),
      scheduledDate: tz.TZDateTime(
        tz.local,
        task.dueDate.year,
      ).add(const Duration(seconds: 5)),
      notificationDetails: NotificationDetails(),
      androidScheduleMode: AndroidScheduleMode.exact,
    );
  }

  Future<void> showNotification(Task task) async {
    await flutterLocalNotificationsPlugin.show(
      id: task.id!,
      title: task.title,
      body: task.description.substring(0, 10),
      notificationDetails: NotificationDetails(),
    );
  }

  Future<void> cancelNotification(int id) async {
    await flutterLocalNotificationsPlugin.cancel(id: id);
  }

  Future<void> cancelAllNotifications() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }
}
