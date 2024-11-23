import 'dart:async';
import 'dart:html' as html;
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project/controller/home_page_controller/add_file_to_group_controller.dart';
import '../../../controller/home_page_controller/get_file_from_group_controller.dart';
import '../../../core/class/crud.dart';
import '../../../core/class/staterequest.dart';
import '../../../core/constant/color.dart';
import '../../../data/dataresource/home_page_data/get_file_from_group_data.dart';
import '../../widget/home_page/view_pdf.dart';
import 'get_user_all.dart';

class ViewGroup extends StatelessWidget {
  final String groupName;
  final int groupId;
  final AddFileToGroupControllerImp controller =
      Get.put(AddFileToGroupControllerImp(Get.find()));

  ViewGroup({super.key, required this.groupName, required this.groupId});

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() =>
        GetFileFromGroupControllerImp(GetFileFromGroupData(Crud()), groupId));

    final GetFileFromGroupControllerImp getFileFromGroupControllerImp =
        Get.find<GetFileFromGroupControllerImp>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: sevenBackColor,
        title: Text(
          groupName,
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.settings),
            itemBuilder: (context) {
              return [
                PopupMenuItem(
                  child: TextButton(
                    onPressed: () {
                      Get.to(GetAllUser(groupId: groupId));
                    },
                    child: const Text("All User"),
                  ),
                ),
                PopupMenuItem(
                  value: 'Add User',
                  child: TextButton(
                    onPressed: () {

                    },
                    child: const Text("Add User"),
                  ),
                ),
              ];
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                await getFileFromGroupControllerImp.getFile(groupId);
              },
              child: Obx(() {
                if (getFileFromGroupControllerImp.statusRequest.value == StatusRequest.loading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (getFileFromGroupControllerImp.statusRequest.value == StatusRequest.failure) {
                  return Center(
                    child: Text('حدث خطأ أثناء تحميل الملفات.'.tr),
                  );
                } else if (getFileFromGroupControllerImp.files.isEmpty) {
                  return Center(
                    child: Text('لا توجد ملفات متاحة.'.tr),
                  );
                } else {
                  return ListView.builder(
                    padding: const EdgeInsets.all(16.0),
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: getFileFromGroupControllerImp.files.length,
                    itemBuilder: (context, index) {
                      final file = getFileFromGroupControllerImp.files[index];
                      final fileName = file['name'] ?? ''; // اسم الملف
                      final filePath = "http://127.0.0.1:8000/storage/uploads/$fileName"; // المسار الكامل

                      return ListTile(
                        title: Text(fileName),
                        subtitle: Text(filePath),
                        leading: const Icon(Icons.picture_as_pdf, color: Colors.red),
                        onTap: () {
                          print("File path tapped: $filePath");
                          Get.to(() => PdfViewerScreen(pdfPath: filePath));
                        },
                      );
                    },
                  );
                }
              }),
            ),
          ),
          Container(
            color: grey,
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller.name,
                    decoration: InputDecoration(
                      labelText: "44".tr,
                      hintText: "44".tr,
                      border: const OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                FloatingActionButton(
                  onPressed: () => _handleFileUpload(),
                  child: Icon(Icons.upload_file),
                  tooltip: "45".tr,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _handleFileUpload() async {
    if (kIsWeb) {
      html.FileUploadInputElement uploadInput = html.FileUploadInputElement();
      uploadInput.accept = '*/*';
      uploadInput.click();

      uploadInput.onChange.listen((e) async {
        final files = uploadInput.files;
        if (files != null && files.isNotEmpty) {
          final file = files[0];
          controller.name.text = file.name;

          try {
            final webFileBytes = await readFileAsBytes(file);
            await controller.addFileToGroup(
                id: groupId, webFileBytes: webFileBytes);
            await Get.find<GetFileFromGroupControllerImp>().getFile(groupId);
          } catch (error) {
            Get.snackbar("Error", ": $error",
                backgroundColor: Colors.red, colorText: Colors.white);
          }
        } else {
          Get.snackbar("No file selected", "Please select a file to upload.",
              backgroundColor: Colors.orange, colorText: Colors.white);
        }
      });
    } else {
      Get.snackbar(
        "Unsupported Platform",
        "File upload is only supported on web.",
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
    }
  }

  Future<Uint8List> readFileAsBytes(html.File file) async {
    final reader = html.FileReader();
    final completer = Completer<Uint8List>();

    reader.readAsArrayBuffer(file);
    reader.onLoadEnd.listen((event) {
      completer.complete(reader.result as Uint8List);
    });

    reader.onError.listen((event) {
      completer.completeError(reader.error!);
    });

    return completer.future;
  }
}
