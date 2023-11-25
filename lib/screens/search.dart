import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movie_app/model/movie_model.dart';
import 'package:movie_app/screens/movie_detail.dart';
import 'package:movie_app/utils/textstyle.dart';
import 'package:http/http.dart' as http;
import 'package:shimmer/shimmer.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<MovieModel> movies = [];
  TextEditingController search = TextEditingController();
  bool isLoading = false;
  String formatHoursAndMinutes(int totalMinutes) {
    int hours = totalMinutes ~/ 60;
    int minutes = totalMinutes % 60;

    String result = '';
    if (hours > 0) {
      result += '${hours}h';
    }
    if (minutes > 0) {
      result += '${minutes}min';
    }

    return result.isNotEmpty ? result : '0min';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(10.h),
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.white),
                  borderRadius: BorderRadius.circular(10.h)),
              child: TextFormField(
                controller: search,
                cursorColor: Colors.white,
                onChanged: (value) async {
                  await Future.delayed(const Duration(seconds: 1));
                  setState(() {
                    isLoading = true;
                  });
                  var response = await http.get(Uri.parse(
                      "https://api.tvmaze.com/search/shows?q=$value"));
                  movies = List.from(jsonDecode(response.body)
                      .map((e) => MovieModel.fromJson(e)));
                  setState(() {
                    isLoading = false;
                  });
                },
                style: oxygen(Colors.grey, 16.sp, FontWeight.bold),
                decoration: InputDecoration(
                    prefixIcon: const Icon(
                      Icons.search,
                      color: Colors.white,
                    ),
                    border: InputBorder.none,
                    hintText: "Search",
                    hintStyle: oxygen(Colors.grey, 16.sp, FontWeight.bold)),
              ),
            ),
            SizedBox(
              height: 20.h,
            ),
            Visibility(
              visible: !isLoading,
              child: GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, childAspectRatio: 9 / 17),
                itemCount: movies.length,
                shrinkWrap: true,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  MovieDetail(show: movies[index].show!)));
                    },
                    child: Container(
                      padding: EdgeInsets.all(10.h),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Hero(
                            tag: movies[index].show!.id!,
                            child: CachedNetworkImage(
                              height: 250.h,
                              fit: BoxFit.cover,
                              imageUrl: movies[index].show!.image == null
                                  ? ""
                                  : movies[index].show!.image!.original!,
                              errorWidget: (context, url, error) {
                                return CachedNetworkImage(
                                    height: 250.h,
                                    fit: BoxFit.cover,
                                    imageUrl:
                                        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQiUqGvs-Wgpbk4a8HcVMjOVeHJ7kiryV12xpX-WwjUty5NwqHlMTm4M1caosM6IYxkW9I&usqp=CAU");
                              },
                            ),
                          ),
                          SizedBox(
                            height: 5.h,
                          ),
                          Text(
                            movies[index].show!.name!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: oxygen(Colors.white, 16.sp, FontWeight.bold),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                movies[index].show!.language!,
                                style: oxygen(
                                    Colors.white, 16.sp, FontWeight.w400),
                              ),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.star,
                                    color: Colors.yellowAccent,
                                  ),
                                  Text(
                                    movies[index]
                                        .show!
                                        .rating!
                                        .average
                                        .toString(),
                                    style: oxygen(
                                        Colors.white, 16.sp, FontWeight.w400),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Text(
                            formatHoursAndMinutes(
                              movies[index].show!.runtime ?? 0,
                            ),
                            style: oxygen(Colors.grey, 16.sp, FontWeight.w400),
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            Visibility(
              visible: isLoading,
              child: GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, childAspectRatio: 9 / 17),
                itemCount: movies.length,
                shrinkWrap: true,
                itemBuilder: (BuildContext context, int index) {
                  return Shimmer.fromColors(
                      baseColor: Colors.black,
                      highlightColor: Colors.white,
                      child: Container(
                        color: Colors.black,
                      ));
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
