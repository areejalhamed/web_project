import 'dart:async';
import 'dart:html' as html;
import 'dart:io';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:project/controller/home_page_controller/add_file_to_group_controller.dart';
import 'package:project/data/dataresource/home_page_data/get_report_dara.dart';
import '../../../controller/home_page_controller/check_in_controller.dart';
import '../../../controller/home_page_controller/check_out_file_controller.dart';
import '../../../controller/home_page_controller/delete_file_controller.dart';
import '../../../controller/home_page_controller/delete_group_controller.dart';
import '../../../controller/home_page_controller/download_file_controller.dart';
import '../../../controller/home_page_controller/get_file_from_group_controller.dart';
import '../../../controller/home_page_controller/get_report_controller.dart';
import '../../../controller/home_page_controller/leave_group_controller.dart';
import '../../../controller/home_page_controller/update_file_controller.dart';
import '../../../core/class/crud.dart';
import '../../../core/class/staterequest.dart';
import '../../../core/constant/color.dart';
import '../../../data/dataresource/home_page_data/get_file_from_group_data.dart';
import '../../../data/dataresource/home_page_data/leave_group_data.dart';
import '../../widget/home_page/view_pdf.dart';
import 'get_report.dart';
import 'get_user_all.dart';
import 'get_user_all_in_system.dart';
// import 'dart:typed_data';


class ViewGroup extends StatelessWidget {
  final String groupName;
  final int groupId;

  final AddFileToGroupControllerImp controller =
  Get.put(AddFileToGroupControllerImp(Get.find()));

  final UpdateFileControllerImp updateFileControllerImp = Get.find<UpdateFileControllerImp>();

  final RxList<int> filesId = <int>[].obs;

