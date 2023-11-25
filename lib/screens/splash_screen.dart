// ignore_for_file: deprecated_member_use

import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:movie_app/model/movie_model.dart';
import 'package:movie_app/screens/home.dart';
import 'package:movie_app/utils/textstyle.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

List<MovieModel> movies = [];

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool showText = false;

  @override
  void initState() {
    getData();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );

    _animation = TweenSequence(
      <TweenSequenceItem<double>>[
        TweenSequenceItem<double>(
          tween: Tween<double>(begin: -2.0, end: 1.0)
              .chain(CurveTween(curve: Curves.easeInOut)),
          weight: 50.0,
        ),
        TweenSequenceItem<double>(
          tween: Tween<double>(begin: 1.0, end: -2.0)
              .chain(CurveTween(curve: Curves.easeInOut)),
          weight: 50.0,
        ),
      ],
    ).animate(_controller);

    Timer(const Duration(milliseconds: 500), () {
      _controller.forward();
    });

    _animation = TweenSequence(
      <TweenSequenceItem<double>>[
        TweenSequenceItem<double>(
          tween: Tween<double>(begin: 1.0, end: -2.0)
              .chain(CurveTween(curve: Curves.easeInOut)),
          weight: 50.0,
        ),
      ],
    ).animate(_controller);
    setState(() {
      showText = true;
    });
    Timer(const Duration(milliseconds: 500), () {
      _controller.forward();
    });
    push();
    super.initState();
  }

  void push() async {
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed && movies.isNotEmpty) {
        // Animation completed, navigate to the next page
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const Home(),
          ),
        );
      }
    });
  }

  void getData() async {
    var response =
        await http.get(Uri.parse("https://api.tvmaze.com/search/shows?q=all"));
    movies =
        List.from(jsonDecode(response.body).map((e) => MovieModel.fromJson(e)));
    push();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: EdgeInsets.only(left: 30.w),
        child: Center(
          child: Stack(
            alignment: Alignment.center,
            children: [
              Text(
                "  CineSync",
                style: archivo(Colors.yellowAccent, 40.sp, FontWeight.w900),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: AnimatedBuilder(
                    animation: _controller,
                    builder: (context, child) {
                      return Container(
                        color: Colors.black,
                        padding: EdgeInsets.only(
                            left: _animation.value > 0
                                ? _animation.value * 300.w
                                : 0),
                        child: SvgPicture.asset(
                          "assets/logo.svg",
                          color: Colors.yellowAccent,
                          height: 60.h,
                          width: 60.w,
                        ),
                      );
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
