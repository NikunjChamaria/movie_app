// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:movie_app/screens/home_screen.dart';
import 'package:movie_app/screens/search.dart';
import 'package:movie_app/utils/textstyle.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List pages = [const HomeScreen(), const SearchPage()];
  int index = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        automaticallyImplyLeading: false,
        elevation: 0,
        title: Row(
          children: [
            SvgPicture.asset(
              "assets/logo.svg",
              color: Colors.yellowAccent,
            ),
            SizedBox(
              width: 10.w,
            ),
            Text(
              "CineSync",
              style: archivo(Colors.yellowAccent, 20.sp, FontWeight.bold),
            )
          ],
        ),
      ),
      body: pages[index],
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: index,
          onTap: (value) {
            setState(() {
              index = value;
            });
          },
          selectedItemColor: Colors.yellowAccent,
          selectedIconTheme: const IconThemeData(color: Colors.yellowAccent),
          unselectedItemColor: Colors.white,
          backgroundColor: Colors.black,
          selectedLabelStyle:
              oxygen(Colors.yellowAccent, 15.sp, FontWeight.bold),
          unselectedLabelStyle: oxygen(Colors.white, 15.sp, FontWeight.normal),
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: "HOME"),
            BottomNavigationBarItem(icon: Icon(Icons.search), label: "SEARCH")
          ]),
    );
  }
}
