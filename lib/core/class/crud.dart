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
    print('----------------------------------------------------------------');
    print('globalAuthorizationToken: $globalAuthorizationToken');
    var responsebody = jsonDecode(response.body);
    print('responsebody: $responsebody');
    print("statusCode : ${response.statusCode}");
    print('----------------------------------------------------------------');

    if (response.statusCode == 200) {
      return Right(responsebody);
    }
    else if (response.statusCode == 400 || response.statusCode == 422) {
      return const Left(StatusRequest.serverfailure);
    }
    else {
      return const Left(StatusRequest.offlinefailure);
    }
  }


  Future<Either<StatusRequest, Map>> postWithToken(String url, Map data, String token) async {
    try {
      var headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

      var response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: jsonEncode(data),
      );

      var responseBody = jsonDecode(response.body);
      print('Response Body: $responseBody');

      if (response.statusCode == 200) {
        return Right(responseBody);
      } else if (response.statusCode == 400 || response.statusCode == 401) {
        return Right(responseBody);
      } else {
        return Left(StatusRequest.offlinefailure);
      }
    } catch (e) {
      print('Exception in post request: $e');
      return Left(StatusRequest.offlinefailure);
    }
  }


}