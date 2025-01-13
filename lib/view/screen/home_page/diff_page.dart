import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controller/home_page_controller/export_csv_controller.dart';
import '../../../controller/home_page_controller/export_pdf_controller.dart';
import '../../../core/class/crud.dart';
import '../../../data/dataresource/home_page_data/export_csv_data.dart';
import '../../../data/dataresource/home_page_data/export_pdf_data.dart';

class DiffPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // استلام البيانات من الوسائط
    final String diff = Get.arguments?['diff'] ?? "No differences found.";
    final String newFileName = Get.arguments?['newFileName'] ?? "Unknown New File";
    final String oldFileName = Get.arguments?['oldFileName'] ?? "Unknown Old File";
    final String newFileDate = Get.arguments?['newFileDate'] ?? "Unknown Date";
    final String oldFileDate = Get.arguments?['oldFileDate'] ?? "Unknown Date";
    final int? groupId = Get.arguments?['groupId'] as int?;
    print("Received groupId: $groupId");

    if (groupId == null) {
      print("Warning: groupId is null.");
    }

    ExportPdfControllerImp exportPdfControllerImp = Get.put(ExportPdfControllerImp(ExportPdfData(Crud())));
    ExportCsvControllerImp exportCsvControllerImp = Get.put(ExportCsvControllerImp(ExportCsvData(Crud())));

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Comparison Result",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Section
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                elevation: 4,
                margin: const EdgeInsets.only(bottom: 16.0),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.file_present, color: Colors.teal, size: 28),
                          const SizedBox(width: 8),
                          Text("New File:", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(newFileName, style: const TextStyle(fontSize: 16)),
                      Text("Last Modified: $newFileDate", style: const TextStyle(fontSize: 14, color: Colors.grey)),
                      const Divider(),
                      Row(
                        children: [
                          const Icon(Icons.file_copy, color: Colors.orange, size: 28),
                          const SizedBox(width: 8),
                          Text("Old File:", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(oldFileName, style: const TextStyle(fontSize: 16)),
                      Text("Last Modified: $oldFileDate", style: const TextStyle(fontSize: 14, color: Colors.grey)),
                    ],
                  ),
                ),
              ),
              // Differences Section
              Text(
                "Differences:",
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.teal),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Text(
                  diff,
                  style: const TextStyle(
                    fontSize: 16,
                    fontFamily: 'monospace',
                    color: Colors.black87,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Footer with Export Actions
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      exportPdfControllerImp.exportFilePdf(groupId!); // تمرير groupId هنا
                    },
                    icon: const Icon(Icons.picture_as_pdf),
                    label: const Text("Export PDF"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      exportCsvControllerImp.exportFileCsv(groupId!); // تمرير groupId هنا
                    },
                    icon: const Icon(Icons.table_chart),
                    label: const Text("Export CSV"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

