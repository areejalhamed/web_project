import 'package:get_storage/get_storage.dart';
import 'package:project/core/class/crud.dart';
import '../../../applink.dart';

class CompareFileData {
  final Crud client;
  final box = GetStorage();
  CompareFileData(this.client);

  Future get(int fileId) async {
    String? token = GetStorage().read('token');
    if (token == null) {
      throw Exception("Token not found in GetStorage.");
    }

    var headers = {
      'Authorization': 'Bearer $token',
      'Accept': '*/*',
    };

    try {
      var response = await client.get('${Applink.url}/compareFilesById/$fileId', headers: headers);

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
