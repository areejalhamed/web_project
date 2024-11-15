// import 'dart:io' if (dart.library.html) 'dart:html' as html;
// import 'dart:typed_data';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:project/data/dataresource/home_page_data/add_file_to_group_data.dart';
// import '../../core/class/staterequest.dart';
// import '../../core/function/handlingdata.dart';
//
// abstract class AddFileToGroupController extends GetxController {
//   addFileToGroup({String? filePath, Uint8List? webFileBytes});
// }
//
// class AddFileToGroupControllerImp extends AddFileToGroupController {
//   final AddFileToGroupData groupData;
//   StatusRequest? statusRequest;
//   late TextEditingController name;
//
//   AddFileToGroupControllerImp(this.groupData);
//
//   @override
//   void onInit() {
//     name = TextEditingController();
//     super.onInit();
//   }
//
//   @override
//   Future<void> addFileToGroup({String? filePath, Uint8List? webFileBytes}) async {
//     statusRequest = StatusRequest.loading;
//     update();
//
//     try {
//       var response;
//       if (kIsWeb) {
//         // التعامل مع الملف في بيئة الويب باستخدام webFileBytes
//         response = await groupData.postMultipart(id,name.text, webFileBytes: webFileBytes);
//       } else {
//         // التعامل مع الملف في بيئة الهاتف أو سطح المكتب باستخدام filePath
//         if (filePath != null) {
//           response = await groupData.postMultipart(id ,name.text, filePath: filePath);
//         }
//       }
//
//       print("Controller Response: $response");
//
//       statusRequest = handlingData(response);
//
//       if (statusRequest == StatusRequest.success) {
//         Get.snackbar("Success", "File added successfully to the group");
//       } else {
//         Get.snackbar("Failure", "Failed to add file to group. Please try again.");
//       }
//     } catch (e) {
//       print("Error occurred: $e");
//       Get.snackbar("Error", "An error occurred while adding the file.");
//       statusRequest = StatusRequest.failure;
//     } finally {
//       update();
//       statusRequest = StatusRequest.idle;
//     }
//   }
//
//   @override
//   void dispose() {
//     name.dispose();
//     super.dispose();
//   }
// }
