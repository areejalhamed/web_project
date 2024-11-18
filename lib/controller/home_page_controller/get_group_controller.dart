import 'package:get/get.dart';
import 'package:project/data/dataresource/home_page_data/get_group_data.dart';
import '../../core/class/staterequest.dart';
import '../../core/function/handlingdata.dart';

abstract class GetAllGroupController extends GetxController {
  getGroup();
}

class GetAllGroupControllerImp extends GetAllGroupController {

  final GetAllGroupData getGroupData;
  StatusRequest? statusRequest;
  List<dynamic> groups = [];

  GetAllGroupControllerImp(this.getGroupData);

  @override
  void onInit() {
    super.onInit();
    getGroup();
  }

  @override
  Future<void> getGroup() async {
    statusRequest = StatusRequest.loading;
    update();

    try {
      var response = await getGroupData.get();

      statusRequest = handlingData(response);

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
      statusRequest = StatusRequest.failure;
    } finally {
      update();
    }
  }
}
