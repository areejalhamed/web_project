import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:project/core/class/staterequest.dart';
import 'package:project/core/function/handlingdata.dart';
import 'package:project/data/dataresource/home_page_data/add_groug_data.dart';
import 'package:image_picker/image_picker.dart';
import '../../core/constant/routes.dart';

abstract class AddGroupController extends GetxController {
  addGroup();
  pickImage();
}

class AddGroupControllerImp extends AddGroupController {

  AddGroupData groupData;
  GlobalKey<FormState> formState = GlobalKey<FormState>();
  StatusRequest? statusRequest;
  bool isShowPassword = true;
  late TextEditingController name;
  late TextEditingController imageUrl; // حقل لتخزين مسار الصورة
  late File? imageFile; // تخزين الصورة الملتقطة
  final picker = ImagePicker(); // كائن ImagePicker لاختيار الصور

  AddGroupControllerImp(this.groupData);

  @override
  void onInit() {
    name = TextEditingController();
    imageUrl = TextEditingController(); // تهيئة المتغير
    super.onInit();
  }


  @override
  Future<void> pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      imageFile = File(pickedFile.path); // حفظ الصورة الملتقطة
      imageUrl.text = pickedFile.path; // تعيين مسار الصورة في الحقل
      update(); // تحديث الواجهة
    } else {
      print("No image selected.");
    }
  }

  @override
  Future<void> addGroup() async {
    var formData = formState.currentState;
    if (formData != null && formData.validate()) {
      statusRequest = StatusRequest.loading;
      update();

      try {
        var response = await groupData.postMultipart(
            name.text, imageUrl.text); // إرسال الرابط أو المسار
        statusRequest = handlingData(response);

        if (statusRequest == StatusRequest.success) {
          Get.snackbar("30".tr, "35".tr);
          Get.toNamed(AppRoute.homePage);
        }
      } catch (e) {
        print("Error occurred: $e");
        Get.snackbar("28".tr, "36".tr);
        statusRequest = StatusRequest.failure;
      } finally {
        update();
      }
    } else {
      print('Form is not valid');
    }
  }

  @override
  void dispose() {
    name.dispose();
    imageUrl.dispose();
    super.dispose();
  }
}
