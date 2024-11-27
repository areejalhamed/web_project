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
  final GetAllGroupControllerImp groupController =
      Get.put(GetAllGroupControllerImp(GetAllGroupData(Crud())));


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: <Widget>[
          Drawerpage(),
          Expanded(
            child: Column(
              children: [
                // Header
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
                              Get.toNamed(AppRoute.getAllUser);
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
                // Search bar
                // Padding(
                //   padding: const EdgeInsets.all(16.0),
                //   child: SearchPage(
                //       onSearchChanged: (v){},
                //       controller: ), // البحث
                // ),
                // Body content
                Expanded(
                  child: Obx(() {
                    if (groupController.statusRequest.value == StatusRequest.loading) {
                      return const Center(child: CircularProgressIndicator()); // عرض مؤشر التحميل إذا كانت البيانات قيد التحميل
                    }

                    // عرض نتائج البحث إذا كانت موجودة
                    final results = groupController.searchResults;
                    final groups = results.isNotEmpty ? results : groupController.groups; // استخدام نتائج البحث أو البيانات الأصلية إذا كانت فارغة

                    if (groups.isEmpty) {
                      return const Center(child: Text('لا توجد مجموعات للعرض.')); // عرض رسالة إذا لم توجد نتائج
                    }

                    return GridView.builder(
                      padding: const EdgeInsets.all(16.0),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4, // عدد الأعمدة
                        crossAxisSpacing: 16.0, // المسافة بين الأعمدة
                        mainAxisSpacing: 16.0, // المسافة بين الصفوف
                        childAspectRatio: 3 / 2, // نسبة العرض إلى الارتفاع
                      ),
                      itemCount: groups.length,
                      itemBuilder: (context, index) {
                        final group = groups[index];
                        if (group == null) {
                          return const SizedBox(); // تجنب عرض عنصر فارغ
                        }

                        return Container(
                          padding: const EdgeInsets.all(12.0),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.tertiaryFixed,
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
                              // عرض صورة المجموعة أو أيقونة افتراضية
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
                              // اسم المجموعة
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
                                    overflow: TextOverflow.ellipsis, // تقليص النص في حال طوله
                                  ),
                                ),
                              ),
                              // زر الانضمام للمجموعة
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
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
