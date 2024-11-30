import 'package:dartz/dartz.dart';
import 'package:get_storage/get_storage.dart';
import 'package:project/applink.dart';
import '../../../core/class/crud.dart';
import '../../../core/class/staterequest.dart';

class GetAllUserInSystemData {
  final Crud client;
  final box = GetStorage();

  GetAllUserInSystemData(this.client);

  Future<Either<StatusRequest, List<Map<String, dynamic>>>> getData() async {
    String? token = box.read('token');
    print('Loaded token: $token');

    var headers = {
      'Accept': '*/*',
      'Authorization': 'Bearer $token',
    };

    var response = await client.get(
        Applink.getAllUsers,
        headers: headers
    );

    if (response.isRight()) {
      var responseData = response.getOrElse(() => {});

      // تحقق أن الاستجابة هي Map وأنها تحتوي على مفتاح 'data'
      if (responseData is Map && responseData['data'] != null) {
        List<Map<String, dynamic>> allUsers =
        List<Map<String, dynamic>>.from(responseData['data']);
        return Right(allUsers);
      } else {
        return const Left(StatusRequest.failure);
      }
    } else {
      return const Left(StatusRequest.failure);
    }
  }
}
