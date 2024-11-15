import 'dart:convert';
import 'package:get_storage/get_storage.dart';
import 'package:project/core/class/crud.dart';
import 'package:project/core/class/staterequest.dart';
import 'package:dartz/dartz.dart';

import '../../../applink.dart';

class AddGroupData {
  final Crud client;
  final box = GetStorage();

  AddGroupData(this.client);

  Future postMultipart(String name) async {
    String? token = box.read('token');
    print('Loaded token: $token');
    var headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };
    var fields = {
      'name': name,
    };

    // استدعاء دالة `postMultipart` مع تمرير الحقول والرؤوس
    var response = await client.postMultipart(
      Applink.addGroup,
      fields: fields,
      headers: headers,
    );

    return response;
  }
}
