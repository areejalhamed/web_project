import '../../applink.dart';
import '../../core/class/curd.dart';

class RegisterData {
  Crud crud;
  RegisterData(this.crud);

  postdata(String name, String email, String password)async{
    var response = await crud.post(Applink.register, {
      "name" : name ,
      "email" : email ,
      "password" :password ,
    },{});
    return response.fold((l) => l, (r) => r) ;

  }

}