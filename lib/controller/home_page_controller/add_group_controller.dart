import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:project/core/constant/routes.dart';
import '../../core/class/staterequest.dart';
import '../../core/function/handlingdata.dart';
import '../../data/dataresource/home_page_data/add_groug_data.dart';

abstract class AddGroupController extends GetxController {
  addGroup();
}

class AddGroupControllerImp extends AddGroupController {

  AddGroupData groupData;
  GlobalKey<FormState> formState = GlobalKey<FormState>();
  StatusRequest? statusRequest;
  bool isShowPassword = true;
  late TextEditingController name;
  AddGroupData g = AddGroupData(Get.find());

  AddGroupControllerImp(this.groupData);

  @override
  void onInit() {
    name = TextEditingController();
    super.onInit();
  }

  @override
  Future<void> addGroup() async {

    var formData = formState.currentState;
    if (formData != null && formData.validate()) {
      statusRequest = StatusRequest.loading;
      update();

      try {
        var response = await groupData.postMultipart(name.text);  // إرسال التوكن مع الطلب
        print("-----------------------------controller file --------------------");
        print(response);
        print('-------------------------------------------------------------');

        statusRequest = handlingData(response);

        if (statusRequest == StatusRequest.success) {
          print("Response data: $response");
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
