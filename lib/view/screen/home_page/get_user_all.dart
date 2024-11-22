import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controller/home_page_controller/get_user_controller.dart';
import '../../../core/class/crud.dart';
import '../../../core/class/staterequest.dart';
import '../../../core/constant/color.dart';
import '../../../data/dataresource/home_page_data/get_user_data.dart';

class GetAllUser extends StatelessWidget {
  final int groupId;

  GetAllUser({super.key, required this.groupId});

  @override
  Widget build(BuildContext context) {
    final GetUserControllerImp getUserControllerImp =
    Get.put(GetUserControllerImp(GetUserGroupData(Crud()), groupId));

    return Scaffold(
      appBar: AppBar(
        backgroundColor: sevenBackColor,
        title: Obx(() {
          return Text(
            'User Count: ${getUserControllerImp.users.isNotEmpty ? getUserControllerImp.users[0]['userCount'] : 0}',
            style: const TextStyle(fontSize: 18),
          );
        }),
      ),
      body: Obx(() {
        if (getUserControllerImp.statusRequest.value == StatusRequest.loading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (getUserControllerImp.statusRequest.value == StatusRequest.failure) {
          return Center(
            child: TextButton(
              onPressed: () {
                getUserControllerImp.getUser(groupId);
              },
              child: const Text("Error loading users. Retry?"),
            ),
          );
        } else if (getUserControllerImp.users.isNotEmpty) {
          return ListView.builder(
            itemCount: getUserControllerImp.users.length,
            itemBuilder: (context, index) {
              final user = getUserControllerImp.users[index];
              return Container(
                margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: secondBackColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListTile(
                  leading: const Icon(Icons.person, color : sevenBackColor),
                  title: Text(
                    user['name'] ?? 'Unknown User',
                    style: const TextStyle(color: sixBackColor),
                  ),
                  subtitle: Text(
                    user['email'] ?? 'No Email',
                    style:const TextStyle(color: sixBackColor),
                  ),
                  trailing: Text(
                    user['pivot']['role'],
                    style: const TextStyle(color: Colors.white),
                  ),
                  onTap: () {
                    print("Selected User: ${user['name']}");
                  },
                ),
              );
            },
          );
        } else {
          return const Center(
            child: Text("No users available"),
          );
        }
      }),
    );
  }
}
