import 'dart:html' as html;
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../core/class/staterequest.dart';
import '../../data/dataresource/home_page_data/export_pdf_data.dart';
abstract class ExportPdfController extends GetxController {
  Future<void> exportFilePdf(int groupId);
}

class ExportPdfControllerImp extends ExportPdfController {
  final ExportPdfData exportPdfData;
  StatusRequest? statusRequest;

  ExportPdfControllerImp(this.exportPdfData);

  @override
  Future<void> exportFilePdf(int groupId) async {
    statusRequest = StatusRequest.loading;
    update();

    try {
      // استدعاء API للحصول على رابط PDF
      var response = await exportPdfData.get(groupId);

      if (response != null && response['success'] == true) {
        String pdfPath = response['data'] ?? "";

        if (pdfPath.isNotEmpty) {
          String fileUrl = "http://127.0.0.1:8000${pdfPath}";
          downloadFile(fileUrl, "report_$groupId.pdf", "application/pdf");
        } else {
          Get.snackbar("Error", "PDF path is empty!");
        }
      }}
    catch (e) {
      print("Error occurred: $e");
      Get.snackbar("Error", "An unexpected error occurred: $e");
      statusRequest = StatusRequest.failure;
    } finally {
      update();
    }
  }

  void downloadFile(String fileUrl, String fileName, String mimeType) async {
    try {
      final token = GetStorage().read('token'); // احصل على التوكن من التخزين
      if (token == null) {
        throw Exception("Authentication token is missing.");
      }

      print("Attempting to download file from: $fileUrl");

      // إرسال طلب الملف
      final response = await html.HttpRequest.request(
        fileUrl,
        method: 'GET',
        requestHeaders: {
          'Authorization': 'Bearer $token', // إضافة التوكن للمصادقة
          'Accept': '*/*', // التأكد من قبول كل أنواع الملفات
        },
        responseType: 'blob',
      );

      // إنشاء رابط التنزيل
      final blob = response.response; // الحصول على البيانات كـ Blob
      final url = html.Url.createObjectUrlFromBlob(blob); // إنشاء رابط لتحميل الملف

      // إنشاء عنصر HTML لتنزيل الملف
      final anchor = html.AnchorElement(href: url)
        ..target = 'blank'
        ..download = fileName;
      anchor.click();

      // تحرير الرابط
      html.Url.revokeObjectUrl(url);
      print("File download initiated successfully.");
    } catch (e) {
      print("Error during file download: $e");
      Get.snackbar("Error", "Failed to download the file. Details: ${e.toString()}");
    }
  }
}
