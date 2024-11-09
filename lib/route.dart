import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:project/view/screen/Auth/login.dart';
import 'package:project/view/screen/Auth/register.dart';

import 'core/constant/routes.dart';

List<GetPage<dynamic>>? routes = [
  GetPage(name: AppRoute.login, page: ()=> Loginpage()),
  GetPage(name: AppRoute.register, page: ()=> Registerpage()),

];