import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../core/constant/color.dart';

class Rowauth extends StatelessWidget{
  final String text1;
  final String text2;
  final void Function() onTap;

  const Rowauth({
    Key? key,
    required this.text1,
    required this.onTap,
    required this.text2}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(text1,style:const TextStyle(color: fiveBackColor,fontWeight: FontWeight.w400,fontSize: 14),),
        const SizedBox(width: 10,),
        InkWell(onTap: onTap,
            child:Container(
                decoration: BoxDecoration(
                    color: sevenBackColor,
                    borderRadius: BorderRadius.circular(10)),

                child: Center(child:  Text(text2,
                  style:const TextStyle(
                      color: firstBackColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 14),))))

      ],
    );
  }}




