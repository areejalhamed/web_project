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
          // Sidebar for navigation and options
          Container(
            width: 250,
            color: Colors.grey[200],
            child: Column(
              children: <Widget>[
                const DrawerHeader(
                  decoration: BoxDecoration(
                    color: sevenBackColor,
                  ),
                  child: SizedBox(
                    width: 250,
                    height: 75,
                    child: Text(
                      'My _ Account',
                      style: TextStyle(
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
                  text: 'Create a group',
                  icon: const Icon(Icons.create_outlined),

                ),
                ListTitleHomePage(
                  onTap: () {},
                  text: 'Setting',
                  icon: const Icon(Icons.settings),
                ),
                ListTitleHomePage(
                  onTap: () {},
                  text: 'About',
                  icon: const Icon(Icons.info_outline_rounded),
                ),
              ],
            ),
          ),
          // Main content for displaying groups in a grid format
          Expanded(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: 'Search ..',
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
                        return const Center(child: Text('Failed to load groups'));
                      } else if (controller.groups.isEmpty) {
                        return const Center(child: Text('No groups available'));
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
                                      builder: (context) => ViewGroup(groupName: group['name'] ?? 'Unnamed Group'),
                                    ),
                                  );
                                },
                                child: Center(
                                  child: Text(
                                    group['name'] ?? 'Unnamed Group',
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
