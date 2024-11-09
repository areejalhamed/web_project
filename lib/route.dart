import 'package:flutter/cupertino.dart';
import 'package:project/view/screen/home_page/home_page.dart';
import 'package:project/view/screen/login.dart';

Map<String , Widget Function(BuildContext)> routs = {

  "/Login" : (context) =>  Loginpage(),
  "/HomePage" : (context) =>  HomePage(),

};