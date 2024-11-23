import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controller/home_page_controller/get_group_for_user_controller.dart';
import '../../../core/class/crud.dart';
import '../../../core/class/staterequest.dart';
import '../../../core/constant/color.dart';
import '../../../data/dataresource/home_page_data/get_group_for_user_data.dart';

class GetMyGroups extends StatelessWidget {
  final int userId; // معرف المستخدم يتم تمريره عند استدعاء الصفحة

  const GetMyGroups({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    // إنشاء المتحكم واستدعاء الدالة لجلب البيانات
    final GetGroupForUserControllerImp groupController = Get.put(
      GetGroupForUserControllerImp(GetGroupForUserData(Crud())),
    );

    // استدعاء الدالة لجلب الغروبات عند بناء الصفحة
    groupController.getMyGroups(userId);

    return Scaffold(
      appBar: AppBar(
        title: const Text("My Groups"),
        backgroundColor: sevenBackColor,
      ),
      body: Obx(() {
        if (groupController.statusRequest.value == StatusRequest.loading) {
          // إظهار مؤشر تحميل أثناء انتظار البيانات
          return const Center(child: CircularProgressIndicator());
        } else if (groupController.groupList.isEmpty) {
          // رسالة عند عدم وجود غروبات
          return const Center(child: Text("No groups found."));
        } else {
          // عرض قائمة الغروبات
          return ListView.builder(
            itemCount: groupController.groupList.length,
            itemBuilder: (context, index) {
              final group = groupController.groupList[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                elevation: 4,
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.blueAccent,
                    child: Text(
                      group['name'][0].toUpperCase(),
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  title: Text(group['name']),
                  subtitle: Text("ID: ${group['id']}"),
                  trailing: const Icon(Icons.arrow_forward_ios),
                ),
              );
            },
          );
        }
      }),
    );
  }
}
