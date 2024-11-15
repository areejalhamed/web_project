import 'package:project/applink.dart';
import '../../../core/class/crud.dart';

class LoginData {
  Crud crud;
  LoginData(this.crud);

  Future postData(String email, String password) async {
    var response = await crud.post(Applink.login, {
      "email": email,
      "password": password,
    });

    return response.fold((l) => l, (r) => r);
  }
}
