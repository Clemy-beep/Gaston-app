import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationModelService {
  int id = 0;
  static final NotificationModelService _notificationService =
      NotificationModelService._internal();

  factory NotificationModelService() {
    return _notificationService;
  }
  Future<void> demoNotification(String title, String content) async {
    await _showNotification(title, content);
  }

  NotificationModelService._internal();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings(
            '@mipmap/ic_launcher'); // Use the name of your app icon without the path
    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
    );
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> _showNotification(String title, String content) async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails('your channel id', 'your channel name',
            channelDescription: 'your channel description',
            importance: Importance.max,
            priority: Priority.high,
            ticker: 'ticker');
    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);
    await flutterLocalNotificationsPlugin
        .show(id++, title, content, notificationDetails, payload: 'item x');
  }
}
