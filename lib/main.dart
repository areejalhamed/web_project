import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project/core/class/crud.dart';
import 'package:project/route.dart';
import 'package:project/view/screen/home_page/home_page.dart';
import 'package:project/view/screen/Auth/login.dart';
import 'package:project/view/screen/Auth/register.dart';
import 'bindings/intialbindings.dart';
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
      getPages: routes ,
    );
  }
}
