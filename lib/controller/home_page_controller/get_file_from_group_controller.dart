import 'package:get/get.dart';
import 'package:dartz/dartz.dart';
import '../../core/class/staterequest.dart';
import '../../core/function/handlingdata.dart';
import '../../data/dataresource/home_page_data/get_file_from_group_data.dart';

abstract class GetFileFromGroupController extends GetxController {
  Future<void> getFile(int groupId);
}

class GetFileFromGroupControllerImp extends GetFileFromGroupController {
  final GetFileFromGroupData getGroupData;

  // معرف المجموعة القابل للتحديث
  var groupId = 0.obs;

  var statusRequest = StatusRequest.loading.obs;
  var files = <Map<String, dynamic>>[].obs;

  GetFileFromGroupControllerImp(this.getGroupData, int initialGroupId) {
    groupId(initialGroupId); // تعيين المجموعة الأولى عند الإنشاء
  }

  @override
  void onInit() {
    super.onInit();
    // تحميل الملفات عند تغيير معرف المجموعة
    ever(groupId, (int groupId) {
      getFile(groupId);
    });

    // بدء التحميل للمجموعة الأولى
    getFile(groupId.value);
  }

  @override
  Future<void> getFile(int groupId) async {
    statusRequest(StatusRequest.loading);
    files.clear(); // مسح الملفات القديمة عند بدء تحميل جديد

    try {
      print("Fetching files for group ID: $groupId");
      var response = await getGroupData.get(groupId);
      print("Response: $response");

      statusRequest(handlingData(response));

      if (statusRequest.value == StatusRequest.success) {
        if (response.isRight()) {
          var data = response.getOrElse(() => <String, dynamic>{}) as Map<String, dynamic>;

          if (data.containsKey('data') && data['data'] is Map<String, dynamic>) {
            var groupData = data['data'] as Map<String, dynamic>;

            if (groupData.containsKey('files') && groupData['files'] is List) {
              List<dynamic> filesList = groupData['files'];

              files.assignAll(filesList.cast<Map<String, dynamic>>());
              print("Files loaded: ${files.length}");
            } else {
              print("No 'files' found or 'files' is not a list.");
              statusRequest(StatusRequest.failure);
            }
          } else {
            print("Invalid data structure or missing 'data' key.");
            statusRequest(StatusRequest.failure);
          }
        } else {
          print("Response is Left, failed to fetch.");
          statusRequest(StatusRequest.failure);
        }
      }
    } catch (e) {
      print("Error occurred: $e");
      statusRequest(StatusRequest.failure);
    }
  }

  // دالة لتحديث معرف المجموعة عند التبديل
  void changeGroupId(int newGroupId) {
    if (newGroupId != groupId.value) {
      groupId(newGroupId); // تحديث معرف المجموعة
    }
  }
}
