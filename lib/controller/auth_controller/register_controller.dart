import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:project/data/dataresource/Auth/register.dart';
import '../../core/class/staterequest.dart';
import '../../core/function/handlingdata.dart';



abstract class Registercontroller extends GetxController
{
  Register();
}
class Registercontroll extends Registercontroller {

  RegisterData registerData =RegisterData(Get.find());
  GlobalKey<FormState> formstate = GlobalKey<FormState>();
  StatusRequest? statusRequest ;
  bool isshowpassword = true;

  late TextEditingController name;
  late TextEditingController email;
  late TextEditingController password;



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
      print("-----------------------------controller file --------------------");
      print(response);
      print('-------------------------------------------------------------');
      statusRequest=handlingData(response);


      //لاتاكد من الشرط
      print('--------------------------1-----------------------------------');
      print("---$statusRequest------");
      print(response["status"]);
      print('--------------------------2-----------------------------------');



      if(StatusRequest.success == statusRequest)
      {
        if(response["status"] == null ){
          Get.defaultDialog( title: "Welcom" , middleText: " Your account has been registered successfully ");
        }
        else
        {  Get.defaultDialog(title: "warning" , middleText: "Username or Email Already Exists ");
           statusRequest = StatusRequest.failure;
           print("-----------$statusRequest---------");
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