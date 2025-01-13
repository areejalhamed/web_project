import 'dart:html' as html;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project/data/dataresource/home_page_data/compare_file_data.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import '../../../controller/home_page_controller/compare_file_controller.dart';
import '../../../controller/home_page_controller/delete_file_controller.dart';
import '../../../core/class/crud.dart';
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
  bool isLoading = true;

  final int groupId;

  _PdfViewerScreenState({required this.groupId});

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final DeleteFileControllerImp deleteFileControllerImp = Get.find<DeleteFileControllerImp>();
    CompareFileControllerImp compareFileControllerImp = Get.put(CompareFileControllerImp(CompareFileData(Crud())));

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
                  value: 'compare File',
                  child: TextButton(
                    onPressed: () {
                      compareFileControllerImp.compareFile(widget.fileId);
                    },
                    child: const Text("compare File"),
                  ),
                ),
              ];
            },
          ),
        ],
      ),
      body: SfPdfViewer.network(
        widget.pdfPath,
        onDocumentLoaded: (details) {
          setState(() {
            isLoading = false;
          });
          print("PDF loaded successfully!");
        },
        onPageChanged: (error) {
          setState(() {
            isLoading = false;
          });
          print("Error loading PDF: $error"); // تأكد من طباعة الخطأ
        },
      ),
    );
  }
}
