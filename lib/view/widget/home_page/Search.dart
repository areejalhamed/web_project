import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../../../controller/home_page_controller/search_user_name_controller.dart';
import '../../../core/class/staterequest.dart';
import '../../../core/constant/color.dart';

class SearchPage extends StatelessWidget {
  final SearchUserNameControllerImp controller = Get.find();
  final int groupId;

  SearchPage({super.key, required this.groupId});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min, // تحديد الحجم الأدنى لتجنب القيود غير المحددة
      children: [
        TextField(
          controller: controller.name,
          onChanged: (query) {
            controller.searchUserName(groupId);
          },
          decoration: const InputDecoration(
            labelText: 'بحث...',
            prefixIcon: Icon(Icons.search),
          ),
        ),
        const SizedBox(height: 20),
        Obx(() {
          if (controller.statusRequest == StatusRequest.loading) {
            return const CircularProgressIndicator();
          } else if (controller.noUsersFound.value) {
            return const Text("لا يوجد مستخدمين.");
          } else if (controller.users.isEmpty) {
            return const Text("لا توجد بيانات.");
          } else {
            return Flexible(
              fit: FlexFit.loose, // السماح بالتمدد فقط بقدر ما هو متاح
              child: ListView.builder(
                shrinkWrap: true, // تجنب القيود غير المحددة
                itemCount: controller.users.length,
                itemBuilder: (context, index) {
                  final user = controller.users[index];
                  return MouseRegion(
                    onEnter: (_) {
                      // عند دخول الماوس على العنصر
                    },
                    onExit: (_) {
                      // عند مغادرة الماوس العنصر
                    },
                    child: Card(
                      color: green,
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      elevation: 4,
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: grey,
                          child: Text(
                            user['name'][0].toUpperCase(),
                            style: const TextStyle(color: Colors.black),
                          ),
                        ),
                        title: Text(user['name'] ?? 'مستخدم غير معروف'),
                        subtitle: Text(user['email'] ?? 'لا يوجد بريد إلكتروني'),
                      ),
                    ),
                  );
                },
              ),
            );
          }
        }),
      ],
    );
  }
}
