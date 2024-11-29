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
  final int groupId; // استقبال groupId من الصفحة السابقة

  const GetAllUserInSystem({super.key, required this.groupId});

  @override
  Widget build(BuildContext context) {
    // Controllers
    final GetAllUserInSystemControllerImp userController =
    Get.put(GetAllUserInSystemControllerImp(GetAllUserInSystemData(Crud())));

    final AddUserToGroupControllerImp addUserToGroupControllerImp =
    Get.put(AddUserToGroupControllerImp(AddUserToGroupData(Crud()), groupId));

    final SearchUserNameControllerImp searchUserNameController =
    Get.put(SearchUserNameControllerImp(SearchUserNameData(Crud())));

    // قائمة لحفظ حالة اختيار المستخدمين
    final selectedUsers = <int>[].obs;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: sevenBackColor,
        title: const Text("Users"),
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
            child: SearchPage(
              onSearchChanged: (query) {
                searchUserNameController.searchUserName(query as int);
              },
              controller: searchUserNameController.name,
            ),
          ),
          Expanded(
            child: Obx(() {
              if (userController.statusRequest.value == StatusRequest.loading) {
                return const Center(child: CircularProgressIndicator());
              } else if (userController.statusRequest.value == StatusRequest.failure) {
                return const Center(child: Text("Failed to load users."));
              } else if (userController.users.isEmpty) {
                return const Center(child: Text("No users found."));
              } else {
                return ListView.builder(
                  itemCount: userController.users.length,
                  itemBuilder: (context, index) {
                    final user = userController.users[index];
                    final userId = user['id']; // معرف المستخدم
                    return Card(
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
                        title: Text(user['name']),
                        subtitle: Text(user['email']),
                        trailing: Obx(() {
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
            Get.snackbar("Error", "Please select at least one user.");
          }
          print("Floating Action Button Pressed!");
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
