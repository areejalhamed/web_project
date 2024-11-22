import 'dart:io';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import '../../../core/constant/color.dart';

class PdfViewerScreen extends StatelessWidget {
  final String pdfPath;

  const PdfViewerScreen({Key? key, required this.pdfPath}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("View PDF"),
        backgroundColor: sevenBackColor,
      ),
      body: Container(
        color: Colors.red ,
        child: SfPdfViewer.file(
          File(pdfPath),
          onDocumentLoadFailed: (PdfDocumentLoadFailedDetails details) {
            debugPrint('Failed to load document: ${details.error}');
          },
        ),

      ),
    );
  }
}
