import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project/view/screen/login.dart';
import 'package:project/view/screen/register.dart';
import 'bindings/intialbindings.dart';
import 'core/class/curd.dart';
import 'core/services/services.dart';


Future<void> main() async {

  Get.lazyPut(()=>Crud());
  WidgetsFlutterBinding.ensureInitialized();
  await initialServices();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: Loginpage(),
      initialBinding: initalBindings(),
    );
  }
}
