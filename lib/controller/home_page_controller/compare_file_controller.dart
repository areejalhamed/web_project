import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../core/constant/routes.dart';
import '../../core/class/staterequest.dart';
import '../../core/function/handlingdata.dart';
import '../../data/dataresource/home_page_data/compare_file_data.dart';

abstract class CompareFileController extends GetxController {
  Future<void> compareFile(int fileId);
}

class CompareFileControllerImp extends CompareFileController {
  final CompareFileData compareFileData;
  late TextEditingController diffController;
  String? diffResult; // لتخزين الفرق

  StatusRequest? statusRequest;
  bool isShowPassword = true;

  CompareFileControllerImp(this.compareFileData);

  @override
  void onInit() {
    diffController = TextEditingController();
    super.onInit();
  }

  @override
  Future<void> compareFile(int fileId) async {
    statusRequest = StatusRequest.loading;
    update();

    try {
      // استدعاء API والحصول على الاستجابة
      var response = await compareFileData.get(fileId);

      // معالجة الاستجابة
      if (response != null && response['success'] == true) {
        var responseData = response['data']?['original'];
        if (responseData != null) {
          // استخراج البيانات المطلوبة
          diffResult = responseData['diff'] ?? "No differences found.";
          String newFileName = responseData['new_file_name'] ?? "Unknown New File";
          String oldFileName = responseData['old_file_name'] ?? "Unknown Old File";
          String newFileDate = responseData['new_file_last_modified_at'] ?? "Unknown Date";
          String oldFileDate = responseData['old_file_last_modified_at'] ?? "Unknown Date";

          // الانتقال إلى صفحة DiffPage مع البيانات
          Get.toNamed(
            AppRoute.diffPage,
            arguments: {
              'diff': diffResult,
              'newFileName': newFileName,
              'oldFileName': oldFileName,
              'newFileDate': newFileDate,
              'oldFileDate': oldFileDate,
            },
          );
        } else {
          Get.snackbar("Error", "Invalid response structure.");
        }
      } else {
        Get.snackbar("Error", "Failed to compare files.");
      }
    } catch (e) {
      print("Error occurred: $e");
      Get.snackbar("Error", "An unexpected error occurred: $e");
      statusRequest = StatusRequest.failure;
    } finally {
      update();
    }
  }

  @override
  void dispose() {
    diffController.dispose();
    super.dispose();
  }
}

