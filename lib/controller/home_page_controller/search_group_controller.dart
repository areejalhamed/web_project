import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../data/dataresource/home_page_data/search_group_data.dart';

abstract class SearchGroupController extends GetxController{
  searchGroup();
}

class SearchGroupControllerImp extends SearchGroupController {


  late SearchGroupData searchGroupData;
  RxList<dynamic> searchResults = <dynamic>[].obs; // نتائج البحث
  RxBool isLoading = false.obs;
  late TextEditingController name;

  SearchGroupControllerImp(this.searchGroupData);

  @override
  void onInit() {
    super.onInit();
    name = TextEditingController(); // تهيئة المتغير هنا
  }

  @override
  void searchGroup() async {
    try {
      isLoading.value = true; // وضع مؤشر التحميل
      final response = await searchGroupData.postMultipart(name.text); // افتراضًا أن `apiService` هو الذي يرسل طلبات الـ API

      // التحقق إذا كانت الاستجابة ناجحة
      response.fold(
            (failure) {
          // التعامل مع الفشل
          print('فشل في استرجاع البيانات: $failure');
          searchResults.clear();
        },
            (data) {
          // في حالة النجاح، الوصول إلى البيانات
          if (data.containsKey('groups')) {
            searchResults.value = data['groups'];  // تحديث نتائج البحث
          } else {
            searchResults.clear();  // إذا لم توجد بيانات "groups"
          }
        },
      );
    } catch (e) {
      print("Error: $e");
    } finally {
      isLoading.value = false; // إخفاء مؤشر التحميل
    }
  }
}
