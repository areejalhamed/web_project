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
                // Header ..
                Container(
                  padding: const EdgeInsets.all(16.0),
                  color: Theme.of(context).colorScheme.primary,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "47".tr,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.background,
                        ),
                      ),
                      Row(
                        children: [
                          TextButton(
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(19),
                                color: Theme.of(context).colorScheme.tertiary,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "53".tr,
                                  style: TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .background,
                                  ),
                                ),
                              ),
                            ),
                            onPressed: () {
                              Get.toNamed(AppRoute.getAllUser);
                            },
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.refresh,
                              color: Theme.of(context).colorScheme.background,
                            ),
                            onPressed: () {
                              groupController.getGroup();
                            },
                          ),
                          const SizedBox(width: 8.0),
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
                  child: Searchpage(),
                ),
                // body ..
                Expanded(
                  child: Obx(() {
                    if (groupController.statusRequest.value ==
                        StatusRequest.loading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (groupController.groups.isEmpty) {
                      return const Center(
                          child: Text(''));
                    } else {
                      return GridView.builder(
                        padding: const EdgeInsets.all(16.0),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4, // عدد الأعمدة
                          crossAxisSpacing: 16.0, // المسافة الأفقية بين الأعمدة
                          mainAxisSpacing: 16.0, // المسافة العمودية بين الصفوف
                          childAspectRatio: 3 / 2, // نسبة العرض إلى الارتفاع لكل عنصر
                        ),
                        itemCount: groupController.groups.length,
                        itemBuilder: (context, index) {
                          final group = groupController.groups[index];
                          if (group == null) {
                            return const SizedBox();
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
                                // صورة المجموعة
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8.0),
                                  child: (group['image'] != null &&
                                      Uri.tryParse(group['image'])?.isAbsolute == true)
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
                                        // معالجة الخطأ عند عدم وجود معرف المجموعة
                                        Get.snackbar(
                                          '28'.tr,
                                          '',
                                          backgroundColor: Colors.red,
                                          colorText: Colors.white,
                                        );
                                        return;
                                      }

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
                                      overflow: TextOverflow.ellipsis, // قص النص إذا كان طويلاً
                                    ),
                                  ),
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
