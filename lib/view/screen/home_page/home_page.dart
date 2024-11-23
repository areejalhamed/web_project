import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project/core/constant/routes.dart';
import 'package:project/view/screen/home_page/view_Group.dart';
import 'package:project/view/widget/home_page/Search.dart';
import '../../../controller/home_page_controller/get_group_controller.dart';
import '../../../controller/home_page_controller/search_group_controller.dart';
import '../../../core/class/crud.dart';
import '../../../core/class/staterequest.dart';
import '../../../core/constant/color.dart';
import '../../../core/local/local_controller.dart';
import '../../../data/dataresource/home_page_data/get_group_data.dart';
import '../../../data/dataresource/home_page_data/search_group_data.dart';
import '../../widget/home_page/list_title.dart';
import 'drawer.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {


  // final SearchGroupControllerImp searchController = Get.put(SearchGroupControllerImp(SearchGroupData(Crud())));
  final GetAllGroupControllerImp groupController = Get.put(GetAllGroupControllerImp(GetAllGroupData(Crud())));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: <Widget>[
          Drawerpage(),
          Expanded(
            child: Column(
              children: [
                // Header ..
                Container(
                  padding: const EdgeInsets.all(16.0),
                  color: sevenBackColor,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "47".tr,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Row(
                        children: [
                          TextButton(
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(19),
                                color: secondBackColor,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: const Text("GetAllUser" , style: TextStyle(color: white),),
                              ),
                            ),
                            onPressed: () {
                              Get.toNamed(AppRoute.getAllUser);
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.refresh, color: Colors.white),
                            onPressed: () {
                              groupController.getGroup();
                            },
                          ),
                          const SizedBox(width: 8.0),
                          PopupMenuButton<String>(
                            icon: const Icon(Icons.language, color: Colors.white),
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
                                child: Text('49'.tr),
                              ),
                               PopupMenuItem(
                                value: 'en',
                                child: Text('48'.tr),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // search ..
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child :  Searchpage(),
                ),
                // body ..
                Expanded(
                  child: Obx(() {
                    if (groupController.statusRequest.value == StatusRequest.loading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (groupController.groups.isEmpty) {
                      return const Center(child: Text('لا توجد نتائج متطابقة.'));
                    } else {
                      return ListView.builder(
                        itemCount: groupController.groups.length,
                        itemBuilder: (context, index) {
                          final group = groupController.groups[index];

                          return Container(
                            margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                            padding: const EdgeInsets.all(12.0),
                            decoration: BoxDecoration(
                              color: green,
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
                            child: Row(
                              children: [
                                // صورة المجموعة
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8.0),
                                  child: group['imageUrl'] != null
                                      ? Image.network(
                                    group['imageUrl'], // يجب أن يحتوي الكائن على 'imageUrl'
                                    height: 50,
                                    width: 50,
                                    fit: BoxFit.cover,
                                  )
                                      : Icon(
                                    Icons.group,
                                    size: 50,
                                    color: grey,
                                  ),
                                ),
                                const SizedBox(width: 16.0),
                                // اسم المجموعة
                                Expanded(
                                  child: Text(
                                    group['name'] ?? 'بدون اسم',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                // زر الانتقال إلى تفاصيل المجموعة
                                IconButton(
                                  icon: const Icon(Icons.arrow_forward_ios, color: Colors.black),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ViewGroup(
                                          groupName: group['name'] ?? 'بدون اسم',
                                          groupId: group['id'],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          );
                        },
                      );

                    }
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
