// import 'package:flutter/material.dart';
//
// void main() {
//   runApp(const MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Web Push Notifications',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: const HomePage(),
//     );
//   }
// }
//
// class HomePage extends StatelessWidget {
//   const HomePage({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Web Push Notifications'),
//       ),
//       body: Center(
//         child: ElevatedButton(
//           onPressed: () async {
//             String token = 'example_token_123456'; // مثال للتوكن
//             print('تم تخزين التوكن: $token');
//
//             // اشترك في الإشعارات
//             await subscribeToPushNotifications(token);
//           },
//           child: const Text('اشترك في الإشعارات'),
//         ),
//       ),
//     );
//   }
//
//   // دالة للاشتراك في الإشعارات
//   Future<void> subscribeToPushNotifications(String token) async {
//     try {
//       // تحقق من دعم المتصفح لإشعارات الدفع
//       if (Notification.permission != 'granted') {
//         final permissionStatus = await Notification.requestPermission();
//
//         if (permissionStatus == 'granted') {
//           print('تم منح إذن الإشعارات.');
//
//           // طباعة بيانات التوكن للاختبار
//           print('التوكن: $token');
//
//           // عرض إشعار
//           showNotification('تم اشتراكك في الإشعارات', 'تم الاشتراك بنجاح في إشعارات الويب!');
//         } else {
//           print('تم رفض الإذن للإشعارات.');
//         }
//       } else {
//         print('الإذن للإشعارات مُمنوح مسبقًا.');
//       }
//     } catch (e) {
//       print('خطأ أثناء الاشتراك في الإشعارات: $e');
//     }
//   }
//
//   // دالة لإظهار الإشعار
//   void showNotification(String title, String body) {
//     if (Notification.permission == 'granted') {
//       final notification = Notification(title, body);
//       notification.show();
//     }
//   }
// }
