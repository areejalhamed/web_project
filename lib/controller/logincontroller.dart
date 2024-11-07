import 'package:flutter/cupertino.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

abstract class Logincontroller extends GetxController {
  Login();
}

class Logincontroll extends Logincontroller {
  GlobalKey<FormState> formstate = GlobalKey<FormState>();
  late TextEditingController email;

  late TextEditingController password;

  bool isshowpassword = true;

  showpassword() {
    isshowpassword = isshowpassword == true ? false : true;
    update();
  }

  Login() {
    var forms = formstate.currentState;
    if (forms!.validate()) {
      print('----------------------');
      update();
    }
  }

  void onInit() {
    email = TextEditingController();
    password = TextEditingController();
    super.onInit();
  }

  void dispose() {
    email.dispose();
    password.dispose();
    super.dispose();
  }
}
