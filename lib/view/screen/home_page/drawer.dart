import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../../../core/constant/color.dart';
import '../../../core/constant/routes.dart';
import '../../../core/local/local_controller.dart';
import '../../widget/home_page/list_title.dart';

class Drawerpage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
   return Container(
     width: 300,
     color: Colors.grey[200],
     child: Column(
       children: <Widget>[
         DrawerHeader(
           decoration:const BoxDecoration(
             color: sevenBackColor,
           ),
           child: SizedBox(
             width: 250,
             height: 75,
             child: Text(
               '11'.tr,
               style:const TextStyle(
                 color: Colors.white,
                 fontSize: 24,
               ),
             ),
           ),
         ),
         ListTitleHomePage(
           onTap: () {
             Get.toNamed(AppRoute.showConfirmationDialog);
           },
           text: '12'.tr,
           icon: const Icon(Icons.create_outlined),

         ),
         ListTitleHomePage(
           onTap: () {
             Get.toNamed(AppRoute.getAllUser);},
           text: '13'.tr,
           icon: const Icon(Icons.settings),
         ),
         ListTitleHomePage(
           onTap: () {},
           text: '14'.tr,
           icon: const Icon(Icons.info_outline_rounded),
         ),
         ListTitleHomePage(
           onTap: () {
             String currentLang = MyLocaleController.sharedPreferences?.getString("lang") ?? 'en';
             String newLang = currentLang == 'en' ? 'ar' : 'en';
             MyLocaleController.changeLanguage(newLang);
             print("Language changed to: $newLang");
           },
           text: '34'.tr,
           icon: const Icon(Icons.language),
         ),
       ],
     ),
   );
  }

}