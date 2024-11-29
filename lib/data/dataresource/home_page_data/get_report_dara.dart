import 'package:dartz/dartz.dart';
import 'package:get_storage/get_storage.dart';

import '../../../applink.dart';
import '../../../core/class/crud.dart';
import '../../../core/class/staterequest.dart';

class GetReportData {
  final Crud client;
  final box = GetStorage();

  GetReportData(this.client);

  Future<Either<StatusRequest, List<Map<String, dynamic>>>> get(int groupId) async {
    String? token = box.read('token');
    print('Loaded token: $token');

    var headers = {
      'Accept': '*/*',
      'Authorization': 'Bearer $token',
    };

    var response = await client.get(
      "${Applink.url}/reports/$groupId",
      headers: headers,
    );

    if (response.isRight()) {
      // إذا كانت الاستجابة تحتوي على خريطة (Map) مع حقل `reports`
      var responseData = response.getOrElse(() => {});

      if (responseData is Map && responseData.containsKey('reports')) {
        List<dynamic> reports = responseData['reports'];

        if (reports.isEmpty) {
          return const Left(StatusRequest.failure); // إذا كانت البيانات فارغة
        }

        // تحويل البيانات إلى قائمة من الخرائط
        List<Map<String, dynamic>> reportList = List<Map<String, dynamic>>.from(reports);
        return Right(reportList);
      } else {
        return const Left(StatusRequest.failure); // فشل إذا كانت الاستجابة غير صحيحة
      }
    } else {
      return const Left(StatusRequest.failure); // فشل إذا كانت الاستجابة خطأ
    }
  }
}
