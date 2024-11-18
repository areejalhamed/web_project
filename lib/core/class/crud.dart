import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:project/core/class/staterequest.dart';
import 'package:dartz/dartz.dart';

class Crud {

  String? globalAuthorizationToken;

  Future<Either<StatusRequest, Map>> post(String url, Map data) async {
    try {
      var response = await http.post(
        Uri.parse(url),
        body: data,
      );

      // تحليل body الخاص بالاستجابة
      var responseBody = jsonDecode(response.body);
      print('Response Body: $responseBody');
      print("StatusCode: ${response.statusCode}");

      // استخراج رمز المصادقة من حقل data إذا كان موجوداً
      if (responseBody.containsKey('data')) {
        globalAuthorizationToken = responseBody['data'];
        print('Token (data): $globalAuthorizationToken');
      } else {
        print('Authorization token not found in response body.');
      }

      // التحقق من نجاح الطلب
      if (response.statusCode == 200 || response.statusCode == 201) {
        return Right(responseBody);
      } else if (response.statusCode == 400 || response.statusCode == 422) {
        return const Left(StatusRequest.serverfailure);
      } else {
        return const Left(StatusRequest.offlinefailure);
      }
    } catch (e) {
      print('Exception in post request: $e');
      return Left(StatusRequest.offlinefailure);
    }
  }

  Future<Either<StatusRequest, Map>> postWithToken(String url, Map data) async {
    try {
      if (globalAuthorizationToken == null) {
        print("Authorization token is missing");
        return const Left(StatusRequest.offlinefailure);
      }

      var headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $globalAuthorizationToken',
      };

      var response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: jsonEncode(data),
      );

      print('Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      // التحقق من أن الاستجابة JSON وليست HTML
      if (response.headers['content-type'] != null &&
          response.headers['content-type']!.contains('application/json')) {
        var responseBody = jsonDecode(response.body);
        return Right(responseBody);
      } else {
        print("Error: Response is not in JSON format");
        return const Left(StatusRequest.serverfailure);
      }
    } catch (e) {
      print("Exception in post request: $e");
      return Left(StatusRequest.offlinefailure);
    }
  }

  Future<Either<StatusRequest, Map>> postMultipart(String url, {Map<String, String>? headers, Map<String, String>? fields,}) async {
    try {
      // إنشاء طلب Multipart
      var request = http.MultipartRequest('POST', Uri.parse(url));

      // إضافة الحقول إن وجدت
      if (fields != null) {
        request.fields.addAll(fields);
      }

      // إضافة الرؤوس إن وجدت
      if (headers != null) {
        request.headers.addAll(headers);
      }

      // إرسال الطلب والحصول على الاستجابة
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      // تحليل الاستجابة
      var responseBody = jsonDecode(response.body);
      print('Response Body: $responseBody');
      print("StatusCode: ${response.statusCode}");

      // التحقق من نجاح الطلب
      if (response.statusCode == 200 || response.statusCode == 201) {
        return Right(responseBody);
      } else if (response.statusCode == 400 || response.statusCode == 422) {
        return const Left(StatusRequest.serverfailure);
      } else {
        return const Left(StatusRequest.offlinefailure);
      }
    } catch (e) {
      print('Exception in post request: $e');
      return Left(StatusRequest.offlinefailure);
    }
  }

  Future<Either<StatusRequest, dynamic>> get(String url, {Map<String, String>? headers}) async {
    try {
      var response = await http.get(
        Uri.parse(url),
        headers: headers,
      );

      var responseBody = jsonDecode(response.body);
      print('Response Body: $responseBody');
      print("StatusCode: ${response.statusCode}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        print("StatusCode: ${response.statusCode}");
        return Right(responseBody);
      } else if (response.statusCode == 400 || response.statusCode == 422) {
        return const Left(StatusRequest.serverfailure);
      } else {
        return const Left(StatusRequest.offlinefailure);
      }
    } catch (e) {
      print('Exception in get request: $e');
      return Left(StatusRequest.offlinefailure);
    }
  }

}
