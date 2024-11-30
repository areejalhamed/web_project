import 'package:get/get.dart';
import 'package:project/data/dataresource/home_page_data/get_group_data.dart';
import '../../core/class/staterequest.dart';
import '../../core/function/handlingdata.dart';
import '../../data/dataresource/home_page_data/get_user_data.dart';
import '../../data/dataresource/home_page_data/leave_group_data.dart';

abstract class LeaveGroupController extends GetxController {
  leaveGroup(int groupId , int userId); // تعديل هنا لإضافة المعلمة
}

class LeaveGroupControllerImp extends LeaveGroupController {
  final LeaveGroupData getGroupData;

  var groupId = 0.obs;

  var statusRequest = StatusRequest.loading.obs;
  var users = <Map<String, dynamic>>[].obs;

  LeaveGroupControllerImp({required this.getGroupData});

  @override
  void onInit() {
    // leaveGroup(groupId.value , userId.value);
  }

  @override
  Future<void> leaveGroup(int groupId , int userId) async {
    statusRequest(StatusRequest.loading);
    update();

    try {
      print("Fetching users for group ID: $groupId");
      var response = await getGroupData.get(groupId , userId);
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
