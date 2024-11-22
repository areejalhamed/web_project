import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:project/view/screen/Auth/login.dart';
import 'package:project/view/screen/Auth/register.dart';
import 'package:project/view/screen/home_page/drawer.dart';
import 'package:project/view/screen/home_page/get_user_all.dart';
import 'package:project/view/screen/home_page/home_page.dart';
import 'package:project/view/widget/home_page/Search.dart';
import 'package:project/view/widget/home_page/show_dialog.dart';

import 'core/constant/routes.dart';

List<GetPage<dynamic>>? routes = [
  GetPage(name: AppRoute.login, page: ()=> Loginpage()),
  GetPage(name: AppRoute.register, page: ()=> Registerpage()),
  GetPage(name: AppRoute.homePage, page: ()=> HomePage()),
  GetPage(name: AppRoute.showConfirmationDialog, page: ()=> ShowConfirmationDialog()),
  GetPage(name: AppRoute.searchpage, page: ()=> Searchpage()),
  GetPage(name: AppRoute.drawerpage, page: ()=> Drawerpage()),
  // GetPage(name: AppRoute.getAllUser, page: ()=> GetAllUser(groupId: null,)),

];