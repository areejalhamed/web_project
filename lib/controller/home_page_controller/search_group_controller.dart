// import 'package:flutter/cupertino.dart';
// import 'package:get/get.dart';
// import '../../core/class/staterequest.dart';
// import '../../core/function/handlingdata.dart';
// import '../../data/dataresource/home_page_data/search_group_data.dart';
//
// abstract class SearchGroupController extends GetxController {
//   searchGroupByName();
// }
//
// class SearchGroupControllerImp extends SearchGroupController {
//
//   SearchGroupData searchGroupData;
//
//   GlobalKey<FormState> formState = GlobalKey<FormState>();
//   StatusRequest? statusRequest;
//   late TextEditingController name;
//   SearchGroupData g = SearchGroupData(Get.find());
//
//   SearchGroupControllerImp(this.searchGroupData);
//
//   @override
//   void onInit() {
//     name = TextEditingController();
//     super.onInit();
//   }
//
//   @override
//   Future<void> searchGroupByName() async {
//
//     var formData = formState.currentState;
//     if (formData != null && formData.validate()) {
//       statusRequest = StatusRequest.loading;
//       update();
//
//       try {
//         var response = await searchGroupData.postSearchGroup(name.text);
//         print("-----------------------------controller file --------------------");
//         print(response);
//         print('-------------------------------------------------------------');
//
//         statusRequest = handlingData(response);
//
//         if (statusRequest == StatusRequest.success) {
//           print("Response data: $response");
//           Get.snackbar("30".tr, "35".tr);
//         }
//       } catch (e) {
//         print("Error occurred: $e");
//         Get.snackbar("28".tr, "36".tr);
//         statusRequest = StatusRequest.failure;
//       } finally {
//         update();
//       }
//     } else {
//       print('Form is not valid');
//     }
//   }
//
//   @override
//   void dispose() {
//     name.dispose();
//     super.dispose();
//   }
//
// }
