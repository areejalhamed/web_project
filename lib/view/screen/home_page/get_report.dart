import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project/data/dataresource/home_page_data/get_user_data.dart';
import '../../../controller/home_page_controller/get_report_controller.dart';
import '../../../core/class/crud.dart';
import '../../../core/class/staterequest.dart';
import '../../../core/constant/color.dart';
import '../../../data/dataresource/home_page_data/get_report_dara.dart';

class GetReport extends StatelessWidget {
  final int groupId;

  GetReport({super.key, required this.groupId});

  @override
  Widget build(BuildContext context) {
    final GetReportControllerImp getReportControllerImp = Get.put(GetReportControllerImp(GetReportData(Crud()) , groupId));

    return Scaffold(
      appBar: AppBar(
        backgroundColor: sevenBackColor,
        title: const Text(
          'Reports',
          style: TextStyle(fontSize: 18),
        ),
      ),
      body: Obx(() {
        if (getReportControllerImp.statusRequest.value == StatusRequest.loading) {
          return const Center(child: CircularProgressIndicator());
        } else if (getReportControllerImp.statusRequest.value == StatusRequest.failure) {
          return Center(
            child: TextButton(
              onPressed: () {
                getReportControllerImp.getUser(groupId);
              },
              child: const Text("Error loading reports. Retry?"),
            ),
          );
        } else if (getReportControllerImp.users.isNotEmpty) {
          return ListView.builder(
            itemCount: getReportControllerImp.users.length,
            itemBuilder: (context, index) {
              final report = getReportControllerImp.users[index];
              return Container(
                margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: secondBackColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListTile(
                  leading: const Icon(Icons.report, color: sevenBackColor),
                  title: Text(
                    "Report ID: ${report['id']}",
                    style: const TextStyle(color: sixBackColor),
                  ),
                  subtitle: Text(
                    "File ID: ${report['file_id']} | Group ID: ${report['group_id']}",
                    style: const TextStyle(color: sixBackColor),
                  ),
                  onTap: () {
                    print("Selected Report: ${report['id']}");
                  },
                ),
              );
            },
          );
        } else {
          return const Center(
            child: Text("No reports available for this group."),
          );
        }
      }),
    );
  }
}
