import 'package:get/get.dart';
import 'package:project/data/dataresource/home_page_data/get_group_data.dart';
import '../../core/class/staterequest.dart';
import '../../core/function/handlingdata.dart';
import '../../data/dataresource/home_page_data/get_report_dara.dart';
import '../../data/dataresource/home_page_data/get_user_data.dart';

abstract class GetReportController extends GetxController {
  getReport(int groupId); // تعديل هنا لإضافة المعلمة
}

class GetReportControllerImp extends GetReportController {
  final GetReportData getGroupData;

  var fileId = 0.obs;

  var statusRequest = StatusRequest.loading.obs;
  var users = <Map<String, dynamic>>[].obs;

  GetReportControllerImp(this.getGroupData ,  int initialGroupId){
    fileId(initialGroupId); // تعيين المجموعة الأولى عند الإنشاء

  }

  @override
  void onInit() {
    ever(fileId, (int groupId) {
      getReport(groupId);
    });
    getReport(fileId.value);
  }

  @override
  Future<void> getReport(int groupId) async {
    statusRequest(StatusRequest.loading);
    update();

    try {
      print("Fetching reports for group ID: $groupId");
      var response = await getGroupData.get(groupId);
      print("Response: $response");

      if (response == null) {
        Get.snackbar("Error", "Failed to load reports. Null response.");
        statusRequest(StatusRequest.failure);
        update();
        return;
      }

      statusRequest(handlingData(response));
      if (statusRequest.value == StatusRequest.success && response.isRight()) {
        users.assignAll(response.getOrElse(() => []));
        print("Reports data in controller: $users");
        Get.snackbar("Success", "Reports fetched successfully");
      } else {
        Get.snackbar("Error", "Failed to load reports.");
      }
    } catch (e) {
      print("Error occurred: $e");
      Get.snackbar("Error", "An error occurred while fetching the reports.");
      statusRequest(StatusRequest.failure);
    } finally {
      update();
    }
  }
}
