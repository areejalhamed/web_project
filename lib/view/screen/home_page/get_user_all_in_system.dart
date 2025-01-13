import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controller/home_page_controller/search_user_name_controller.dart';
import '../../../core/class/staterequest.dart';
import '../../../core/constant/color.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controller/home_page_controller/add_user_to_group_controller.dart';
import '../../../controller/home_page_controller/get_all_user_in_system_controller.dart';
import '../../../controller/home_page_controller/search_user_name_controller.dart';
import '../../../core/class/crud.dart';
import '../../../core/class/staterequest.dart';
import '../../../core/constant/color.dart';
import '../../../data/dataresource/home_page_data/add_user_to_gruop_data.dart';
import '../../../data/dataresource/home_page_data/get_all_user_in_system_data.dart';
import '../../../data/dataresource/home_page_data/search_user_name_data.dart';
import '../../widget/home_page/Search.dart';

class GetAllUserInSystem extends StatelessWidget {
  final int groupId;

  const GetAllUserInSystem({super.key, required this.groupId});

  @override
  Widget build(BuildContext context) {
    final GetAllUserInSystemControllerImp userController = Get.put(
        GetAllUserInSystemControllerImp(GetAllUserInSystemData(Crud())));
    final AddUserToGroupControllerImp addUserToGroupControllerImp = Get.put(
        AddUserToGroupControllerImp(AddUserToGroupData(Crud()), groupId));

    final selectedUsers = <int>[].obs;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: sevenBackColor,
        title: const Text("المستخدمين"),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: () {
              userController.getUser();
              selectedUsers.clear();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SearchPage(groupId: groupId),
          ),
          Expanded(
            child: Obx(() {
              if (userController.statusRequest.value == StatusRequest.loading) {
                return const Center(child: CircularProgressIndicator());
              } else if (userController.statusRequest.value == StatusRequest.failure) {
                return const Center(child: Text("فشل تحميل المستخدمين."));
              } else if (userController.users.isEmpty) {
                return const Center(child: Text("لا يوجد مستخدمين."));
              } else {
                return ListView.builder(
                  itemCount: userController.users.length,
                  itemBuilder: (context, index) {
                    final user = userController.users[index];
                    final userId = user['id'] ?? 0; // إعطاء معرف افتراضي إذا كانت القيمة فارغة
                    final userName = user['name'] ?? 'مستخدم غير معروف'; // اسم افتراضي
                    final userEmail = user['email'] ?? 'لا يوجد بريد إلكتروني'; // بريد إلكتروني افتراضي

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
                              userName.isNotEmpty ? userName[0].toUpperCase() : 'U',
                              style: const TextStyle(color: Colors.black),
                            ),
                          ),
                          title: Text(userName),
                          subtitle: Text(userEmail),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min, // لضبط الحجم بناءً على المحتوى
                            children: [
                              Obx(() {
                                return Checkbox(
                                  value: selectedUsers.contains(userId),
                                  onChanged: (bool? value) {
                                    if (value == true) {
                                      selectedUsers.add(userId);
                                    } else {
                                      selectedUsers.remove(userId);
                                    }
                                  },
                                );
                              }),
                              IconButton(
                                icon: Icon(Icons.info, color: green),
                                onPressed: () {
                                  Get.snackbar("معلومات", "معرف المستخدم: $userId");
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              }
            }),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (selectedUsers.isNotEmpty) {
            addUserToGroupControllerImp.addUserToGroup(selectedUsers.toList());
          } else {
            Get.snackbar("خطأ", "الرجاء اختيار مستخدم واحد على الأقل.");
          }
          print("تم الضغط على زر الإضافة!");
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
