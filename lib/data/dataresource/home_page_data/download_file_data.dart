import 'package:get_storage/get_storage.dart';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import '../../../applink.dart';

class DownloadFileData {
  Future<Uint8List?> getFile(int fileId) async {
    String? token = GetStorage().read('token');
    if (token == null) {
      throw Exception("Token not found in GetStorage.");
    }

    var headers = {
      'Authorization': 'Bearer $token',
      'Accept': '*/*',
    };

    try {
      var response = await http.get(Uri.parse('${Applink.url}/downloadFile/$fileId'), headers: headers);

      print("Response status: ${response.statusCode}");
      if (response.statusCode == 200) {
        return response.bodyBytes; // إرجاع البيانات كـ Byte Array
      } else {
        throw Exception("Failed to download file. Status: ${response.statusCode}");
      }
    } catch (e) {
      print("Error in get request: $e");
      return null;
    }
  }
}
