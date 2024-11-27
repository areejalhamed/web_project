import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:project/core/class/staterequest.dart';
import 'package:project/core/function/handlingdata.dart';
import '../../core/constant/routes.dart';
import '../../data/dataresource/home_page_data/search_user_name_data.dart';

abstract class SearchUserNameController extends GetxController {
  searchUserName(int id);
}

class SearchUserNameControllerImp extends SearchUserNameController {

  SearchUserNameData searchUserNameData;
  GlobalKey<FormState> formState = GlobalKey<FormState>();
  StatusRequest? statusRequest;
  late TextEditingController name;
  var users = <Map<String, dynamic>>[].obs;

  SearchUserNameControllerImp(this.searchUserNameData);

  @override
  void onInit() {
    name = TextEditingController();
    super.onInit();
  }


  @override
  Future<void> searchUserName(int id) async {
    var formData = formState.currentState;
    if (formData != null && formData.validate()) {
      statusRequest = StatusRequest.loading;
      update();

      try {
        var response = await searchUserNameData.postMultipart(
            name.text , id); // إرسال الرابط أو المسار
        statusRequest = handlingData(response);

        if (statusRequest == StatusRequest.success) {
          users.value = response['data']; // افترض أن البيانات في مفتاح 'data'
          Get.snackbar("30".tr, "35".tr);
          Get.toNamed(AppRoute.homePage);
        }
      } catch (e) {
        print("Error occurred: $e");
        Get.snackbar("28".tr, "36".tr);
        statusRequest = StatusRequest.failure;
      } finally {
        update();
      }
    } else {
      print('Form is not valid');
    }
  }

  @override
  void dispose() {
    name.dispose();
    super.dispose();
  }
}
