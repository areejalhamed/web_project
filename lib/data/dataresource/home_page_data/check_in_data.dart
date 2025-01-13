import 'dart:convert';
import 'package:get_storage/get_storage.dart';
import '../../../applink.dart';
import '../../../core/class/crud.dart';

class CheckInData {
  final Crud client;

  CheckInData(this.client);

  Future postMultipart(List<int> fileIds, int groupId) async {
    String? token = GetStorage().read('token');

    if (token == null) {
      print("Error: Missing Authorization token.");
      return {"status": "error", "message": "Unauthorized."};
    }

    var headers = {
      'Accept': '*/*',
      'Authorization': 'Bearer $token',
    };

    Map<String, String> fields = {
      'groupId': groupId.toString(),
    };

    for (int i = 0; i < fileIds.length; i++) {
      fields['file_ids[$i]'] = fileIds[i].toString();
    }

    print("Token: $token");
    print("Sending fields: $fields");

    try {
      var response = await client.postMultipart(
        "${Applink.url}/files/check-in",
        fields: fields,
        headers: headers,
      );

      print("Response received: $response");

      if (response is String) {
        try {
          var jsonResponse = jsonDecode(response as String);
          print("Decoded JSON response: $jsonResponse");
          return jsonResponse;
        } catch (e) {
          print("Failed to decode JSON: $e");
          return {"status": "error", "message": "Invalid response format."};
        }
      } else if (response is Map<String, dynamic>) {
        return response;
      } else {
        return {"status": "error", "message": "Unexpected response type."};
      }
    } catch (e) {
      print("Exception in post request: $e");
      return {"status": "error", "message": "Exception occurred during request."};
    }
  }
}
