import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../core/constant/color.dart';
import '../../../core/constant/routes.dart';
import '../../widget/home_page/list_title.dart';
import 'get_my_group.dart';

class Drawerpage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final box = GetStorage();
    print("Available keys in GetStorage: ${box.getKeys()}");

    return Container(
      width: 300,
      color: Colors.grey[200],
      child: Column(
        children: <Widget>[
          DrawerHeader(
            decoration: const BoxDecoration(
              color: sevenBackColor,
            ),
            child: SizedBox(
              width: 250,
              height: 75,
              child: Text(
                '11'.tr,
                style: const TextStyle(
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
              print("userId is ${box.getKeys()}");
              // if (userId != null) {
              //   // تمرير userId الديناميكي
              //   Get.to(GetMyGroups(userId: userId));
              // } else {
              //   // عرض رسالة خطأ إذا كان userId غير متوفر
              //   Get.snackbar("Error", "User ID not found. Please log in again.");
              // }
            },
            text: '50'.tr,
            icon: const Icon(Icons.group),
          ),
          ListTitleHomePage(
            onTap: () {
              Get.toNamed(AppRoute.getAllUser);
            },
            text: '13'.tr,
            icon: const Icon(Icons.settings),
          ),
          ListTitleHomePage(
            onTap: () {},
            text: '14'.tr,
            icon: const Icon(Icons.info_outline_rounded),
          ),
        ],
      ),
    );
  }
}
