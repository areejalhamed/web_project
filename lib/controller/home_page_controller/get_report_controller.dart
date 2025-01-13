import 'package:get/get.dart';
import 'package:project/data/dataresource/home_page_data/get_group_data.dart';
import '../../core/class/staterequest.dart';
import '../../core/function/handlingdata.dart';
import '../../data/dataresource/home_page_data/get_report_dara.dart';
import '../../data/dataresource/home_page_data/get_user_data.dart';

abstract class GetReportController extends GetxController {
  getUser(int groupId);
}

class GetReportControllerImp extends GetReportController {
  final GetReportData getReportData;

  var groupId = 0.obs;

  var statusRequest = StatusRequest.loading.obs;
  var users = <Map<String, dynamic>>[].obs;

  GetReportControllerImp(this.getReportData ,  int initialGroupId){
    groupId(initialGroupId);

  }

  @override
  void onInit() {
    ever(groupId, (int groupId) {
      getUser(groupId);
    });
    getUser(groupId.value);
  }

  @override
  Future<void> getUser(int groupId) async {
    statusRequest(StatusRequest.loading);
    update();

    try {
      print("Fetching users for group ID: $groupId");
      var response = await getReportData.get(groupId);
      print("Response: $response");

      if (response == null) { // إصلاح: تحقق من أن response غير فارغة
        Get.snackbar("Error", "Failed to load users. Null response.");
        statusRequest(StatusRequest.failure);
        update(); // تحديث الواجهة.
        return;
      }

      statusRequest(handlingData(response));
      if (statusRequest.value == StatusRequest.success && response.isRight()) {
        users.assignAll(response.getOrElse(() => []));
        print("User data in controller: $users");
        Get.snackbar("Success", "User fetched successfully");
      } else {
        Get.snackbar("Error", "Failed to load users.");
      }
    } catch (e) {
      print("Error occurred: $e");
      Get.snackbar("Error", "An error occurred while fetching the users.");
      statusRequest(StatusRequest.failure);
    } finally {
      update();
    }
  }
}
