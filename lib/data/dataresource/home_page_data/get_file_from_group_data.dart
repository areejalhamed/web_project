import 'package:dartz/dartz.dart';
import 'package:get_storage/get_storage.dart';

import '../../../applink.dart';
import '../../../core/class/crud.dart';
import '../../../core/class/staterequest.dart';

class GetFileFromGroupData {
  final Crud client;
  final box = GetStorage();

  GetFileFromGroupData(this.client);

  Future<Either<StatusRequest, Map<String, dynamic>>> get(int groupid) async {

    String? token = box.read('token');
    print('Loaded token: $token');

    var headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };

    print("Fetching from URL: ${Applink.url}/files/$groupid/group");

    var response = await client.get(
      "${Applink.url}/files/$groupid/group",
      headers: headers,
    );

    print("Raw response: $response");

    if (response.isRight()) {
      Map<String, dynamic> responseData = response.getOrElse(() => {});
      print("Response data parsed: $responseData");
      return Right(responseData);
    } else {
      print("Failed to fetch data.");
      return  Left(StatusRequest.failure);
    }
  }
}