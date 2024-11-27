import 'package:dartz/dartz.dart';
import 'package:get_storage/get_storage.dart';
import 'package:project/applink.dart';
import '../../../core/class/crud.dart';
import '../../../core/class/staterequest.dart';

class GetGroupForUserData {
  final Crud client;
  final box = GetStorage();

  GetGroupForUserData(this.client);

  Future<Either<StatusRequest, List<Map<String, dynamic>>>> getData(int userId) async {
    String? token = box.read('token');
    print('Loaded token: $token');

    var headers = {
      'Accept': '*/*',
      'Authorization': 'Bearer $token',
    };

    var url = '${Applink.getGroupsForUser}/$userId';
    print('Request URL: $url');

    var response = await client.get(url, headers: headers);

    if (response.isRight()) {
      var responseData = response.getOrElse(() => {});

      if (responseData is Map && responseData['data'] != null) {
        List<Map<String, dynamic>> allGroups =
        List<Map<String, dynamic>>.from(responseData['data']);
        return Right(allGroups);
      } else {
        return const Left(StatusRequest.failure);
      }
    } else {
      return const Left(StatusRequest.failure);
    }
  }
}
