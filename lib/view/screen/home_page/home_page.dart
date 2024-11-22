import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project/core/constant/routes.dart';
import 'package:project/view/screen/home_page/view_Group.dart';
import 'package:project/view/widget/home_page/Search.dart';
import '../../../controller/home_page_controller/get_group_controller.dart';
import '../../../core/class/crud.dart';
import '../../../core/class/staterequest.dart';
import '../../../core/constant/color.dart';
import '../../../core/local/local_controller.dart';
import '../../../data/dataresource/home_page_data/get_group_data.dart';
import '../../widget/home_page/list_title.dart';
import 'drawer.dart';

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
          //drawer
          Drawerpage(),
          Expanded(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Searchpage(),
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
