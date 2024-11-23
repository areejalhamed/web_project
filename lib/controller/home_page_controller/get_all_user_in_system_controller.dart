import 'package:get/get.dart';
import '../../core/class/staterequest.dart';
import '../../core/function/handlingdata.dart';
import '../../data/dataresource/home_page_data/get_all_user_in_system_data.dart';

abstract class GetAllUserInSystemController extends GetxController {
  getUser();
}

class GetAllUserInSystemControllerImp extends GetAllUserInSystemController {
  final GetAllUserInSystemData getAllUserInSystemData;
  var statusRequest = StatusRequest.loading.obs;
  var users = <Map<String, dynamic>>[].obs; // RxList محددة النوع

  GetAllUserInSystemControllerImp(this.getAllUserInSystemData);

  @override
  void onInit() {
    super.onInit();
    getUser();
  }

  @override
  Future<void> getUser() async {
    statusRequest.value = StatusRequest.loading;

    try {
      var response = await getAllUserInSystemData.getData();

      response.fold((failure) {
        statusRequest.value = failure;
        Get.snackbar("Error", "Failed to fetch users.");
      }, (data) {
        users.value = data;
        statusRequest.value = StatusRequest.success;
        print("Users data in controller: $users");
      });
    } catch (e) {
      statusRequest.value = StatusRequest.failure;
      Get.snackbar("Error", "An error occurred: $e");
    }
  }
}
