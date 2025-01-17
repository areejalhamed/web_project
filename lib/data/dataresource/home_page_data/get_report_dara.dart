import 'package:get_storage/get_storage.dart';
import '../../../applink.dart';
import '../../../core/class/crud.dart';

class GetReportData {
  final Crud client;

  GetReportData(this.client);

  Future get(int groupId) async {
    String? token = GetStorage().read('token');
    if (token == null) {
      throw Exception("Token not found in GetStorage.");
    }

    var headers = {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
    };

    try {
      var response = await client.get('${Applink.url}/reports/$groupId', headers: headers);
      print("Response Body: ${response}");
      return response;
    } catch (e) {
      print("Error in get request: $e");
      return {'status': false, 'message': 'Error occurred during request'};
    }
  }
}
