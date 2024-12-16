import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:project/core/class/staterequest.dart';
import 'package:project/core/function/handlingdata.dart';
import '../../data/dataresource/home_page_data/check_out_file_data.dart';

abstract class CheckOutFileController extends GetxController {
  Future<void> checkOutFile({required int fileId, required int userId});
}

class CheckOutFileControllerImp extends CheckOutFileController {
  final CheckOutFileData checkOutFileData;
  StatusRequest? statusRequest;

  CheckOutFileControllerImp(this.checkOutFileData);

  @override
  Future<void> checkOutFile({required int fileId, required int userId}) async {
    statusRequest = StatusRequest.loading;
    update();

    try {
      var response = await checkOutFileData.postMultipart(
        fileId: fileId,
        userId: userId,
      );
      statusRequest = handlingData(response);

      if (statusRequest == StatusRequest.success) {
        Get.snackbar("Success", "File checked out successfully!");
      } else {
        Get.snackbar("Error", "Failed to check out the file.");
      }
    } catch (e) {
      print("Error occurred: $e");
      Get.snackbar("Error", "An error occurred while checking out the file.");
      statusRequest = StatusRequest.failure;
    } finally {
      update();
    }
  }
}
