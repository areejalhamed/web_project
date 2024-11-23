// import 'package:dartz/dartz.dart';
// import 'package:get_storage/get_storage.dart';
// import 'package:project/core/class/staterequest.dart';
//
// import '../../../applink.dart';
// import '../../../core/class/crud.dart';
//
// class SearchGroupData {
//
//   final Crud client;
//   final box = GetStorage();
//
//   SearchGroupData(this.client);
//
//   Future<Either<StatusRequest, Map>> postSearchGroup(String groupName) async {
//     String? token = box.read('token');
//     print('Loaded token: $token');
//
//     var headers = {
//       'Accept': 'application/json',
//       'Authorization': 'Bearer $token',
//     };
//
//     var fields = {
//       'name': groupName,
//     };
//
//     try {
//       var response = await client.postMultipart(
//         Applink.searchGroup,
//         fields: fields,
//         headers: headers,
//       );
//
//     //   if (response is Map && response.containsKey('groups')) {
//     //     // إذا كانت الاستجابة تحتوي على مفتاح 'groups'
//     //     return Right(response); // إرجاع البيانات الصحيحة
//     //   } else {
//     //     // إذا لم تحتوي الاستجابة على البيانات الصحيحة
//     //     return Left(StatusRequest.failure);
//     //   }
//     // } catch (e) {
//     //   print("Error occurred: $e");
//     //   // في حالة حدوث خطأ في الاتصال أو غيره
//     //   return Left(StatusRequest.failure);
//     // }
//   }
// }
