import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controller/auth_controller/register_controller.dart';
import '../../../core/constant/color.dart';
import '../../../core/function/validation.dart';
import '../../widget/auth/materialbuttonauth.dart';
import '../../widget/auth/row.dart';
import '../../widget/auth/textformfiledauth.dart';

class Registerpage extends StatelessWidget {
  Registercontroll controller = Get.put(Registercontroll());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      body: Container(
          decoration: const BoxDecoration(
              image: DecorationImage(
                  fit: BoxFit.fill,
                  image: AssetImage('assets/images/register1.png'))),
          child: Padding(
            padding: const EdgeInsets.only(
                top: 50, bottom: 50, right: 200, left: 200),
            child: Form(
                key: controller.formstate,
                child: GetBuilder<Registercontroll>(
                  builder: (controller) => Container(
                    padding:
                        const EdgeInsets.only(top: 50, right: 150, left: 150),
                    decoration: const BoxDecoration(
                        color: fourBackColor,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(200),
                          topRight: Radius.circular(200),
                        )),
                    child: Column(
                      children: [
                         Text(
                          '8'.tr,
                          style:const TextStyle(
                            fontSize: 35,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Rowauth(
                            text1: "9".tr,
                            onTap: () {
                              controller.goToLogin();
                            },
                            text2: '5'.tr),
                        const SizedBox(
                          height: 60,
                        ),
                        Textformfieldauth(
                          valid: (value) {
                            return validateinput(value!, 2, 30);
                          },
                          mycontroller: controller.name,
                          hinttext: '10'.tr,
                          iconDataprefix: Icons.person,
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Textformfieldauth(
                          valid: (value) {
                            return validateinput(value!, 2, 30);
                          },
                          mycontroller: controller.email,
                          hinttext: '1'.tr,
                          iconDataprefix: Icons.email,
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Textformfieldauth(
                          valid: (value) {
                            return validateinput(value!, 6, 30);
                          },
                          mycontroller: controller.password,
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
                          text: '7'.tr,
                          onPressed: () {
                            controller.register();
                          },
                        ),
                      ],
                    ),
                  ),
                )),
          )),
    );
  }
}
