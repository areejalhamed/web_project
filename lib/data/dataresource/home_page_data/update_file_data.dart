import 'dart:typed_data';
import 'dart:html' as html; // خاص بالويب
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:project/core/class/crud.dart';
import '../../../applink.dart';

class UpdateFileData {
  Future<http.Response> postMultipart({
    required int fileId,
    required int userId,
    Uint8List? fileBytes,
    String? filePath,
    required String fileName,
  }) async {
    final url = Uri.parse("${Applink.url}/files/$fileId/check-out/$userId");
    final request = http.MultipartRequest('POST', url);

    if (fileBytes != null) {
      request.files.add(http.MultipartFile.fromBytes(
        'file',
        fileBytes,
        filename: fileName,
      ));
    } else if (filePath != null) {
      request.files.add(await http.MultipartFile.fromPath('file', filePath));
    }

    final streamedResponse = await request.send();
    return await http.Response.fromStream(streamedResponse);
  }
}
