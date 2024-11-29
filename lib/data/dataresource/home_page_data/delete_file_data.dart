import 'package:dartz/dartz.dart';
import 'package:get_storage/get_storage.dart';
import '../../../applink.dart';
import '../../../core/class/crud.dart';
import '../../../core/class/staterequest.dart';

class DeleteFileData {
  final Crud client;

  DeleteFileData(this.client);

  Future<Either<StatusRequest, Map>> deleteFile(int id) async {
    try {
      var token = GetStorage().read("token");
      var headers = {
        'Authorization': 'Bearer $token',
        'Accept': '*/*',
      };

      print("Request URL: ${Applink}/deleteFile/$id");
      print("Headers: $headers");

      var response = await client.delete(
        "${Applink.url}/deleteFile/$id",
        headers: headers,
      );

      // تحقق من حالة الاستجابة
      if (response.isLeft()) {
        print("Error: ${response.getOrElse(() => null)}");
        return Left(StatusRequest.serverfailure);
      }

      // طباعة تفاصيل الاستجابة
      var responseBody = response.getOrElse(() => {});
      print("Response Body: $responseBody");

      if (responseBody is Map) {
        return Right(responseBody); // إذا كانت الاستجابة JSON صالح
      } else {
        print("Response is not valid JSON: $responseBody");
        return Left(StatusRequest.serverfailure);
      }
    } catch (e) {
      print("خطأ أثناء حذف المجموعة: $e");
      return Left(StatusRequest.offlinefailure);
    }
  }
}
