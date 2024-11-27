import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project/view/screen/home_page/view_Group.dart';
import '../../../controller/home_page_controller/get_group_for_user_controller.dart';
import '../../../core/class/crud.dart';
import '../../../core/class/staterequest.dart';
import '../../../core/constant/color.dart';
import '../../../data/dataresource/home_page_data/get_group_for_user_data.dart';

class GetMyGroups extends StatelessWidget {
  final int userId;

  const GetMyGroups({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {

    final GetGroupForUserControllerImp groupController = Get.put(
      GetGroupForUserControllerImp(GetGroupForUserData(Crud())),
    );

    // جلب الغروبات
    groupController.getMyGroups(userId);

    return Scaffold(
      appBar: AppBar(
        title: const Text("My Groups"),
        backgroundColor: sevenBackColor,
        actions: [
          IconButton(
            icon: Icon(
              Icons.refresh,
              color: Theme.of(context).colorScheme.background,
            ),
            onPressed: () {
              groupController.getMyGroups(userId); // تحديث البيانات
            },
          ),
        ],
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
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),

                child: ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  leading: CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Text(
                      group['name'][0].toUpperCase(),
                      style: TextStyle(color: Theme.of(context).colorScheme.primary),
                    ),
                  ),
                  title: Text(
                    group['name'],
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  trailing: const Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.white,
                  ),
                  onTap: () {
                    final groupName = group['name'] ?? 'بدون اسم';
                    final groupId = group['id'];
                    Get.to(() => ViewGroup(
                      groupName: groupName,
                      groupId: groupId,
                    ),);
                  },
                ),
              );
            },
          );
        }
      }),
    );
  }
}
