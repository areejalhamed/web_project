import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../core/constant/color.dart';

class ListTitleHomePage extends StatelessWidget {

  final void Function() onTap;
  final Icon icon;
  final String text;

  const ListTitleHomePage({
    Key? key,
    required this.onTap,
    required this.icon,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: icon,
      title: Text(text),
      onTap: () {
        onTap();
      },
    );
  }
}
