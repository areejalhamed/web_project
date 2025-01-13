import 'dart:io' if (dart.library.html) 'dart:html' as html;
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/dataresource/home_page_data/add_file_to_group_data.dart';
import '../../core/class/staterequest.dart';
import '../../core/function/handlingdata.dart';

abstract class AddFileToGroupController extends GetxController {
  Future<void> addFileToGroup({required int id, String? filePath, Uint8List? webFileBytes});
}

class AddFileToGroupControllerImp extends AddFileToGroupController {
  final AddFileToGroupData groupData;
  StatusRequest? statusRequest;
  late TextEditingController name;

  AddFileToGroupControllerImp(this.groupData);

  @override
  void onInit() {
    name = TextEditingController();
    super.onInit();
  }

  @override
  Future<void> addFileToGroup({required int id, String? filePath, Uint8List? webFileBytes}) async {
    statusRequest = StatusRequest.loading;
    update();

    try {
      var response;
      if (kIsWeb && webFileBytes != null) {
        response = await groupData.postMultipart(id, name.text, webFileBytes: webFileBytes);
      } else if (filePath != null && File(filePath).existsSync()) {
        response = await groupData.postMultipart(id, name.text, filePath: filePath);
      } else {
        throw Exception("Invalid file data.");
      }

      statusRequest = handlingData(response);
      if (statusRequest == StatusRequest.success) {
        print("31".tr);
        Get.snackbar("30".tr, "31".tr, backgroundColor: Colors.green, colorText: Colors.white);
      } else {
        print("33".tr);
        Get.snackbar("32".tr, "33".tr, backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar("28".tr, e.toString(), backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      update();
      statusRequest = StatusRequest.idle;
    }
  }

  @override
  void dispose() {
    name.dispose();
    super.dispose();
  }
}
