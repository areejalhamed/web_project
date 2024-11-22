import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constant/color.dart';

class Searchpage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
   return TextField(
     decoration: InputDecoration(
       labelText: '15'.tr,
       prefixIcon: const Icon(Icons.search, color: fiveBackColor),
       labelStyle: const TextStyle(color: fiveBackColor),
       enabledBorder: OutlineInputBorder(
         borderRadius: BorderRadius.circular(15.0),
         borderSide: const BorderSide(color: fiveBackColor),
       ),
       focusedBorder: OutlineInputBorder(
         borderRadius: BorderRadius.circular(15.0),
         borderSide: const BorderSide(color: sevenBackColor),
       ),
     ),
   );
  }

}