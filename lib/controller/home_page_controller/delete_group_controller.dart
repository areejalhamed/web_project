import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:project/core/constant/routes.dart';
import 'package:project/data/dataresource/home_page_data/delete_group_data.dart';
import '../../core/class/staterequest.dart';
import '../../core/function/handlingdata.dart';
import '../../data/dataresource/home_page_data/add_groug_data.dart';

abstract class DeleteGroupController extends GetxController {
  deleteGroup(int id);
}

class DeleteGroupControllerImp extends DeleteGroupController {
  DeleteGroupData deleteGroupData;
  StatusRequest? statusRequest;
  DeleteGroupControllerImp(this.deleteGroupData);

  @override
  Future<void> deleteGroup(int id) async {
    statusRequest = StatusRequest.loading;
    update();

    try {
      var response = await deleteGroupData.deleteGroup(id); // إرسال الطلب للحذف
      print("-----------------------------controller file --------------------");
      print(response);
      print('-------------------------------------------------------------');

      statusRequest = handlingData(response);

      if (statusRequest == StatusRequest.success) {
        print("Response data: $response");
        Get.snackbar("نجاح", "تم حذف المجموعة بنجاح");
        Get.toNamed(AppRoute.homePage);
      } else {
        print("فشل الحذف: $response");
        Get.snackbar("خطأ", "تعذر حذف المجموعة");
      }
    } catch (e) {
      print("حدث خطأ: $e");
      Get.snackbar("خطأ", "حدث خطأ أثناء الحذف");
      statusRequest = StatusRequest.failure;
    } finally {
      update();
    }
  }
}
