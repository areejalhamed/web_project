import 'package:get_storage/get_storage.dart';
import 'package:project/core/class/crud.dart';
import '../../../applink.dart';

class ExportCsvData {
  final Crud client;

  ExportCsvData(this.client);

  Future get(int groupId) async {
    String? token = GetStorage().read('token');
    if (token == null) {
      throw Exception("Token not found in GetStorage.");
    }

    var headers = {
      'Authorization': 'Bearer $token',
      'Accept': '*/*',
    };

    try {
      var response = await client.get('${Applink.url}/exportCSV/$groupId', headers: headers);

      // فك استجابة Either
      return response.fold(
            (left) => throw Exception("Request failed: $left"),
            (right) {
          print("Response Body: $right");
          return right;
        },
      );
    } catch (e) {
      print("Error in get request: $e");
      return {'status': false, 'message': 'Error occurred during request'};
    }
  }
}
