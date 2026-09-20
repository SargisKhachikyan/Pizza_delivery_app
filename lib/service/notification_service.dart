import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  NotificationService._();

  static final instance = NotificationService._();

  final _plugin = FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    const settings = InitializationSettings(
      iOS: DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: false,
        requestSoundPermission: true,
      ),
    );

    await _plugin.initialize(settings: settings);
  }

  Future<void> showOrderDelivered(int orderId) async {
    const details = NotificationDetails(
      iOS: DarwinNotificationDetails(
        presentBanner: true,
        presentList: true,
        presentSound: true,
      ),
    );

    await _plugin.show(
      id: orderId,
      title: 'Order delivered',
      body: 'Your pizza is at your door. Enjoy!',
      notificationDetails: details,
    );
  }
}
