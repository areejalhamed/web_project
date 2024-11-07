import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:project/data/dataresource/register.dart';
import '../../core/class/staterequest.dart';
import '../../core/function/handlingdata.dart';



abstract class Registercontroller extends GetxController
{
  Register();
}
class Registercontroll extends Registercontroller {


  GlobalKey<FormState> formstate = GlobalKey<FormState>();
  late TextEditingController name;
  late TextEditingController email;
  late TextEditingController password;
  StatusRequest? statusRequest ;
  bool isshowpassword = true;
  RegisterData registerData =RegisterData(Get.find());

  showpassword() {
    isshowpassword = isshowpassword == true ? false : true;
    update();
  }

  @override
  Register() async {
    var formdataa = formstate.currentState;
    if(formdataa!.validate())
    {
      statusRequest = StatusRequest.loading ;
      update();
      var response = await  registerData.postdata( name.text , email.text , password.text );
      print("-----------------------------controller $response--------------------");
      statusRequest=handlingData(response);
      if(StatusRequest.success == statusRequest)
      {
        if(response["status"] == "Success" ){
         print('ssssssssssssssssssssssssssss');
        }
        else
        {  print('fffffffffffffffffffff');
        }
      }
      update();
    }

    else
    { print('gggggggg'); }
  }



  void onInit(){
    name = TextEditingController();
    email = TextEditingController();
    password=TextEditingController();
    super.onInit();
  }



  void dispose(){
    name.dispose();
    email.dispose();
    password.dispose();
    super.dispose();
  }


}