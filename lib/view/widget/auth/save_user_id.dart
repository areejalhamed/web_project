import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get_storage/get_storage.dart';

import '../../../core/constant/routes.dart';

class StorageHelper {

  static final box = GetStorage();

  Future<void> saveUserData(int id, String token, String userName, String userEmail) async {
    final box = GetStorage();
    await box.write('id', id);
    await box.write('token', token);
    await box.write('name', userName);
    await box.write('email', userEmail);
  }


  int? getUserId() {
    final box = GetStorage();
    final id = box.read('id');
    if (id != null && id is int) {
      return id;
    }
    return null;
  }


  static String? getToken() {
    return box.read('token');
  }

  void logout() async {
    final box = GetStorage();
    await box.erase();
    print("User logged out.");
    Get.offNamed(AppRoute.login);
  }

}
