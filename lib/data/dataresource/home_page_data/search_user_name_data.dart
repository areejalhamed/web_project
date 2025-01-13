import 'package:get_storage/get_storage.dart';
import 'package:project/core/class/crud.dart';
import '../../../applink.dart';

class SearchUserNameData {
  final Crud client;
  final box = GetStorage();

  SearchUserNameData(this.client);

  Future postMultipart(String url, {Map<String, String>? fields}) async {
    String? token = box.read('token');
    print('Loaded token: $token');
    var headers = {
      'Accept': '*/*',
      'Authorization': 'Bearer $token',
    };

    var response = await client.postMultipart(
      url,
      fields: fields,
      headers: headers,
    );

    return response;
  }
}
