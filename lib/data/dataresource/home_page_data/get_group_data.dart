import 'package:dartz/dartz.dart';
import 'package:get_storage/get_storage.dart';
import '../../../applink.dart';
import '../../../core/class/crud.dart';
import '../../../core/class/staterequest.dart';

class GetAllGroupData {
  final Crud client;

  GetAllGroupData(this.client);

  Future get() async {
    String? token = GetStorage().read('token');
    if (token == null) {
      throw Exception("Token not found in GetStorage.");
    }

    var headers = {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
    };

    try {
      var response = await client.get('${Applink.url}/getAllGroups', headers: headers);
      print("Response Body: ${response}");
      return response;
    } catch (e) {
      print("Error in get request: $e");
      return {'status': false, 'message': 'Error occurred during request'};
    }
  }
}
