import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../core/constant/color.dart';


class MaterialButtonAuth extends StatelessWidget{
  final String text;
  final void Function()? onPressed;
  const MaterialButtonAuth({Key? key, required this.text, required this.onPressed,}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return  Container(
      //margin:const EdgeInsets.symmetric(horizontal: 100,vertical: 10),
      margin:const EdgeInsets.all(10),
      child: MaterialButton(
        padding:const EdgeInsets.only(left: 65,right: 65,top: 20 ,bottom: 20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        color: secondBackColor,
        textColor: white,
        onPressed: onPressed,
        child: Text(text , style:const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),), ),
    );
  }

}