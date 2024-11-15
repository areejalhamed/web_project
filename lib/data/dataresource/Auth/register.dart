import '../../../applink.dart';
import '../../../core/class/crud.dart';

class RegisterData {
  Crud crud;
  RegisterData(this.crud);

  Future postData(String name, String email, String password) async {
    var response = await crud.postWithToken(Applink.register, {
      "name": name,
      "email": email,
      "password": password,
    });

    return response.fold((l) => l, (r) => r);
  }
}
