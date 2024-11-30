import 'package:dartz/dartz.dart';
import 'package:get_storage/get_storage.dart';
import '../../../applink.dart';
import '../../../core/class/crud.dart';
import '../../../core/class/staterequest.dart';

class LeaveGroupData {
  final Crud client;
  final box = GetStorage();

  LeaveGroupData(this.client);

  Future<Either<StatusRequest, List<Map<String, dynamic>>>> get(int groupId , int userId) async {
    String? token = box.read('token');
    print('Loaded token: $token');

    var headers = {
      'Accept': '*/*',
      'Authorization': 'Bearer $token',
    };

    var response = await client.get(
      "${Applink.url}/leave/$userId/$groupId",
      headers: headers,
    );

    if (response.isRight()) {
      // تحقق أن الاستجابة بالفعل قائمة من العناصر
      List<dynamic> responseData = response.getOrElse(() => []);

      // تحويل البيانات إلى قائمة من الخريطة
      List<Map<String, dynamic>> users = List<Map<String, dynamic>>.from(responseData);
      return Right(users);
    } else {
      return const Left(StatusRequest.failure);
    }
  }
}
