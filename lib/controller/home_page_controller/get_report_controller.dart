import 'package:get/get.dart';
import 'package:project/data/dataresource/home_page_data/get_group_data.dart';
import '../../core/class/staterequest.dart';
import '../../core/function/handlingdata.dart';
import '../../data/dataresource/home_page_data/get_report_dara.dart';
import '../../data/dataresource/home_page_data/get_user_data.dart';
import '../../view/screen/home_page/get_report.dart';

abstract class GetReportController extends GetxController {
  getReport(int groupId); // تعديل هنا لإضافة المعلمة
}

class GetReportControllerImp extends GetReportController {

  final GetReportData getReportData;
  var fileId = 0.obs;
  var statusRequest = StatusRequest.loading.obs;
  var report = <Map<String, dynamic>>[].obs;

  GetReportControllerImp(this.getReportData);

  @override
  void onInit() {
    super.onInit();
    getReport(fileId.value);
  }

  @override
  Future<void> getReport(int groupId) async {

    statusRequest(StatusRequest.loading);
    update();

    try {
      var response = await getReportData.get(groupId);

      statusRequest.value = handlingData(response);
      if (statusRequest.value == StatusRequest.success) {
        if (response.isRight()) {
          report.value = response.getOrElse(() => []); // Update groups value
          // print("report data in controller: $report");
          Get.snackbar("Success", "success to fetch report.");
        }
      } else {
        Get.snackbar("Error", "Failed to fetch report.");
      }
    } catch (e) {
      print("Error occurred: $e");
      Get.snackbar("Error", "An error occurred while fetching the groups.");
      statusRequest.value = StatusRequest.failure;
    }
  }
}
