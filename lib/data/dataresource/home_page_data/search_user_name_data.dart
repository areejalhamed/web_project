import 'dart:convert';
import 'package:get_storage/get_storage.dart';
import 'package:project/core/class/crud.dart';
import 'package:project/core/class/staterequest.dart';
import 'package:dartz/dartz.dart';

import '../../../applink.dart';

class SearchUserNameData {
  final Crud client;
  final box = GetStorage();

  SearchUserNameData(this.client);

  Future postMultipart(String name , int userId) async {
    String? token = box.read('token');
    print('Loaded token: $token');
    var headers = {
      'Accept': '*/*',
      'Authorization': 'Bearer $token',
    };
    var fields = {
      'name': name,
    };

    var response = await client.postMultipart(
      "${Applink.searchUsersName}/$userId",
      fields: fields,
      headers: headers,
    );

    return response;
  }
}
