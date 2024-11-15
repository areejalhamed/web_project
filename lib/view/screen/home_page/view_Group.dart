import 'dart:html' as html; // استيراد مكتبة html فقط للويب
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project/controller/home_page_controller/add_file_to_group_controller.dart';
import 'package:project/data/dataresource/home_page_data/add_file_to_group_data.dart';

class ViewGroup extends StatelessWidget {
  final String groupName;
  // final AddFileToGroupControllerImp controller = Get.put(AddFileToGroupControllerImp(Get.find()));
  // final AddFileToGroupData g = Get.put(AddFileToGroupData(Get.find()));

  ViewGroup({super.key, required this.groupName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(groupName),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              "You are viewing the group: $groupName",
              style: const TextStyle(fontSize: 20),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (kIsWeb) {
            // اختيار الملف عبر متصفح الويب
            html.FileUploadInputElement uploadInput = html.FileUploadInputElement();
            uploadInput.accept = '*/*';
            uploadInput.click();

            uploadInput.onChange.listen((e) async {
              final files = uploadInput.files;
              if (files != null && files.isNotEmpty) {
                final file = files[0];
                print('Selected file: ${file.name}');

                // استدعاء الدالة لإضافة الملف إلى المجموعة
                // await controller.addFileToGroup(file as File);
              }
            });
          } else {
            print("File picking is supported on this platform only.");
          }
        },
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
