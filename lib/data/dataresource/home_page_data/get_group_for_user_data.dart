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
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };

    // تمرير معرف المستخدم كمعامل للطلب
    var response = await client.get('${Applink.getGroupsForUser}?user_id=$userId', headers: headers);

    if (response.isRight()) {
      var responseData = response.getOrElse(() => {});

      // تحقق أن الاستجابة تحتوي على مفتاح 'data'
      if (responseData is Map && responseData['data'] != null) {
        // تصفية البيانات بناءً على userId
        List<Map<String, dynamic>> allGroups =
        List<Map<String, dynamic>>.from(responseData['data'])
            .where((group) => group['pivot']['user_id'] == userId)
            .toList();

        return Right(allGroups);
      } else {
        return const Left(StatusRequest.failure);
      }
    } else {
      return const Left(StatusRequest.failure);
    }
  }
}
