import 'package:get/get.dart';
import 'package:project/data/dataresource/home_page_data/get_group_data.dart';
import '../../core/class/staterequest.dart';
import '../../core/function/handlingdata.dart';

abstract class GetAllGroupController extends GetxController {
  getGroup();
  searchGroup(String groupName); // تعريف تابع البحث
}

class GetAllGroupControllerImp extends GetAllGroupController {
  final GetAllGroupData getGroupData;
  var statusRequest = StatusRequest.loading.obs; // حوله إلى Rx
  RxList<dynamic> groups = <dynamic>[].obs; // RxList بدلاً من List
  RxList<dynamic> searchResults = <dynamic>[].obs; // نتائج البحث

  GetAllGroupControllerImp(this.getGroupData);

  @override
  void onInit() {
    super.onInit();
    getGroup();
  }

  @override
  Future<void> getGroup() async {
    statusRequest.value = StatusRequest.loading;

    try {
      var response = await getGroupData.get();

      statusRequest.value = handlingData(response);
      if (statusRequest.value == StatusRequest.success) {
        if (response.isRight()) {
          groups.value = response.getOrElse(() => []); // Update groups value
          print("Groups data in controller: $groups");
        }
      } else {
        Get.snackbar("Error", "Failed to fetch groups.");
      }
    } catch (e) {
      print("Error occurred: $e");
      Get.snackbar("Error", "An error occurred while fetching the groups.");
      statusRequest.value = StatusRequest.failure;
    }
  }

  @override
  Future<void> searchGroup(String groupName) async {
    if (groupName.isEmpty) {
      searchResults.clear(); // مسح النتائج عند حذف النص
      return;
    }

    // فلترة النتائج محليًا بناءً على الاسم
    searchResults.value = groups
        .where((group) =>
    group['name'] != null &&
        group['name'].toString().toLowerCase().contains(groupName.toLowerCase()))
        .toList();
  }
}
