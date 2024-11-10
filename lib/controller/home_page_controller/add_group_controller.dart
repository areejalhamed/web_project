import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';
import '../../main.dart';

class AddGroupController extends GetxController {

  final nameController = TextEditingController().obs;
  RxBool loading = false.obs;

  final box = GetStorage();

  Future<void> addGroup() async {
    loading.value = true;
    String? token = box.read('token');

    if (token == null) {
      Get.snackbar('Error', 'Token is null');
      loading.value = false;
      return;
    }

    var request = http.MultipartRequest(
      'POST',
      Uri.parse('http://127.0.0.1:8000/api/addGroup'),
    );

    request.headers['Authorization'] = 'Bearer $token';
    request.fields['name'] = nameController.value.text;

    try {
      var response = await request.send();
      var responseBody = await http.Response.fromStream(response);

      print(response.statusCode);

      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.snackbar('Success', 'Group added successfully');
        await Future.delayed(Duration(seconds: 1)); // انتظر لمدة ثانية واحدة
        Get.back();
      } else {
        print('Status Code: ${response.statusCode}');
        print('Response Body: ${responseBody.body}');
        Get.snackbar('Error', 'Failed to add group');
      }
    } catch (e) {
      print('Exception: $e');
      Get.snackbar('Error', 'Failed to send request');
    } finally {
      loading.value = false;
    }
  }

}
