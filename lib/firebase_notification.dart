import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationHome {

  void requestNotificationPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    // طلب الإذن من المستخدم
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('تم منح الإذن للإشعارات');
    } else if (settings.authorizationStatus == AuthorizationStatus.denied) {
      print('الإذن مرفوض');
    } else {
      print('حالة الإذن غير معروفة');
    }
  }
}
