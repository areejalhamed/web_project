import 'dart:typed_data';
import 'package:get/get.dart';
import 'package:project/core/class/staterequest.dart';
import 'package:project/core/function/handlingdata.dart';
import 'package:project/data/dataresource/home_page_data/update_file_data.dart';

abstract class UpdateFileController extends GetxController {
  Future<void> updateFile({
    required int fileId,
    required int userId,
    required Uint8List fileBytes,
    required String fileName,  });
}

class UpdateFileControllerImp extends UpdateFileController {
  final UpdateFileData updateFileData;
  StatusRequest? statusRequest;

  UpdateFileControllerImp(this.updateFileData);

  @override
  Future<void> updateFile({
    required int fileId,
    required int userId,
    required Uint8List fileBytes,
    required String fileName,
  }) async {
    statusRequest = StatusRequest.loading;
    update();

    try {
      var response = await updateFileData.postMultipart(
        fileId: fileId,
        userId: userId,
        fileBytes: fileBytes,
        fileName: fileName,
      );

      statusRequest = handlingData(response);

      if (statusRequest == StatusRequest.success) {
        Get.snackbar("Success", "File updated successfully!");
      } else {
        Get.snackbar("Error", "Failed to update the file.");
      }
    } catch (e) {
      print("Error occurred: $e");
      Get.snackbar("Error", "An error occurred while updating the file.");
      statusRequest = StatusRequest.failure;
    } finally {
      update();
    }
  }
}
