import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:project/data/dataresource/Auth/login.dart';
import '../../core/class/staterequest.dart';
import '../../core/constant/routes.dart';
import '../../core/function/handlingdata.dart';
import '../../core/services/services.dart';

abstract class Logincontroller extends GetxController{
  Login();
  gotoRegister();


}

class Logincontroll extends Logincontroller{


  LoginData loginData =LoginData(Get.find());
  MyServices myServices =Get.find();
  GlobalKey<FormState> formstate =GlobalKey<FormState>();
  StatusRequest? statusRequest ;
  bool isshowpassword =true;

  late TextEditingController email;
  late TextEditingController password;




  showpassword()
  {
    isshowpassword = isshowpassword == true ? false :true;
    update();

  }


  @override
  Login() async {
    var formdata = formstate.currentState;
    if(formdata!.validate())
    {
      statusRequest = StatusRequest.loading ;
      update();
      var response = await  loginData.postdata( email.text,password.text);
      print("-----------------------------controller file -----------------------");
      print(response);
      print('---------------------------------------------------------------------');
      statusRequest=handlingData(response);

      //لاتاكد من الشرط
      print('--------------------------1-----------------------------------');
      print("---$statusRequest------");
      print(response["status"]);
      print('--------------------------2-----------------------------------');


      if(StatusRequest.success == statusRequest)
      {
        if(response["status"] == null ){
          // افترض أن `userId` موجود في الاستجابة تحت المفتاح `user_id`
          String user_id = response['model']['id'].toString();

          // حفظ `userId` في SharedPreferences
          saveUserId(user_id);
          Get.toNamed(AppRoute.register);
        }
        else
        {  print('ffffffffffffffffffff');
           statusRequest = StatusRequest.failure;
        }
      }
      update();
    }

    else
    { print('gggggggg'); }
  }

  void saveUserId(String user_id) {
    myServices.sharedPreferances.setString("id", user_id);
  }


  gotoRegister() {
    Get.toNamed(AppRoute.register);
  }

  void onInit(){
    email = TextEditingController();
    password=TextEditingController();
    super.onInit();
  }



  void dispose(){
    email.dispose();
    password.dispose();
    super.dispose();
  }



  }


