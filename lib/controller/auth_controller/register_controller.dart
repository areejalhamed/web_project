import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:project/core/constant/routes.dart';
import 'package:project/data/dataresource/Auth/register.dart';
import '../../core/class/staterequest.dart';
import '../../core/function/handlingdata.dart';

abstract class Registercontroller extends GetxController {
  Future<void> register(); // تأكد من أن الدالة هنا تعود بـ Future
  void goToLogin();
  void goToHomePage();
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
  Future<void> register() async {
    var formdataa = formstate.currentState;
    if (formdataa != null && formdataa.validate()) {
      statusRequest = StatusRequest.loading;
      update();

      var response = await registerData.postData(name.text, email.text, password.text);

      print("-----------------------------controller file --------------------");
      print(response);
      print('-------------------------------------------------------------');

      // تحقق مما إذا كانت الاستجابة تحتوي على بيانات
      if (response is Map<String, dynamic>) {
        statusRequest = handlingData(response);
        print('--------------------------1-----------------------------------');
        print("---$statusRequest------");

        // تحقق من نجاح التسجيل
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
        }
      } else {
        // إذا كانت الاستجابة ليست خريطة
        Get.defaultDialog(
            title: "Error",
            middleText: "29".tr
        );
        statusRequest = StatusRequest.failure;
      }

      update();
    } else {
      print('Form validation failed');
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
