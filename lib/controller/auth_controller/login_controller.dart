import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:project/data/dataresource/Auth/login.dart';
import '../../core/class/staterequest.dart';
import '../../core/constant/color.dart';
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
      print("-----------------------------controller file --------------------");
      print('response : $response');
      statusRequest = handlingData(response);
      print("statusRequest : $statusRequest------");
      print('------------------------------------------------------------------');

      if (StatusRequest.success == statusRequest) {
        if (response["success"] == true) {
          // الحصول على التوكن مباشرة
          String token = response["data"]["token"];
          await box.write('token', token);
          print("token is $token");
          Get.snackbar("Welcome", "Your account has been logged in successfully");
          goToHomePage();
        }
      }
      else {
        Get.defaultDialog(
            title: "Warning",
            backgroundColor: fourBackColor,
            middleText: " invalid email or incorrect password "

        );
        statusRequest = StatusRequest.failure;
      }
      update();
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
  void goToHomePage() {
    Get.offNamed(AppRoute.homePage);
  }
}
