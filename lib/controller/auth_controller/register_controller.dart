import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:project/core/constant/color.dart';
import 'package:project/core/constant/routes.dart';
import 'package:project/data/dataresource/Auth/register.dart';
import '../../core/class/staterequest.dart';
import '../../core/function/handlingdata.dart';

abstract class Registercontroller extends GetxController {
  Register();
  goToLogin();
  goToHomePage();
}

class Registercontroll extends Registercontroller {
  RegisterData registerData = RegisterData(Get.find());
  GlobalKey<FormState> formstate = GlobalKey<FormState>();
  StatusRequest? statusRequest;

  bool isshowpassword = true;

  late TextEditingController name;
  late TextEditingController email;
  late TextEditingController password;
  final box = GetStorage();

  void showpassword() {
    isshowpassword = !isshowpassword; // استخدام تعبير أبسط
    update();
  }

  @override
   Register() async {

    var formdata = formstate.currentState;
    if (formdata!.validate()) {

      statusRequest = StatusRequest.loading;
      update();
      var response = await registerData.postData(name.text, email.text, password.text);
      print("-----------------------------controller file --------------------");
      print('response : $response');
      statusRequest = handlingData(response);
      print("statusRequest : $statusRequest------");
      print('------------------------------------------------------------------');

      // تحقق مما إذا كانت الاستجابة تحتوي على بيانات
      if (statusRequest == StatusRequest.success ) {
        if (response["success"] == true) {
          Get.snackbar("26".tr, response["message"]);
          goToHomePage();
        } else {
          // إذا كان هناك خطأ في التسجيل
          Get.defaultDialog(
              title: "28".tr,
              middleText: response["message"] ?? "An error occurred"
          );
          statusRequest = StatusRequest.failure;
          goToHomePage();
        }
      }
      else {
        // إذا كان هناك خطأ في التسجيل
        Get.defaultDialog(
            title: "28".tr,
            middleText: "29".tr,
            backgroundColor: fourBackColor,
        );
        statusRequest = StatusRequest.failure;
      }
      update();
    }


  }



  @override
  void onInit() {
    name = TextEditingController();
    email = TextEditingController();
    password = TextEditingController();
    super.onInit();
  }

  @override
  void dispose() {
    name.dispose();
    email.dispose();
    password.dispose();
    super.dispose();
  }

  @override
  void goToLogin() {
    Get.toNamed(AppRoute.login);
  }

  @override
  void goToHomePage() {
    Get.offNamed(AppRoute.homePage);
  }
}
