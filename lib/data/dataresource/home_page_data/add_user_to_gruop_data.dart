import 'dart:convert';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import '../../../applink.dart';
import '../../../core/class/crud.dart';

class AddUserToGroupData {
  final Crud client;
  AddUserToGroupData(this.client);

  Future postMultipart(List<int> userIds, int groupId) async {
    String? token = GetStorage().read('token');
    var headers = {
      'Accept': '*/*',
      'Authorization': 'Bearer $token',
    };

    var fields = {
      'userIds': jsonEncode(userIds),  // إرسال المعرفات كقائمة أرقام
    };

    try {
      // إرسال الطلب
      var response = await client.postMultipart(
        "${Applink.url}/addUsersToGroup/$groupId",
        fields: fields,
        headers: headers,
      );

      // طباعة الاستجابة بالكامل لمعرفة نوعها
      print("Response received: $response");

      // تحقق من نوع الاستجابة
      if (response is String) {
        print("Response is a String: $response");
        return response;
      } else if (response is Map) {
        print("Response is a Map: $response");
        return response;
      } else {
        print("Unexpected response type.");
        return "Error: Unexpected response type.";
      }
    } catch (e) {
      print("Exception in post request: $e");
      return "Error: Exception occurred during request.";
    }
  }
}
