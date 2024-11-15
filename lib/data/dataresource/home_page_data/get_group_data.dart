import 'package:dartz/dartz.dart';
import 'package:get_storage/get_storage.dart';
import '../../../applink.dart';
import '../../../core/class/crud.dart';
import '../../../core/class/staterequest.dart';

class GetAllGroupData {
  final Crud client;
  final box = GetStorage();

  GetAllGroupData(this.client);

  Future<Either<StatusRequest, List>> get() async {
    String? token = box.read('token');
    print('Loaded token: $token');

    var headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };

    var response = await client.get(
      Applink.getAllGroup,
      headers: headers,
    );

    if (response.isRight()) {
      // تحقق أن الاستجابة بالفعل قائمة من العناصر
      List<dynamic> responseData = response.getOrElse(() => []);
      return Right(responseData);
    } else {
      return const Left(StatusRequest.failure);
    }
  }
}
