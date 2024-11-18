import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:project/core/constant/color.dart';
import 'package:project/core/function/validation.dart';
import 'package:project/view/widget/auth/textformfiledauth.dart';
import '../../../controller/auth_controller/login_controller.dart';
import '../../widget/auth/materialbuttonauth.dart';
import '../../widget/auth/row.dart';


class Loginpage extends StatelessWidget {
  Logincontroll controller = Get.put(Logincontroll());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: white,
        body: Container(
          decoration:const  BoxDecoration(
              image: DecorationImage(
                  fit: BoxFit.fill,
                  image: AssetImage('assets/images/register1.png') )),
          child: Padding(
              padding: const EdgeInsets.only(top: 50, bottom: 50, right: 200, left: 200),
              child: Form(
                key: controller.formstate,
                child: GetBuilder<Logincontroll>(
                  builder: (controller) =>Container(
                      color: sevenBackColor,
                      child: Container(
                        padding: const EdgeInsets.only(top: 50, right: 150 , left: 150),
                        decoration: const BoxDecoration(
                            color: white,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(200),
                                topRight: Radius.circular(200),)),
                        child: Column(
                          children: [
                             Text(
                              "3".tr,
                              style:const TextStyle(
                                fontSize: 35,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                             Text(
                              '4'.tr,
                              style:const TextStyle(fontSize: 20),
                            ),
                            const SizedBox(
                              height: 80,
                            ),
                            Textformfieldauth(
                              mycontroller: controller.email,
                              valid: (value) {
                                return validateinput(value!, 2, 30);
                              },
                              hinttext: '1'.tr,
                              iconDataprefix: Icons.email,
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Textformfieldauth(
                              mycontroller: controller.password,
                              valid: (value) {
                                return validateinput(value!, 6, 30);
                              },
                              obscuretext: controller.isshowpassword,
                              onTapicon: () {
                                controller.showpassword();
                              },
                              hinttext: '2'.tr,
                              iconDataprefix: Icons.lock,
                              iconDatasuffix: controller.isshowpassword
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            const SizedBox(
                              height: 50,
                            ),
                            MaterialButtonAuth(
                              text: '5'.tr,
                              onPressed: () {
                                controller.Login();
                              },
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            Rowauth(
                                text1: "6".tr,
                                onTap: () {
                                  controller.gotoRegister();},
                                text2: '7'.tr),
                          ],
                        ),
                      )),
                  ),
                ),
              ),
        ));
  }
}
