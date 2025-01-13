import 'dart:html' as html;

import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

void downloadFileDirectly(String fileUrl) {
  try {
    print("Attempting to download file from: $fileUrl");

    // إنشاء رابط لتحميل الملف
    final anchor = html.AnchorElement(href: fileUrl)
      ..target = '_blank'
      ..download = fileUrl.split('/').last; // استخدام اسم الملف من الرابط
    anchor.click();

    print("File download initiated successfully.");
  } catch (e) {
    print("Error during file download: $e");
    Get.snackbar("Error", "Failed to download the file. Details: ${e.toString()}");
  }
}
