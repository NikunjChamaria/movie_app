import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movie_app/screens/movie_detail.dart';
import 'package:movie_app/screens/splash_screen.dart';
import 'package:movie_app/utils/textstyle.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
            GridView.builder(
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
                              style:
                                  oxygen(Colors.white, 16.sp, FontWeight.w400),
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
          ],
        ),
      ),
    );
  }
}
