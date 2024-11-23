import 'package:get/get.dart';
import '../../core/class/staterequest.dart';
import '../../data/dataresource/home_page_data/get_group_for_user_data.dart';

abstract class GetGroupForUserController extends GetxController {
  Future<void> getMyGroups(int userId); // جعلها Future لتوضيح أنها تعمل بشكل غير متزامن
}

class GetGroupForUserControllerImp extends GetGroupForUserController {
  final GetGroupForUserData getGroupForUserData;

  // الحالة العامة للطلب
  var statusRequest = StatusRequest.loading.obs;
  var userId = 0.obs; // معرف المستخدم الديناميكي

  // قائمة الغروبات
  var groupList = <Map<String, dynamic>>[].obs; // RxList محددة النوع

  GetGroupForUserControllerImp(this.getGroupForUserData);

  @override
  void onInit() {
    super.onInit();
    // يمكن تشغيل وظائف مبدئية إذا لزم الأمر
  }

  @override
  Future<void> getMyGroups(int userId) async {
    if (userId <= 0) {
      statusRequest.value = StatusRequest.failure;
      Get.snackbar("Error", "Invalid user ID provided.");
      return;
    }

    statusRequest.value = StatusRequest.loading;

    try {
      var response = await getGroupForUserData.getData(userId);

      response.fold((failure) {
        statusRequest.value = failure;
        Get.snackbar("Error", "Failed to fetch groups. Please try again.");
      }, (data) {
        // عرض البيانات المصنفة فقط
        groupList.value = data;
        statusRequest.value = StatusRequest.success;
        print("Filtered Groups: $groupList");
      });
    } catch (e) {
      statusRequest.value = StatusRequest.failure;
      Get.snackbar("Error", "An unexpected error occurred: $e");
    }
  }
}
