import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';
import '../../../applink.dart';

class AddFileToGroupData {
  final box = GetStorage();

  AddFileToGroupData();

  Future<dynamic> postMultipart(int id ,String name, {String? filePath, Uint8List? webFileBytes}) async {
    String? token = box.read('token');
    print('Loaded token: $token');

    var uri = Uri.parse('${Applink.url}/groups/$id/files');
    var request = http.MultipartRequest('POST', uri);
    request.headers.addAll({
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });
    request.fields['name'] = name;

    // اختيار طريقة تحميل الملف حسب البيئة
    if (filePath != null && File(filePath).existsSync()) {
      request.files.add(await http.MultipartFile.fromPath('file', filePath));
    } else if (webFileBytes != null) {
      request.files.add(http.MultipartFile.fromBytes('file', webFileBytes, filename: 'uploaded_file.pdf'));
    } else {
      print("File does not exist at the specified path or web file bytes are empty.");
      return null;
    }

    try {
      var response = await request.send();
      var responseBody = await http.Response.fromStream(response);

      if (response.statusCode == 200 || response.statusCode == 201) {
        var jsonResponse = jsonDecode(responseBody.body);
        print("Response: $jsonResponse");
        return jsonResponse;
      } else {
        print("Error: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("Exception in post request: $e");
      return null;
    }
  }
}
