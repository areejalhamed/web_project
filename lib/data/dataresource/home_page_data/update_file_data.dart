import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';  // استيراد GetStorage
import '../../../applink.dart';

class UpdateFileData {
  Future<http.Response> postMultipart({
    required int fileId,
    Uint8List? fileBytes,
    String? filePath,
    required String fileName,
  }) async {
    const int userId = 3;
    final url = Uri.parse("${Applink.url}/files/$fileId/check-out/$userId");
    print("Request URL: $url");

    final token = _getToken();
    if (token == null) {
      throw Exception("Token is not available");
    }

    final request = http.MultipartRequest('POST', url);

    // إضافة headers الخاصة بالطلب مع التوكين
    request.headers.addAll({
      'Accept': '*/*',
      'Authorization': 'Bearer $token',  // إضافة التوكين هنا
    });

    // إذا كان الملف موجوداً كـ byte array
    if (fileBytes != null) {
      print("File bytes length: ${fileBytes.length}");
      request.files.add(http.MultipartFile.fromBytes(
        'file', // اسم الحقل الذي يتوقعه الخادم
        fileBytes,
        filename: fileName,
      ));
    }
    // إذا كان الملف موجوداً كـ path
    else if (filePath != null) {
      print("Using file path: $filePath");
      request.files.add(await http.MultipartFile.fromPath('file', filePath));
    }

    // طباعة headers الخاصة بالطلب
    print("Request headers: ${request.headers}");

    // إرسال الطلب
    final streamedResponse = await request.send();

    // استلام الاستجابة من الخادم
    final response = await http.Response.fromStream(streamedResponse);
    print("Response status: ${response.statusCode}");
    print("Response body: ${response.body}");

    return response;
  }

  // استرجاع التوكين من التخزين المحلي
  String? _getToken() {
    final storage = GetStorage();
    return storage.read('token');  // قراءة التوكين المخزن
  }
}
