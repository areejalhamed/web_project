import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:project/data/dataresource/Auth/login.dart';
import '../../core/class/staterequest.dart';
import '../../core/constant/routes.dart';
import '../../core/function/handlingdata.dart';
import '../../core/services/services.dart';

abstract class Logincontroller extends GetxController {
  Login();
  gotoRegister();
  goToHomePage();
}

class Logincontroll extends Logincontroller {

  LoginData loginData = LoginData(Get.find());
  MyServices myServices = Get.find();
  GlobalKey<FormState> formstate = GlobalKey<FormState>();
  StatusRequest? statusRequest;

  final box = GetStorage();


  bool isshowpassword = true;

  late TextEditingController email;
  late TextEditingController password;

  showpassword() {
    isshowpassword = !isshowpassword;
    update();
  }

  @override
  Login() async {

    var formdata = formstate.currentState;
    if (formdata!.validate()) {
      statusRequest = StatusRequest.loading;
      update();

      var response = await loginData.postData(email.text, password.text);
      print("Response from login: $response");

      statusRequest = handlingData(response);

      if (StatusRequest.success == statusRequest) {
        if (response["status"] == null) {
          // الحصول على التوكن مباشرة
          String token = response["data"];
          await box.write('token', token);
          print("token is $token");
          // عرض رسالة ترحيب
          Get.snackbar("26".tr, "27".tr);
          goToHomePage();
        } else {
          print('Login failed: ${response["status"]}');
          statusRequest = StatusRequest.failure;
        }
      }

      update();
    } else {
      print('Form is not valid');
    }
  }

  void saveUserId(String user_id) {
    myServices.sharedPreferances.setString("id", user_id);
  }

  gotoRegister() {
    Get.toNamed(AppRoute.register);
  }

  @override
  void onInit() {
    email = TextEditingController();
    password = TextEditingController();
    super.onInit();
  }

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    super.dispose();
  }

  @override
  goToHomePage() {
    Get.offAllNamed(AppRoute.homePage);
  }
}
