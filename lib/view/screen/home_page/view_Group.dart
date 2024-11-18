import 'dart:async';
import 'dart:html' as html;
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project/controller/home_page_controller/add_file_to_group_controller.dart';
import 'package:project/data/dataresource/home_page_data/get_user_data.dart';
import '../../../controller/home_page_controller/get_file_from_group_controller.dart';
import '../../../controller/home_page_controller/get_user_controller.dart';
import '../../../core/class/crud.dart';
import '../../../core/class/staterequest.dart';
import '../../../core/constant/color.dart';
import '../../../data/dataresource/home_page_data/get_file_from_group_data.dart';

class ViewGroup extends StatelessWidget {
  final String groupName;
  final int groupId;
  final AddFileToGroupControllerImp controller =
  Get.put(AddFileToGroupControllerImp(Get.find()));

  ViewGroup({super.key, required this.groupName, required this.groupId});

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() =>
        GetFileFromGroupControllerImp(GetFileFromGroupData(Crud()), groupId));

    final GetFileFromGroupControllerImp getFileFromGroupControllerImp =
    Get.find<GetFileFromGroupControllerImp>();


    final GetUserControllerImp getUserControllerImp = Get.put(GetUserControllerImp(GetUserGroupData(Crud())));

    return Scaffold(
        appBar: AppBar(
          backgroundColor: sevenBackColor,
          title: Text(
            groupName,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          // actions: [
          //   Obx(() {
          //     if (getUserControllerImp.statusRequest == StatusRequest.loading) {
          //       return const Center(child: CircularProgressIndicator());
          //     } else if (getUserControllerImp.statusRequest == StatusRequest.failure) {
          //       return TextButton(
          //         onPressed: () {},
          //         child: Text("Error loading users"),
          //       );
          //     } else if (getUserControllerImp.users.isNotEmpty) {
          //       // عرض المستخدمين في DropdownButton
          //       return DropdownButton<String>(
          //         onChanged: (String? selectedUser) {
          //           // يمكن استخدام هذا لتغيير أو التعامل مع المستخدم المختار
          //           print("Selected User: $selectedUser");
          //         },
          //         items: getUserControllerImp.users.map((user) {
          //           return DropdownMenuItem<String>(
          //             value: user['name'],
          //             child: Text(user['name']),
          //           );
          //         }).toList(),
          //       );
          //     } else {
          //       return TextButton(
          //         onPressed: () {},
          //         child: Text("No users available"),
          //       );
          //     }
          //   }),
          // ],
        ),

        body: Column(
        children: [
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                await getFileFromGroupControllerImp.getFile(groupId);
              },
              child: Obx(() {
                if (getFileFromGroupControllerImp.statusRequest.value ==
                    StatusRequest.loading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (getFileFromGroupControllerImp.statusRequest.value ==
                    StatusRequest.failure) {
                  return Center(
                    child: Text('42'.tr),
                  );
                } else if (getFileFromGroupControllerImp.files.isEmpty) {
                  return Center(
                    child: Text('43'.tr),
                  );
                } else {
                  return ListView.builder(
                    padding: const EdgeInsets.all(16.0),
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: getFileFromGroupControllerImp.files.length,
                    itemBuilder: (context, index) {
                      final file = getFileFromGroupControllerImp.files[index];
                      return ListTile(
                        title: Text(file['name'] ?? 'Unnamed File'),
                        subtitle: Text(file['path'] ?? 'No Path'),
                        leading: const Icon(Icons.file_copy),
                      );
                    },
                  );
                }
              }),
            ),
          ),
          Container(
            color: grey,
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller.name,
                    decoration: InputDecoration(
                      labelText: "44".tr,
                      hintText: "44".tr,
                      border:const OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                FloatingActionButton(
                  onPressed: () => _handleFileUpload(),
                  child: Icon(Icons.upload_file),
                  tooltip: "45".tr,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _handleFileUpload() async {
    if (kIsWeb) {
      html.FileUploadInputElement uploadInput = html.FileUploadInputElement();
      uploadInput.accept = '*/*';
      uploadInput.click();

      uploadInput.onChange.listen((e) async {
        final files = uploadInput.files;
        if (files != null && files.isNotEmpty) {
          final file = files[0];
          controller.name.text = file.name;

          try {
            final webFileBytes = await readFileAsBytes(file);
            await controller.addFileToGroup(
                id: groupId, webFileBytes: webFileBytes);
            await Get.find<GetFileFromGroupControllerImp>().getFile(groupId);
          } catch (error) {
            Get.snackbar("Error", ": $error",
                backgroundColor: Colors.red, colorText: Colors.white);
          }
        } else {
          Get.snackbar("No file selected", "Please select a file to upload.",
              backgroundColor: Colors.orange, colorText: Colors.white);
        }
      });
    } else {
      Get.snackbar(
        "Unsupported Platform",
        "File upload is only supported on web.",
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
    }
  }

  Future<Uint8List> readFileAsBytes(html.File file) async {
    final reader = html.FileReader();
    final completer = Completer<Uint8List>();

    reader.readAsArrayBuffer(file);
    reader.onLoadEnd.listen((event) {
      completer.complete(reader.result as Uint8List);
    });

    reader.onError.listen((event) {
      completer.completeError(reader.error!);
    });

    return completer.future;
  }
}
