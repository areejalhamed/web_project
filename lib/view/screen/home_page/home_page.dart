import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project/applink.dart';
import 'package:project/core/constant/routes.dart';
import 'package:project/view/screen/home_page/view_Group.dart';
import '../../../controller/home_page_controller/get_group_controller.dart';
import '../../../core/class/crud.dart';
import '../../../core/class/staterequest.dart';
import '../../../core/constant/color.dart';
import '../../../core/local/local_controller.dart';
import '../../../data/dataresource/home_page_data/get_group_data.dart';
import '../../widget/home_page/list_title.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(GetAllGroupControllerImp(GetAllGroupData(Crud())));
    return Scaffold(
      body: Row(
        children: <Widget>[
          Container(
            width: 250,
            color: Colors.grey[200],
            child: Column(
              children: <Widget>[
                DrawerHeader(
                  decoration:const BoxDecoration(
                    color: sevenBackColor,
                  ),
                  child: SizedBox(
                    width: 250,
                    height: 75,
                    child: Text(
                      '11'.tr,
                      style:const TextStyle(
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
          Expanded(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: '15'.tr,
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
                  ),
                ),
                Expanded(
                  child: GetBuilder<GetAllGroupControllerImp>(
                    builder: (controller) {
                      if (controller.statusRequest == StatusRequest.loading) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (controller.statusRequest == StatusRequest.failure) {
                        return Center(child: Text('16'.tr));
                      } else if (controller.groups.isEmpty) {
                        return Center(child: Text('17'.tr));
                      } else {
                        return RefreshIndicator(
                          onRefresh: () async {
                            await controller.getGroup(); // Refreshes the group data
                          },
                          child: GridView.builder(
                            padding: const EdgeInsets.all(16.0),
                            itemCount: controller.groups.length,
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 4,
                              crossAxisSpacing: 16.0,
                              mainAxisSpacing: 16.0,
                              childAspectRatio: 3 / 2,
                            ),
                            itemBuilder: (context, index) {
                              var group = controller.groups[index];
                              return ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.all(16.0),
                                  backgroundColor: sevenBackColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ViewGroup(groupName: group['name'] ?? 'Unnamed Group', groupId: group['id'],),
                                    ),
                                  );
                                },
                                child: Center(
                                  child: Text(
                                    group['18'.tr] ?? '19'.tr,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              );

                            },
                          ),
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
