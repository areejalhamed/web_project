import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../controller/home_page_controller/add_group_controller.dart';
import '../../../core/function/validation.dart';
import '../auth/textformfiledauth.dart';
import 'package:get/get.dart';

class ShowConfirmationDialog extends StatelessWidget {

  final AddGroupController addGroupController = Get.put(AddGroupController());

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Enter Name Group'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Textformfieldauth(
            mycontroller: addGroupController.nameController.value,
            hinttext: 'Enter name',
            valid: (value) {
              return validateinput(value!, 6, 30);
            },
          ),
          const SizedBox(height: 10), // Add some spacing
          const Text('Are you sure you want to proceed?'),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            if (addGroupController.nameController.value.text.isNotEmpty) {
              addGroupController.addGroup();

            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Please enter a valid name')),
              );
            }
          },
          child: const Text('Add'),
        ),
      ],
    );
  }
}
