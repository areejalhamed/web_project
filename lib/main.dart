import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:project/data/dataresource/home_page_data/add_groug_data.dart';
import 'package:project/route.dart';
import 'package:project/view/screen/Auth/login.dart';
import 'bindings/intialbindings.dart';
import 'controller/home_page_controller/add_group_controller.dart';
import 'controller/home_page_controller/get_group_controller.dart';
import 'core/class/crud.dart';
import 'core/services/services.dart';
import 'data/dataresource/home_page_data/add_file_to_group_data.dart';
import 'data/dataresource/home_page_data/get_group_data.dart';

Future<void> main() async {
  Get.lazyPut(() => Crud());
  Get.put(GetAllGroupData(Get.find()));
  Get.lazyPut(() => AddGroupControllerImp(AddGroupData(Get.find())));
  // Get.put(AddFileToGroupData(Get.find()));
  WidgetsFlutterBinding.ensureInitialized();
  await initialServices();
  await GetStorage.init();
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
