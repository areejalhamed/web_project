import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../core/class/staterequest.dart';
import '../../core/function/handlingdata.dart';
import '../../data/dataresource/home_page_data/add_user_to_gruop_data.dart';

abstract class AddUserToGroupController extends GetxController {
  Future<void> addUserToGroup(List<int> userIds);
}

class AddUserToGroupControllerImp extends AddUserToGroupController {
  final AddUserToGroupData userData;
  final int groupId;
  StatusRequest? statusRequest;

  AddUserToGroupControllerImp(this.userData, this.groupId);

  @override
  void onInit() {
    super.onInit();
  }

  @override
  Future<void> addUserToGroup(List<int> userIds) async {
    statusRequest = StatusRequest.loading;
    update();

    try {
      var response = await userData.postMultipart(userIds, groupId);
      statusRequest = handlingData(response);

      if (statusRequest == StatusRequest.success) {
        Get.snackbar("Success", "Users added to group successfully.");
        print("Response: $response");
      } else {
        Get.snackbar("Error", "Failed to add users to group.");
        print("Response error: $response");
      }
    } catch (e) {
      print("Error occurred: $e");
      Get.snackbar("Error", "An unexpected error occurred.");
      statusRequest = StatusRequest.failure;
    } finally {
      update();
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}
