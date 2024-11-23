import 'package:get/get.dart';
import 'package:project/data/dataresource/home_page_data/get_group_data.dart';
import '../../core/class/staterequest.dart';
import '../../core/function/handlingdata.dart';

abstract class GetAllGroupController extends GetxController {
  getGroup();
}

class GetAllGroupControllerImp extends GetAllGroupController {

  final GetAllGroupData getGroupData;
  var statusRequest = StatusRequest.loading.obs; // حوله إلى Rx
  List<dynamic> groups = [].obs; // RxList

  GetAllGroupControllerImp(this.getGroupData);

  @override
  void onInit() {
    super.onInit();
    getGroup();
  }

  @override
  Future<void> getGroup() async {

    statusRequest.value = StatusRequest.loading; // أثناء التحميل
    update();

    try {
      var response = await getGroupData.get();

      statusRequest.value = handlingData(response);
      if (statusRequest == StatusRequest.success) {
        if (response.isRight()) {
          groups = response.getOrElse(() => []);
          print("Groups data in controller: $groups");
        }
        // Get.snackbar("Success", "Groups fetched successfully");
      } else {
        Get.snackbar("28".tr, "37".tr);
      }
    } catch (e) {
      print("Error occurred: $e");
      Get.snackbar("28".tr, "An error occurred while fetching the groups.");
      statusRequest.value = StatusRequest.failure;
    } finally {
      update();
    }
  }
}
