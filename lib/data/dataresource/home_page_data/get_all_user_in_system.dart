import 'package:dartz/dartz.dart';
import 'package:get_storage/get_storage.dart';
import 'package:project/applink.dart';
import '../../../core/class/crud.dart';
import '../../../core/class/staterequest.dart';

class GetAllUserData {
  final Crud client;
  final box = GetStorage();

  GetAllUserData(this.client);

  Future<Either<StatusRequest, List<Map<String, dynamic>>>> getData() async {
    String? token = box.read('token');
    print('Loaded token: $token');

    var headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };

    var response = await client.get(
     Applink.getAllUsers,
      headers: headers,
    );

    if (response.isRight()) {
      // تحقق أن الاستجابة بالفعل قائمة من العناصر
      List<dynamic> responseData = response.getOrElse(() => []);

      // تحويل البيانات إلى قائمة من الخريطة
      List<Map<String, dynamic>> allusers = List<Map<String, dynamic>>.from(responseData);
      return Right(allusers);
    } else {
      return const Left(StatusRequest.failure);
    }
  }
}