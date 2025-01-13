import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:project/data/dataresource/home_page_data/add_groug_data.dart';
import 'package:project/route.dart';
import 'package:project/view/screen/Auth/login.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'bindings/intialbindings.dart';
import 'controller/home_page_controller/add_group_controller.dart';
import 'controller/home_page_controller/check_out_file_controller.dart';
import 'controller/home_page_controller/delete_group_controller.dart';
import 'controller/home_page_controller/update_file_controller.dart';
import 'core/class/crud.dart';
import 'core/local/local.dart';
import 'core/local/local_controller.dart';
import 'core/services/services.dart';
import 'core/theme/theme_peovider.dart';
import 'data/dataresource/home_page_data/add_file_to_group_data.dart';
import 'data/dataresource/home_page_data/check_out_file_data.dart';
import 'data/dataresource/home_page_data/delete_group_data.dart';
import 'data/dataresource/home_page_data/get_group_data.dart';
import 'data/dataresource/home_page_data/update_file_data.dart';
import 'firebase_notification.dart';
import 'firebase_options.dart';

Future<void> main() async {
  // // التأكد من تهيئة Flutter
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseMessaging.instance;
  NotificationHome notificationHome = new NotificationHome();

   notificationHome.requestNotificationPermission();



  // الحصول على التوكن وطباعة
  String? token = await FirebaseMessaging.instance.getToken();
  print("FCM Token: $token");

  setupDependencies();

  // تهيئة SharedPreferences
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  await Get.putAsync(() async => MyLocaleController(sharedPreferences));
  Get.put(sharedPreferences);

  // تهيئة GetStorage
  await GetStorage.init();

  // تشغيل التطبيق
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

// دالة لتسجيل الاعتماديات
void setupDependencies() {
  Get.lazyPut(() => Crud());
  Get.put(GetAllGroupData(Get.find()));
  Get.lazyPut(() => AddGroupControllerImp(AddGroupData(Get.find())));
  Get.put(AddFileToGroupData());
  Get.put(DeleteGroupControllerImp(DeleteGroupData(Get.find())));
  Get.lazyPut(() => CheckOutFileControllerImp(CheckOutFileData(Crud())));
  Get.lazyPut(() => UpdateFileControllerImp(UpdateFileData()));
  Get.lazyPut(()=>MyServices());
}

// تطبيق Flutter الرئيسي
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      locale: Get.find<MyLocaleController>().initLang,
      translations: MyLocal(),
      home: Loginpage(),
      initialBinding: initalBindings(),
      getPages: routes,
      theme: Provider.of<ThemeProvider>(context).currentTheme,
    );
  }
}
