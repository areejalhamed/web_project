import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PdfViewerScreen extends StatefulWidget {
  final String pdfPath;

  const PdfViewerScreen({Key? key, required this.pdfPath}) : super(key: key);

  @override
  _PdfViewerScreenState createState() => _PdfViewerScreenState();
}

class _PdfViewerScreenState extends State<PdfViewerScreen> {
  late String localFilePath;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    downloadFile(widget.pdfPath);
  }

  Future<void> downloadFile(String url) async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final tempDir = await getTemporaryDirectory();
        final file = File("${tempDir.path}/temp_file.pdf");
        await file.writeAsBytes(response.bodyBytes);
        setState(() {
          localFilePath = file.path;
          isLoading = false;
        });
      } else {
        throw Exception("Failed to download file. Status: ${response.statusCode}");
      }
    } catch (e) {
      print("Error downloading file: $e");
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
    return Scaffold(
      appBar: AppBar(
        title: const Text("View PDF"),
        backgroundColor: Colors.blue,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SfPdfViewer.file(File(localFilePath)),
    );
  }
}
