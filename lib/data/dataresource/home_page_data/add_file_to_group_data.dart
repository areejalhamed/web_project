import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import '../../../applink.dart';

class AddFileToGroupData {
  final box = GetStorage();

  Future<dynamic> postMultipart(int id, String name, {String? filePath, Uint8List? webFileBytes}) async {
    String? token = box.read('token');
    var uri = Uri.parse('${Applink.url}/groups/$id/files');
    var request = http.MultipartRequest('POST', uri);
    request.headers.addAll({
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });
    request.fields['name'] = name;

    if (filePath != null && File(filePath).existsSync()) {
      request.files.add(await http.MultipartFile.fromPath('file', filePath));
    } else if (webFileBytes != null) {
      request.files.add(http.MultipartFile.fromBytes('file', webFileBytes, filename: 'uploaded_file'));
    } else {
      throw Exception("File data is invalid.");
    }

    var response = await request.send();
    var responseBody = await http.Response.fromStream(response);

    if (response.statusCode == 200 || response.statusCode == 201) {
      print(response.statusCode);
      return jsonDecode(responseBody.body);
    } else {
      throw Exception("Error: ${response.statusCode}, ${responseBody.body}");
    }
  }
}
