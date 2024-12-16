import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import '../../../controller/home_page_controller/delete_file_controller.dart';
import '../../../core/constant/color.dart';
import '../../screen/home_page/get_report.dart';

class PdfViewerScreen extends StatefulWidget {
  final String pdfPath;
  final int fileId;
  final int groupId;

  const PdfViewerScreen({Key? key, required this.pdfPath, required this.fileId, required this.groupId})
      : super(key: key);

  @override
  _PdfViewerScreenState createState() => _PdfViewerScreenState(groupId: groupId);
}

class _PdfViewerScreenState extends State<PdfViewerScreen> {
  Uint8List? pdfBytes;
  bool isLoading = true;

  final int groupId;

  _PdfViewerScreenState({required this.groupId});

  @override
  void initState() {
    super.initState();
    loadPdf(widget.pdfPath);
  }

  Future<void> loadPdf(String url) async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        setState(() {
          pdfBytes = response.bodyBytes;
          isLoading = false;
        });
      } else {
        throw Exception("Failed to load PDF. Status: ${response.statusCode}");
      }
    } catch (e) {
      print("Error loading PDF: $e");
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('خطأ في تحميل الملف'),
          content: Text('حدث خطأ أثناء تحميل الملف: $e'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('موافق'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final DeleteFileControllerImp deleteFileControllerImp =
    Get.find<DeleteFileControllerImp>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: sevenBackColor,
        title: const Text("View PDF"),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.settings),
            itemBuilder: (context) {
              return [
                PopupMenuItem(
                  value: 'Delete File',
                  child: TextButton(
                    onPressed: () {
                      deleteFileControllerImp.deleteFile2(widget.fileId);
                      Get.back();
                    },
                    child: const Text("Delete File"),
                  ),
                ),
                PopupMenuItem(
                  value: 'View Report',
                  child: TextButton(
                    child: const Text("View Report"),
                    onPressed: () async {
                      print("groupId : $groupId");
                      Get.to(() => GetReport(groupId: groupId));
                    },
                  ),
                ),
              ];
            },
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : pdfBytes != null
          ? SfPdfViewer.memory(pdfBytes!)
          : const Center(child: Text("Failed to load PDF.")),
    );
  }
}
