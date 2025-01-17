import 'dart:convert';
import 'package:get_storage/get_storage.dart';
import '../../../applink.dart';
import '../../../core/class/crud.dart';

class AddUserToGroupData {
  final Crud client;
  AddUserToGroupData(this.client);

  Future postMultipart(List<int> userIds, int groupId) async {
    String? token = GetStorage().read('token');
    if (token == null) {
      print("Error: Missing Authorization token.");
      return "Error: Unauthorized.";
    }

    var headers = {
      'Accept': '*/*',
      'Authorization': 'Bearer $token',
    };

    // إعداد الحقول بالطريقة المطلوبة
    Map<String, String> fields = {};
    for (int i = 0; i < userIds.length; i++) {
      fields['user_ids[$i]'] = userIds[i].toString(); // إضافة المعرفات بالتنسيق المطلوب
    }

    print("Token is $token");
    print("Sending fields: $fields");

    try {
      var response = await client.postMultipart(
        "${Applink.url}/addUsersToGroup/$groupId",
        fields: fields,
        headers: headers,
      );

      print("Response received: $response");

      // التحقق من نوع الاستجابة
      if (response is String) {
        try {
          var jsonResponse = jsonDecode(response as String);
          print("Decoded JSON response: $jsonResponse");
          return jsonResponse;
        } catch (e) {
          print("Failed to decode JSON: $e");
          return "Error: Invalid response format.";
        }
      } else {
        print("Unexpected response type: ${response.runtimeType}");
        return "Error: Unexpected response type.";
      }
    } catch (e) {
      print("Exception in post request: $e");
      return "Error: Exception occurred during request.";
    }
  }
}