  ViewGroup({super.key, required this.groupName, required this.groupId});

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() =>
        GetFileFromGroupControllerImp(GetFileFromGroupData(Crud()), groupId));
        Get.lazyPut(() => GetReportControllerImp(GetReportData(Crud()) , groupId));

    final GetFileFromGroupControllerImp getFileFromGroupControllerImp =
    Get.find<GetFileFromGroupControllerImp>();
    final DeleteFileControllerImp deleteFileControllerImp =
    Get.find<DeleteFileControllerImp>();
    final CheckInControllerImp checkInControllerImp =
    Get.find<CheckInControllerImp>();
    final DeleteGroupControllerImp deleteGroupControllerImp =
    Get.find<DeleteGroupControllerImp>();
    final GetReportControllerImp getReportControllerImp =
    Get.find<GetReportControllerImp>();
    final CheckOutFileControllerImp checkOutFileControllerImp =
    Get.find<CheckOutFileControllerImp>();

    // final UpdateFileControllerImp updateFileControllerImp = Get.find<UpdateFileControllerImp>();
    final DownloadFileControllerImp downloadFileControllerImp = Get.find<DownloadFileControllerImp>();

    final GetStorage box = GetStorage(); // جلب المستخدم المخزن

    return Scaffold(
      appBar: AppBar(
        backgroundColor: sevenBackColor,
        title: Text(
          "$groupName",
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: () {
              filesId.clear();
              getFileFromGroupControllerImp.getFile(groupId);
            },
          ),
          const SizedBox(width: 8.0),
          Container(
            padding: const EdgeInsets.all(8),
            color: sevenBackColor,
            child: TextButton(
              child: const Text(
                "Reserved",
                style: TextStyle(color: white),
              ),
              onPressed: () {
                checkInControllerImp.checkIn(filesId);
              },
            ),
          ),
          const SizedBox(width: 8.0),
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
                      Get.to(GetAllUserInSystem(
                          groupId: groupId)); // تمرير groupId
                    },
                    child: const Text("Add User"),
                  ),
                ),
                PopupMenuItem(
                  value: 'Delete Group',
                  child: TextButton(
                    onPressed: () {
                      deleteGroupControllerImp
                          .deleteGroup(groupId); // حذف المجموعة مباشرة
                    },
                    child: const Text("Delete Group"),
                  ),
                ),
                PopupMenuItem(
                  value: 'Leave Group',
                  child: TextButton(
                    onPressed: () {
                      final int? userId = box.read('id'); // قراءة userId
                      if (userId != null) {
                        final LeaveGroupControllerImp leaveController = Get.put(
                          LeaveGroupControllerImp(
                              leaveGroupData: LeaveGroupData(Crud())),
                        );
                        leaveController.leaveGroup(groupId, userId);
                        Get.back();
                      } else {
                        Get.snackbar("Error", "User ID is missing.");
                      }
                    },
                    child: const Text("Leave"),
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
      body: Column(
        children: [
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                await getFileFromGroupControllerImp.getFile(groupId);
              },
              child: Obx(() {
                if (getFileFromGroupControllerImp.statusRequest.value ==
                    StatusRequest.loading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (getFileFromGroupControllerImp.statusRequest.value ==
                    StatusRequest.failure) {
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
                      final fileId = file['id']; // افترض وجود ID لكل ملف
                      final fileName = file['name'] ?? '';
                      final filePath = "http://127.0.0.1:8000${file['path'] ?? ''}";
                      final statusTitle = file['status']?['title'] ?? 'Unknown Status';
                      return ListTile(
                        title: Text(fileName),
                        subtitle: Text('$statusTitle',
                            style: const TextStyle(color: Colors.green)),
                        leading:
                        const Icon(Icons.picture_as_pdf, color: Colors.red),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Obx(() {
                              final isSelected = filesId.contains(fileId);
                              return Checkbox(
                                value: isSelected,
                                onChanged: (value) {
                                  if (value == true && fileId != null) {
                                    filesId.add(fileId);
                                  } else {
                                    filesId.remove(fileId);
                                  }
                                },
                              );
                            }),
                            const SizedBox(width: 20),
                            TextButton(
                              onPressed: () {
                                final int? userId = box.read('id');
                                if (userId != null) {
                                  checkOutFileControllerImp.checkOutFile(
                                      fileId: fileId, userId: userId);
                                } else {
                                  Get.snackbar("Error", "User ID is missing.");
                                }
                              },
                              child: const Text("check out"),
                            ),
                            const SizedBox(width: 20),
                            IconButton(
                              icon:const Icon(Icons.edit, color: Colors.orange),
                              onPressed: () => updateFileHandler(fileId),
                            ),
                            const SizedBox(width: 20),
                            IconButton(
                              icon: const Icon(Icons.arrow_circle_down_outlined, color: Colors.orange),
                              onPressed: () {
                                downloadFileControllerImp.downloadAndSaveFile(fileId);
                              },
                            ),

                          ],
                        ),
                        onTap: () {
                          print("File path tapped: $filePath");
                          Get.to(() => PdfViewerScreen(
                            pdfPath: filePath,
                            fileId: fileId,
                            groupId: groupId,
                          ));
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
                  child: const Icon(Icons.upload_file),
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

  Future<void> updateFileHandler(int fileId) async {
    var box = GetStorage();
    final int? userId = box.read('id'); // قراءة `userId`
    if (userId != null) {
      if (kIsWeb) {
        // رفع الملفات للويب
        html.FileUploadInputElement uploadInput = html.FileUploadInputElement();
        uploadInput.accept = '*/*';
        uploadInput.click();

        uploadInput.onChange.listen((event) async {
          final files = uploadInput.files;
          if (files != null && files.isNotEmpty) {
            final html.File file = files.first;

            // قراءة محتوى الملف
            final reader = html.FileReader();
            reader.readAsArrayBuffer(file);

            reader.onLoadEnd.listen((e) async {
              final fileBytes = reader.result as Uint8List;
              await updateFileControllerImp.updateFile(
                fileId: fileId,
                fileBytes: fileBytes,
                fileName: file.name,
              );
            });
          } else {
            Get.snackbar("No File Selected", "Please select a file to upload.");
          }
        });
      } else {
        // رفع الملفات للمنصات الأخرى
        final result = await FilePicker.platform.pickFiles(type: FileType.any);
        if (result != null && result.files.single.path != null) {
          final filePath = result.files.single.path!;
          final fileName = result.files.single.name;
          final fileBytes = await File(filePath).readAsBytes();
          await updateFileControllerImp.updateFile(
            fileId: fileId,
            fileBytes: fileBytes,
            fileName: fileName,
          );
        } else {
          Get.snackbar("No File Selected", "Please select a file to upload.");
        }
      }
    } else {
      Get.snackbar("Error", "User ID is missing.");
    }
  }


  // Future<File?> pickFile() async {
  //   if (kIsWeb) {
  //     // رفع الملفات للويب
  //     final html.FileUploadInputElement uploadInput = html.FileUploadInputElement();
  //     uploadInput.accept = '*/*'; // قبول جميع أنواع الملفات
  //     uploadInput.click();
  //
  //     final completer = Completer<Uint8List?>();
  //
  //     uploadInput.onChange.listen((event) {
  //       final files = uploadInput.files;
  //       if (files != null && files.isNotEmpty) {
  //         final html.File webFile = files.first;
  //
  //         // قراءة محتوى الملف كـ Uint8List
  //         final reader = html.FileReader();
  //         reader.readAsArrayBuffer(webFile);
  //
  //         reader.onLoadEnd.listen((event) {
  //           completer.complete(reader.result as Uint8List?);
  //         });
  //
  //         reader.onError.listen((error) {
  //           completer.completeError(error);
  //         });
  //       } else {
  //         completer.complete(null); // لم يتم اختيار ملف
  //       }
  //     });
  //
  //     final Uint8List? fileBytes = await completer.future;
  //
  //     if (fileBytes != null) {
  //       // يمكنك الآن استخدام البيانات مباشرة
  //       return File.fromRawPath(fileBytes); // هنا التعديل يعتمد على الطريقة التي تحتاجها
  //     } else {
  //       return null;
  //     }
  //   } else {
  //     // خاص بالمنصات الأخرى
  //     final result = await FilePicker.platform.pickFiles(type: FileType.any);
  //
  //     if (result != null && result.files.single.path != null) {
  //       return File(result.files.single.path!); // إرجاع الملف ككائن File
  //     }
  //     return null; // لم يتم اختيار ملف
  //   }
  // }

}