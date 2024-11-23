import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:project/core/constant/routes.dart';
import '../../../controller/home_page_controller/add_group_controller.dart';
import '../../../core/constant/color.dart';
import '../../../core/function/validation.dart';
import '../auth/textformfiledauth.dart';

class ShowConfirmationDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Get.put(Client());

    return GetBuilder<AddGroupControllerImp>(
      builder: (addGroupController) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        backgroundColor: Colors.white,
        title: Text(
          '39'.tr,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xff0CD6C0),
          ),
        ),
        content: Form(
          key: addGroupController.formState,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Textformfieldauth(
                mycontroller: addGroupController.name,
                hinttext: '39'.tr,
                valid: (v) => validateinput(v!, 1 , 30),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: '39'.tr,
                  hintStyle: TextStyle(color: Colors.grey[600]),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              // GestureDetector(
              //   onTap: () async {
              //     await addGroupController.pickImage(); // استدعاء دالة اختيار الصورة
              //   },
              //   child: AbsorbPointer(
              //     child: Textformfieldauth(
              //       mycontroller: addGroupController.imageUrl,
              //       hinttext: 'ادخل رابط صورة المجموعة',
              //       valid: (v) {
              //         if (v!.isEmpty) {
              //           return 'يرجى إدخال رابط الصورة';
              //         }
              //         return null;
              //       },
              //       decoration: InputDecoration(
              //         filled: true,
              //         fillColor: Colors.white,
              //         hintText: 'ادخل رابط صورة المجموعة',
              //         hintStyle: TextStyle(color: Colors.grey[600]),
              //         border: OutlineInputBorder(
              //           borderRadius: BorderRadius.circular(8),
              //         ),
              //       ),
              //     ),
              //   ),
              // ),
              const SizedBox(height: 10),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Get.toNamed(AppRoute.homePage);
            },
            child: Text(
              '40'.tr,
              style: const TextStyle(
                color: Colors.grey,
              ),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: sevenBackColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () async {
              await addGroupController.addGroup(); // تنفيذ دالة إضافة المجموعة
            },
            child: Text(
              '41'.tr,
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
