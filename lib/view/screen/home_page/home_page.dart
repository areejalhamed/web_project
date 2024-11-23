import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project/applink.dart';
import 'package:project/core/constant/routes.dart';
import 'package:project/view/screen/home_page/view_Group.dart';
import '../../../controller/home_page_controller/get_group_controller.dart';
import '../../../controller/home_page_controller/search_group_controller.dart';
import '../../../core/class/crud.dart';
import '../../../core/class/staterequest.dart';
import '../../../core/constant/color.dart';
import '../../../core/local/local_controller.dart';
import '../../../data/dataresource/home_page_data/get_group_data.dart';
import '../../../data/dataresource/home_page_data/search_group_data.dart';
import '../../widget/home_page/list_title.dart';

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
          // القائمة الجانبية
          Container(
            width: 250,
            color: Colors.grey[200],
            child: Column(
              children: <Widget>[
                DrawerHeader(
                  decoration: const BoxDecoration(
                    color: sevenBackColor,
                  ),
                  child: SizedBox(
                    width: 250,
                    height: 75,
                    child: Text(
                      '11'.tr,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                      ),
                    ),
                  ),
                ),
                ListTitleHomePage(
                  onTap: () {
                    Get.toNamed(AppRoute.showConfirmationDialog);
                  },
                  text: '12'.tr,
                  icon: const Icon(Icons.create_outlined),
                ),
                ListTitleHomePage(
                  onTap: () {},
                  text: '13'.tr,
                  icon: const Icon(Icons.settings),
                ),
                ListTitleHomePage(
                  onTap: () {},
                  text: '14'.tr,
                  icon: const Icon(Icons.info_outline_rounded),
                ),
                ListTitleHomePage(
                  onTap: () {
                    String currentLang = MyLocaleController.sharedPreferences?.getString("lang") ?? 'en';
                    String newLang = currentLang == 'en' ? 'ar' : 'en';
                    MyLocaleController.changeLanguage(newLang);
                    print("Language changed to: $newLang");
                  },
                  text: '34'.tr,
                  icon: const Icon(Icons.language),
                ),
              ],
            ),
          ),
          // المحتوى الرئيسي
          Expanded(
            child: Column(
              children: [
                // Header في الأعلى
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
                          // زر تغيير اللغة
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
                              const PopupMenuItem(
                                value: 'ar',
                                child: Text('العربية'),
                              ),
                              const PopupMenuItem(
                                value: 'en',
                                child: Text('English'),
                              ),
                            ],
                          ),
                          const SizedBox(width: 8.0),
                          // زر التحديث
                          IconButton(
                            icon: const Icon(Icons.refresh, color: Colors.white),
                            onPressed: () {
                              groupController.getGroup();
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // شريط البحث
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child : TextField(
                 //   controller: searchController.name,
                    decoration: InputDecoration(
                      labelText: 'بحث'.tr,
                      prefixIcon: const Icon(Icons.search, color: fiveBackColor),
                      labelStyle: const TextStyle(color: fiveBackColor),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        borderSide: const BorderSide(color: fiveBackColor),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        borderSide: const BorderSide(color: sevenBackColor),
                      ),
                    ),
                    onChanged: (value) {
                   //   searchController.searchGroupByName(); // استدعاء البحث عند الكتابة
                    },
                  ),

                ),
               // النتائج
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
                              color: Colors.green[100],
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
                                      : const Icon(
                                    Icons.group,
                                    size: 50,
                                    color: Colors.grey,
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
