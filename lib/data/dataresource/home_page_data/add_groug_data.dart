import 'package:get_storage/get_storage.dart';
import 'package:project/core/class/crud.dart';
import '../../../applink.dart';

class AddGroupData {
  final Crud client;
  final box = GetStorage();

  AddGroupData(this.client);

  Future postMultipart(String name, String imageUrl) async {
    String? token = box.read('token');
    print('Loaded token: $token');

    var headers = {
      'Accept': '*/*',
      'Authorization': 'Bearer $token',
    };
    var fields = {
      'name': name,
      'image': imageUrl,
    };

    var response = await client.postMultipart(
      Applink.addGroup,
      fields: fields,
      headers: headers,
    );

    return response;
  }

}
