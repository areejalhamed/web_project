import 'package:get/get.dart';
import 'package:project/data/dataresource/home_page_data/get_group_data.dart';
import '../../core/class/staterequest.dart';
import '../../core/function/handlingdata.dart';
import '../../data/dataresource/home_page_data/get_user_data.dart';

abstract class GetUserController extends GetxController {
  getUser(String groupId); // تعديل هنا لإضافة المعلمة
}

class GetUserControllerImp extends GetUserController {
  final GetUserGroupData getGroupData;
  StatusRequest? statusRequest;
  List<Map<String, dynamic>> users = []; // تغيير هنا أيضًا إلى List<Map<String, dynamic>>

  GetUserControllerImp(this.getGroupData);

  @override
  void onInit() {
    super.onInit();
  }

  @override
  Future<void> getUser(String groupId) async { // تعديل هنا لإضافة المعلمة
    statusRequest = StatusRequest.loading;
    update();

    try {
      var response = await getGroupData.get(groupId); // تمرير groupId

      statusRequest = handlingData(response);

      if (statusRequest == StatusRequest.success) {
        if (response.isRight()) {
          users = response.getOrElse(() => []);
          print("User data in controller: $users");
        }
        Get.snackbar("Success", "User fetched successfully");
      } else {
        Get.snackbar("28".tr, "37".tr);
      }
    } catch (e) {
      print("Error occurred: $e");
      Get.snackbar("28".tr, "An error occurred while fetching the users.");
      statusRequest = StatusRequest.failure;
    } finally {
      update();
    }
  }
}
