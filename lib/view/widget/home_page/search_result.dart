import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controller/home_page_controller/search_group_controller.dart';

class SearchResults extends StatelessWidget {
  final SearchGroupControllerImp controller = Get.find<SearchGroupControllerImp>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      if (controller.searchResults.isEmpty) {
        return const Center(child: Text('لا توجد نتائج.'));
      }

      return ListView.separated(
        itemCount: controller.searchResults.length,
        itemBuilder: (context, index) {
          final group = controller.searchResults[index];
          return ListTile(
            leading: group['image'] != null
                ? Image.network(
              group['image'],
              width: 50,
              height: 50,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(Icons.group, size: 50, color: Colors.grey);
              },
            )
                : const Icon(Icons.group, size: 50, color: Colors.grey),
            title: Text(group['name'] ?? 'بدون اسم', style:const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text('ID: ${group['id'] ?? 'غير معروف'}', style:const TextStyle(fontSize: 12)),
            onTap: () {

              print("فتح تفاصيل المجموعة: ${group['name']}");
            },
            tileColor: index.isEven ? Colors.grey[200] : Colors.white,
          );
        },
        separatorBuilder: (context, index) =>const Divider(color: Colors.grey),
      );
    });
  }
}
