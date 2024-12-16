import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project/core/constant/routes.dart';
import 'package:project/data/dataresource/home_page_data/check_out_file_data.dart';
import 'package:project/data/dataresource/home_page_data/delete_file_data.dart';
import 'package:project/data/dataresource/home_page_data/download_file_data.dart';
import 'package:project/data/dataresource/home_page_data/get_report_dara.dart';
import 'package:project/data/dataresource/home_page_data/update_file_data.dart';
import 'package:project/view/screen/home_page/view_Group.dart';
import '../../../controller/home_page_controller/check_in_controller.dart';
import '../../../controller/home_page_controller/check_out_file_controller.dart';
import '../../../controller/home_page_controller/delete_file_controller.dart';
import '../../../controller/home_page_controller/download_file_controller.dart';
import '../../../controller/home_page_controller/get_group_controller.dart';
import '../../../controller/home_page_controller/get_report_controller.dart';
import '../../../controller/home_page_controller/search_user_name_controller.dart';
import '../../../controller/home_page_controller/update_file_controller.dart';
import '../../../core/class/crud.dart';
import '../../../core/class/staterequest.dart';
import '../../../data/dataresource/home_page_data/check_in_data.dart';
import '../../../data/dataresource/home_page_data/get_group_data.dart';
import '../../../data/dataresource/home_page_data/search_user_name_data.dart';
import 'drawer.dart';
import 'getalluserinsystem.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late int groupId;

  final GetAllGroupControllerImp groupController =
  Get.put(GetAllGroupControllerImp(GetAllGroupData(Crud())));

  final SearchUserNameControllerImp searchUserNameController =
  Get.put(SearchUserNameControllerImp(SearchUserNameData(Crud())));

  @override
  void initState() {
    super.initState();

    // Listen to the status of group fetching and initialize CheckInControllerImp dynamically for each group
    groupController.statusRequest.listen((status) {
      if (status == StatusRequest.success && groupController.groups.isNotEmpty) {
        // Loop through all the groups and initialize CheckInControllerImp dynamically
        for (var group in groupController.groups) {
          groupId = group['id']; // Get the group ID dynamically
          // Ensure that the controller is initialized for the group if not already
          if (!Get.isRegistered<CheckInControllerImp>()) {
            Get.put(CheckInControllerImp(CheckInData(Crud()), groupId));
            Get.lazyPut(() => GetReportControllerImp(GetReportData(Crud())));
            Get.lazyPut(()=>CheckOutFileControllerImp(CheckOutFileData(Crud())));
          }
          Get.lazyPut(()=>UpdateFileControllerImp(UpdateFileData()));
          // Get.lazyPut(()=>DownloadFileControllerImp());
        }
      }
    });
    Get.put(DeleteFileControllerImp(DeleteFileData(Crud())));
    Get.lazyPut(()=>DownloadFileControllerImp(DownloadFileData()));

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: <Widget>[
          Drawerpage(),
          Expanded(
            child: Column(
              children: [
                // Padding(
                //   padding: const EdgeInsets.all(8.0),
                //   child: SearchPage(
                //     onSearchChanged: (query) {
                //       searchUserNameController.searchUserName(query);
                //     },
                //     controller: searchUserNameController.name,
                //   ),
                // ),
                Container(
                  padding: const EdgeInsets.all(16.0),
                  color: Theme.of(context).colorScheme.primary,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "47".tr, // ترجمة النص
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.background,
                        ),
                      ),
                      Row(
                        children: [
                          // Button to navigate to "All User" page
                          TextButton(
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(19),
                                color: Theme.of(context).colorScheme.tertiary,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "53".tr, // ترجمة النص
                                  style: TextStyle(
                                    color: Theme.of(context).colorScheme.background,
                                  ),
                                ),
                              ),
                            ),
                            onPressed: () {
                              Get.to(const GetAllUserInSystem2());
                            },
                          ),
                          // Refresh button
                          IconButton(
                            icon: Icon(
                              Icons.refresh,
                              color: Theme.of(context).colorScheme.background,
                            ),
                            onPressed: () {
                              groupController.getGroup(); // تحديث البيانات
                            },
                          ),
                          const SizedBox(width: 8.0),
                          // Language selector
                          PopupMenuButton<String>(
                            icon: Icon(
                              Icons.language,
                              color: Theme.of(context).colorScheme.background,
                            ),
                            onSelected: (String value) {
                              if (value == 'ar') {
                                Get.updateLocale(const Locale('ar'));
                              } else if (value == 'en') {
                                Get.updateLocale(const Locale('en'));
                              }
                            },
                            itemBuilder: (BuildContext context) => [
                              PopupMenuItem(
                                value: 'ar',
                                child: Text('49'.tr), // ترجمة النص
                              ),
                              PopupMenuItem(
                                value: 'en',
                                child: Text('48'.tr), // ترجمة النص
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Obx(() {
                    if (groupController.statusRequest.value == StatusRequest.loading) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    // عرض نتائج البحث إذا كانت موجودة
                    final results = groupController.searchResults;
                    final groups = results.isNotEmpty ? results : groupController.groups;

                    if (groups.isEmpty) {
                      return const Center(child: Text('لا توجد مجموعات للعرض.'));
                    }

                    return GridView.builder(
                      padding: const EdgeInsets.all(16.0),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                        crossAxisSpacing: 16.0,
                        mainAxisSpacing: 16.0,
                        childAspectRatio: 3 / 2,
                      ),
                      itemCount: groups.length,
                      itemBuilder: (context, index) {
                        final group = groups[index];
                        if (group == null) {
                          return const SizedBox();
                        }

                        return Container(
                          padding: const EdgeInsets.all(12.0),
                          decoration: BoxDecoration(
                            //color: Theme.of(context).colorScheme.tertiaryFixed,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.3),
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: (group['image'] != null && Uri.tryParse(group['image'])?.isAbsolute == true)
                                    ? Image.network(
                                  group['image'],
                                  height: 100,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Icon(
                                      Icons.group,
                                      size: 50,
                                      color: Theme.of(context).colorScheme.background,
                                    );
                                  },
                                )
                                    : Icon(
                                  Icons.group,
                                  size: 50,
                                  color: Theme.of(context).colorScheme.background,
                                ),
                              ),
                              const SizedBox(height: 8.0),
                              Expanded(
                                child: InkWell(
                                  onTap: () {
                                    final groupName = group['name'] ?? 'بدون اسم';
                                    final groupId = group['id'];

                                    if (groupId == null) {
                                      Get.snackbar(
                                        '28'.tr,
                                        '',
                                        backgroundColor: Colors.red,
                                        colorText: Colors.white,
                                      );
                                      return;
                                    }

                                    // Ensure CheckInControllerImp is initialized before navigating to ViewGroup
                                    Get.put(CheckInControllerImp(CheckInData(Crud()), groupId)); // Ensure the controller is initialized

                                    // الانتقال إلى صفحة التفاصيل
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ViewGroup(
                                          groupName: groupName,
                                          groupId: groupId,
                                        ),
                                      ),
                                    );
                                  },
                                  child: Text(
                                    group['name'] ?? 'بدون اسم',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context).colorScheme.background,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: Icon(Icons.join_left, color: Theme.of(context).colorScheme.background),
                                onPressed: () {
                                  final groupId = group['id'];
                                  if (groupId == null) {
                                    print("معرف المجموعة غير موجود");
                                    return;
                                  }
                                  print("تم الانضمام إلى المجموعة بمعرف: $groupId");
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  }),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
