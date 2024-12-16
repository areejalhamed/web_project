import 'package:get_storage/get_storage.dart';
import 'package:project/core/class/crud.dart';
import '../../../applink.dart';

class CheckOutFileData {
  final Crud client;
  final box = GetStorage();

  CheckOutFileData(this.client);

  Future postMultipart({required int fileId, required int userId}) async {
    String? token = box.read('token');
    print('Loaded token: $token');

    var headers = {
      'Accept': '*/*',
      'Authorization': 'Bearer $token',
    };

    var response = await client.postMultipart(
      "${Applink.url}/files/$fileId/check-out/$userId",
      headers: headers,
    );

    return response;
  }
}
