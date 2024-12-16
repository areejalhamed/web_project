import 'dart:io';

import 'package:flutter/foundation.dart';  // لاستخدام kIsWeb
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:html' as html;  // لاستخدام مكتبة HTML على الويب
import 'dart:typed_data';
import '../../data/dataresource/home_page_data/download_file_data.dart';

abstract class DownloadFileController extends GetxController {
  Future<void> downloadAndSaveFile(int fileId);
}

class DownloadFileControllerImp extends DownloadFileController {
  final DownloadFileData downloadFileData;

  DownloadFileControllerImp(this.downloadFileData);

  @override
  Future<void> downloadAndSaveFile(int fileId) async {
    try {
      final Uint8List? fileData = await downloadFileData.getFile(fileId);

      if (fileData == null) {
        Get.snackbar("Error", "Failed to download the file.");
        return;
      }

      if (kIsWeb) {
        // إذا كانت البيئة هي الويب، استخدم html لحفظ الملف
        _saveFileToWeb(fileData, fileId);
      } else {
        // إذا كانت البيئة ليست ويب، استخدم path_provider لحفظ الملف
        final directory = await getSaveDirectory();
        final filePath = "${directory.path}/downloaded_file_$fileId.pdf";

        final file = File(filePath);
        await file.writeAsBytes(fileData);

        Get.snackbar("Success", "File downloaded successfully to: $filePath");
        print("File saved at: $filePath");
      }
    } catch (e) {
      print("Error in saving file: $e");

      if (e is MissingPluginException) {
        Get.snackbar("Error", "Platform-specific plugin not initialized. Please rebuild the app.");
      } else {
        Get.snackbar("Error", "An error occurred while saving the file.");
      }
    }
  }

  // هذه الدالة تستخدم لتحميل الملف في الويب باستخدام html
  void _saveFileToWeb(Uint8List fileData, int fileId) {
    final blob = html.Blob([fileData]);
    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor = html.AnchorElement(href: url)
      ..target = 'blank'
      ..download = "downloaded_file_$fileId.pdf"
      ..click();
    html.Url.revokeObjectUrl(url); // إزالة الرابط بعد استخدامه
  }

  // دالة لحفظ الملفات في أنظمة أخرى (غير الويب)
  Future<Directory> getSaveDirectory() async {
    try {
      return await getApplicationDocumentsDirectory();
    } catch (e) {
      return await getTemporaryDirectory();
    }
  }
}
