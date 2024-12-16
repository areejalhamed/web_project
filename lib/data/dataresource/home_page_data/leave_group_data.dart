import 'package:dartz/dartz.dart';
import 'package:get_storage/get_storage.dart';
import '../../../applink.dart';
import '../../../core/class/crud.dart';
import '../../../core/class/staterequest.dart';

class LeaveGroupData {

  final Crud client;
  final box = GetStorage();

  LeaveGroupData(this.client);

  Future leave(int groupId, int userId) async {
    String? token = GetStorage().read('token');
    if (token == null) {
      throw Exception("Token not found in GetStorage.");
    }

    print('Loaded token: $token');

    // التحقق من وجود groupId و userId
    if (groupId <= 0 || userId <= 0) {
      print("Invalid groupId or userId");
      return const Left(StatusRequest.failure);
    }

    // بناء رابط الطلب
    String url = "${Applink.url}/leave/$userId/$groupId";
    print('Request URL: $url');

    var headers = {
      'Authorization': 'Bearer $token',
      'Accept': '*/*',
    };

    // إرسال الطلب باستخدام postWithToken
    var response = await client.get(url, headers: headers);

    // التعامل مع الاستجابة
    return response.fold(
          (failure) {
        print("Leave group failed: $failure");
        return const Left(StatusRequest.failure);
      },
          (success) {
        print("Leave group successful: $success");
        return Right(success);
      },
    );
  }
}