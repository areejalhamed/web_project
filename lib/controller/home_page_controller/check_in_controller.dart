import 'package:dartz/dartz.dart';
import 'package:get/get.dart';
import '../../core/class/staterequest.dart';
import '../../data/dataresource/home_page_data/check_in_data.dart';

abstract class CheckInController extends GetxController {
  Future<void> checkIn(List<int> fileIds);
}

class CheckInControllerImp extends CheckInController {
  final CheckInData checkInData;
  final int groupId;
  StatusRequest? statusRequest;

  CheckInControllerImp(this.checkInData, this.groupId);

  @override
  Future<void> checkIn(List<int> fileIds) async {
    statusRequest = StatusRequest.loading;
    update();

    try {
      // إرسال الطلب واستقبال الاستجابة
      var response = await checkInData.postMultipart(fileIds, groupId);

      print("Response type: ${response.runtimeType}");
      print("Response: $response");

      // التحقق من هيكل الاستجابة
      if (response is Map && response.containsKey('message')) {
        String message = response['message'];

        if (message == "Files reserved successfully") {
          statusRequest = StatusRequest.success;
          Get.snackbar("Success", message); // رسالة نجاح
        } else if (message == "One or more files are already reserved or taken") {
          statusRequest = StatusRequest.failure;
          Get.snackbar("Reservation Error", message); // خطأ في الحجز
        } else {
          statusRequest = StatusRequest.failure;
          Get.snackbar("Error", message); // رسالة خطأ أخرى
        }
      } else {
        statusRequest = StatusRequest.failure;
        Get.snackbar("Error", "Unexpected response format.");
      }
    } catch (e) {
      // معالجة الاستثناءات
      statusRequest = StatusRequest.failure;
      print("Error: $e");
      Get.snackbar("Error", "An unexpected error occurred.");
    } finally {
      update();
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}
