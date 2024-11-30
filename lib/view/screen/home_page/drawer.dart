import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart'; // استيراد المكتبة
import '../../../core/constant/color.dart';
import '../../../core/constant/routes.dart';
import '../../../core/theme/theme_peovider.dart';
import '../../widget/home_page/list_title.dart';
import 'get_my_group.dart';
import 'package:project/core/theme/theme.dart'; // استيراد ThemeProvider

class Drawerpage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final box = GetStorage();
    print("Available keys in GetStorage: ${box.getKeys()}");

    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return Container(
          width: 300,
          color: Theme.of(context).colorScheme.tertiaryFixedDim,
          child: Column(
            children: <Widget>[
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                ),
                child: SizedBox(
                  width: 250,
                  height: 75,
                  child: Text(
                    '11'.tr,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.background,
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
                  final box = GetStorage();
                  final userId = box.read('id');  // تأكد من قراءة userId الصحيح
                  if (userId != null && userId is int && userId > 0) {
                    print("User ID is $userId");
                    Get.to(() => GetMyGroups(userId: userId));  // تمرير userId إلى الصفحة
                  } else {
                    Get.snackbar("Error", "User ID not found or invalid. Please log in again.");
                  }
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
                onTap: () {
                  themeProvider.toggleTheme();
                },
                text: themeProvider.currentTheme == lightMode
                    ? "51".tr
                    : "52".tr,
                icon: themeProvider.currentTheme == lightMode
                    ? const Icon(Icons.light_mode)
                    : const Icon(Icons.dark_mode),
              ),

            ],
          ),
        );
      },
    );
  }
}
