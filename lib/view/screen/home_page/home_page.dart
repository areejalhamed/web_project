import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../core/constant/color.dart';
import '../../widget/home_page/list_title.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  Color _borderColor = Colors.grey;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: <Widget>[
          Container(
            width: 250,
            color: Colors.grey[200],
            child: Column(
              children: <Widget>[
                DrawerHeader(
                  decoration: const BoxDecoration(
                    color: sevenBackColor,
                    borderRadius: BorderRadius.vertical(
                      bottom: Radius.circular(20),
                    ),
                  ),
                  child: SizedBox(
                    width: 250,
                    height: 75,
                    child: Container(
                      child: const Text(
                        'M y _  A c c o u n t',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                        ),
                      ),
                    ),
                  ),
                ),
                ListTitleHomePage(
                  onTap: () {},
                  text: 'Home Page',
                  icon: const Icon(Icons.home),
                ),
                ListTitleHomePage(
                  onTap: () {},
                  text: 'Create a group',
                  icon: const Icon(Icons.create_outlined),
                ),
                ListTitleHomePage(
                  onTap: () {},
                  text: 'Setting',
                  icon: const Icon(Icons.settings),
                ),
                ListTitleHomePage(
                  onTap: () {},
                  text: 'About',
                  icon: const Icon(Icons.info_outline_rounded),
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: 'Search ..',
                      prefixIcon:const Icon(Icons.search, color: fiveBackColor),
                      labelStyle:const TextStyle(color: fiveBackColor),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        borderSide:const BorderSide(color: fiveBackColor),
                      ),
                      focusedBorder: OutlineInputBorder(

                        borderRadius: BorderRadius.circular(15.0),
                        borderSide:const BorderSide(color: sevenBackColor),
                      ),
                    ),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // الصورة
                    Container(
                      width: 150, // عرض الصورة
                      height: 150, // ارتفاع الصورة
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage('https://example.com/sunset.jpg'),
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    const SizedBox(height: 10), // مساحة بين الصورة والاسم
                    // اسم الغروب
                    Text(
                      'Name Group',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
