import 'package:get/get.dart';
import 'package:project/core/constant/routes.dart';
import '../../core/class/staterequest.dart';
import '../../data/dataresource/home_page_data/leave_group_data.dart';

abstract class LeaveGroupController extends GetxController {
  Future<void> leaveGroup(int groupId, int userId);
}

class LeaveGroupControllerImp extends LeaveGroupController {
  final LeaveGroupData leaveGroupData;

  var statusRequest = StatusRequest.loading.obs;

  LeaveGroupControllerImp({required this.leaveGroupData});

  @override
  Future<void> leaveGroup(int groupId, int userId) async {
    statusRequest(StatusRequest.loading);
    update();

    try {
      print("Attempting to leave group with ID: $groupId for user ID: $userId");

      var response = await leaveGroupData.leave(groupId, userId); // استدعاء دالة الخروج
      print("Response: $response");

      if (response.isRight()) {
        statusRequest(StatusRequest.success);
        print(response);
        Get.snackbar("Success", "You have left the group successfully.");
        Get.toNamed(AppRoute.homePage);
      } else {
        statusRequest(StatusRequest.failure);
        print(response);
        Get.snackbar("Error", "Failed to leave the group.");
      }
    } catch (e) {
      print("Error occurred: $e");
      statusRequest(StatusRequest.failure);
      Get.snackbar("Error", "An unexpected error occurred.");
    } finally {
      update();
    }
  }
}