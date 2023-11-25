// ignore_for_file: depend_on_referenced_packages

import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movie_app/model/episod_model.dart';
import 'package:movie_app/model/movie_model.dart';
import 'package:movie_app/utils/textstyle.dart';
import 'package:html/parser.dart' show parse;
import 'package:http/http.dart' as http;
import 'package:shimmer/shimmer.dart';

class MovieDetail extends StatefulWidget {
  final Show show;
  const MovieDetail({super.key, required this.show});

  @override
  State<MovieDetail> createState() => _MovieDetailState();
}

class _MovieDetailState extends State<MovieDetail> {
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

  String htmlToPlainText(String htmlString) {
    var document = parse(htmlString);
    String plainText = document.body!.text;

    return plainText;
  }

  Future<EpisodeModel> getEpisode() async {
    if (widget.show.lLinks != null &&
        widget.show.lLinks!.previousepisode != null) {
      var res =
          await http.get(Uri.parse(widget.show.lLinks!.previousepisode!.href!));
      return EpisodeModel.fromJson(jsonDecode(res.body));
    }
    return EpisodeModel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: <Widget>[
          SliverAppBar(
            backgroundColor: Colors.black,
            automaticallyImplyLeading: false,
            toolbarHeight: 200.h,
            flexibleSpace: FlexibleSpaceBar(
              background: Hero(
                tag: widget.show.id!,
                child: CachedNetworkImage(
                  height: 200.h,
                  width: MediaQuery.of(context).size.width,
                  fit: BoxFit.cover,
                  imageUrl: widget.show.image == null
                      ? ""
                      : widget.show.image!.original!,
                  errorWidget: (context, url, error) {
                    return CachedNetworkImage(
                        height: 200.h,
                        fit: BoxFit.cover,
                        imageUrl:
                            "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQiUqGvs-Wgpbk4a8HcVMjOVeHJ7kiryV12xpX-WwjUty5NwqHlMTm4M1caosM6IYxkW9I&usqp=CAU");
                  },
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(10.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.all(5.h),
                    decoration: BoxDecoration(
                        color: Colors.yellowAccent,
                        borderRadius: BorderRadius.circular(10.h)),
                    child: Text(
                      widget.show.name!,
                      style: oxygen(Colors.black, 25.sp, FontWeight.w900),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.show.language!,
                        style: oxygen(Colors.white, 18.sp, FontWeight.bold),
                      ),
                      Row(
                        children: [
                          const Icon(
                            Icons.star,
                            color: Colors.yellowAccent,
                          ),
                          Text(
                            widget.show.rating!.average.toString(),
                            style: oxygen(Colors.white, 18.sp, FontWeight.w400),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.show.type!,
                        style: oxygen(Colors.white, 16.sp, FontWeight.w400),
                      ),
                      Text(
                        formatHoursAndMinutes(
                          widget.show.runtime ?? 0,
                        ),
                        style: oxygen(Colors.grey, 16.sp, FontWeight.w400),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Text(
                    "Tags",
                    style: oxygen(Colors.white, 16.sp, FontWeight.bold),
                  ),
                  SizedBox(
                    height: 40.h,
                    child: ListView.builder(
                      itemCount: widget.show.genres == null
                          ? 0
                          : widget.show.genres!.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (BuildContext context, int index) {
                        return Padding(
                          padding: EdgeInsets.all(5.h),
                          child: Container(
                            padding: EdgeInsets.all(5.h),
                            decoration: BoxDecoration(
                                color: Colors.yellowAccent,
                                borderRadius: BorderRadius.circular(10.h)),
                            child: Text(
                              widget.show.genres![index],
                              style: oxygen(
                                  Colors.black, 14.sp, FontWeight.normal),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Text(
                    "About the show",
                    style: oxygen(Colors.white, 16.sp, FontWeight.bold),
                  ),
                  Text(
                    widget.show.summary == null
                        ? "No summary"
                        : htmlToPlainText(widget.show.summary!),
                    style: oxygen(Colors.white, 14.sp, FontWeight.w300),
                  ),
                  FutureBuilder(
                    future: getEpisode(),
                    builder: (context, snapshot) {
                      return snapshot.connectionState == ConnectionState.waiting
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 10.h,
                                ),
                                Text(
                                  "Previous Episode",
                                  style: oxygen(
                                      Colors.white, 16.sp, FontWeight.bold),
                                ),
                                SizedBox(
                                  height: 10.h,
                                ),
                                Shimmer.fromColors(
                                    baseColor: Colors.black,
                                    highlightColor: Colors.white,
                                    child: Container(
                                      height: 250.h,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10.h),
                                          color: Colors.black),
                                    ))
                              ],
                            )
                          : snapshot.data!.id != null
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: 10.h,
                                    ),
                                    Text(
                                      "Previous Episode",
                                      style: oxygen(
                                          Colors.white, 16.sp, FontWeight.bold),
                                    ),
                                    SizedBox(
                                      height: 10.h,
                                    ),
                                    Stack(
                                      children: [
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10.h),
                                          child: CachedNetworkImage(
                                            height: 250.h,
                                            fit: BoxFit.cover,
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            imageUrl: snapshot.data!.image ==
                                                    null
                                                ? ""
                                                : snapshot.data!.image!.medium!,
                                            errorWidget: (context, url, error) {
                                              return CachedNetworkImage(
                                                  height: 250.h,
                                                  fit: BoxFit.cover,
                                                  imageUrl:
                                                      "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQiUqGvs-Wgpbk4a8HcVMjOVeHJ7kiryV12xpX-WwjUty5NwqHlMTm4M1caosM6IYxkW9I&usqp=CAU");
                                            },
                                          ),
                                        ),
                                        Container(
                                          padding: EdgeInsets.all(10.h),
                                          height: 250.h,
                                          width:
                                              MediaQuery.of(context).size.width,
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              begin: Alignment.bottomCenter,
                                              end: Alignment.topCenter,
                                              colors: [
                                                Colors.black.withOpacity(
                                                    0.9), // Adjust opacity as needed
                                                Colors.transparent,
                                              ],
                                            ),
                                          ),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                snapshot.data!.name!,
                                                style: oxygen(Colors.white,
                                                    18.sp, FontWeight.bold),
                                              ),
                                              Text(
                                                htmlToPlainText(
                                                    snapshot.data!.summary ??
                                                        ""),
                                                maxLines: 3,
                                                overflow: TextOverflow.ellipsis,
                                                style: oxygen(Colors.white,
                                                    12.sp, FontWeight.w300),
                                              ),
                                              Text(
                                                "Season ${snapshot.data!.season!}",
                                                style: oxygen(Colors.white,
                                                    12.sp, FontWeight.normal),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                )
                              : const SizedBox.shrink();
                    },
                  ),
                ],
              ),
            ),
          )
        ],
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(5.h),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 10.h),
          decoration: BoxDecoration(
              color: Colors.yellowAccent,
              borderRadius: BorderRadius.circular(10.h)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.play_arrow,
                color: Colors.black,
                size: 24.sp,
              ),
              Text(
                " Play",
                style: oxygen(Colors.black, 18.sp, FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
