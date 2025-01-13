import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:project/core/class/staterequest.dart';
import '../../applink.dart';
import '../../data/dataresource/home_page_data/search_user_name_data.dart';

abstract class SearchUserNameController extends GetxController {
  searchUserName(int groupId);
}

class SearchUserNameControllerImp extends SearchUserNameController {
  final SearchUserNameData searchUserNameData;
  StatusRequest? statusRequest;
  late TextEditingController name;
  var users = <Map<String, dynamic>>[].obs;
  var noUsersFound = false.obs; // هذا المتغير يتحكم في ظهور رسالة لا يوجد مستخدمين

  SearchUserNameControllerImp(this.searchUserNameData);

  @override
  void onInit() {
    name = TextEditingController();
    super.onInit();
  }

  @override
  Future<void> searchUserName(int groupId) async {
    statusRequest = StatusRequest.loading;
    update();

    try {
      String query = name.text.trim();
      if (query.isEmpty) {
        Get.snackbar("Error", "Input cannot be empty. Please enter a valid value.");
        statusRequest = StatusRequest.failure;
        update();
        return;
      }

      var response = await searchUserNameData.postMultipart(
        "${Applink.searchUsersName}/$groupId",
        fields: {"name": query},
      );

      response.fold(
            (failure) {
          statusRequest = failure;
          Get.snackbar("Error", "Request failed. Please try again.");
        },
            (data) {
          statusRequest = StatusRequest.success;

          // تحقق من البيانات إذا كانت تحتوي على مستخدمين بنفس الاسم
          if (data['data'] != null && data['data'] is List) {
            List<dynamic> userList = data['data'];
            if (userList.isNotEmpty) {
              // عرض الأسماء المتشابهة
              users.value = List<Map<String, dynamic>>.from(userList);
              noUsersFound.value = false;
            } else {
              // إذا لم يتم العثور على مستخدمين بنفس الاسم
              users.clear();
              noUsersFound.value = true;
            }
          } else {
            // إذا كانت البيانات غير صالحة أو غير موجودة
            users.clear();
            noUsersFound.value = true;
          }
        },
      );
    } catch (e) {
      print("Error occurred: $e");
      Get.snackbar("Error", "An error occurred. Please try again.");
      statusRequest = StatusRequest.failure;
    } finally {
      update();
    }
  }

  // تابع لإعادة تعيين البحث
  void clearSearch() {
    name.clear(); // مسح النص داخل الحقل
    users.clear(); // إعادة تعيين قائمة المستخدمين
    statusRequest = StatusRequest.none; // إعادة تعيين الحالة
  }

  @override
  void dispose() {
    name.dispose();
    super.dispose();
  }
}
