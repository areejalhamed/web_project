import 'dart:convert';
import 'dart:core';
import 'package:http/http.dart' as http;
import 'package:project/core/class/staterequest.dart';
import 'package:dartz/dartz.dart';


class Crud {
// Declare a global variable
  String? globalAuthorizationToken;

  Future<Either<StatusRequest, Map>> post(String url, Map data, Map<String, String> headers,) async {
    var response = await http.post(
      Uri.parse(url),
      body: data,
    );
    final headers = response.headers;
    print('Headers: $headers');
    final authorization = headers['authorization'];

    globalAuthorizationToken = authorization;
    print(globalAuthorizationToken);

    var responsebody = jsonDecode(response.body);
    print(responsebody);
    print("55555${response.statusCode}");
    if (response.statusCode == 200) {
      return Right(responsebody);
    } else if (response.statusCode == 400 || response.statusCode == 401) {
      return const Left(StatusRequest.serverfailure);
    } else {
      return const Left(StatusRequest.offlinefailure);
    }
  }

}