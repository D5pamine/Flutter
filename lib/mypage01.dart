import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flyaid5pamine/service/userdataget.dart';
import 'package:http/http.dart' as http;
import 'package:flyaid5pamine/widgets/BottomNavi.dart';
import 'package:flyaid5pamine/widgets/CustomButton.dart';
import 'package:flyaid5pamine/widgets/CustomAppBar.dart';
import 'package:flyaid5pamine/widgets/CustomCard.dart';
import 'package:video_player/video_player.dart';

import 'main.dart';

void main() {
  runApp(MyApp());
}

class MyPage01 extends StatefulWidget {
  @override
  _MyPage01State createState() => _MyPage01State();
}

class _MyPage01State extends State<MyPage01> {
  List<VideoPlayerController> controllers = [];
  bool isDarkMode = false;

  String username = "Loading...";
  String email = "Loading...";
  String phone = "Loading...";
  double egsScore = 0.0;

  @override
  void initState() {
    super.initState();
    fetchUserInfo(); // 사용자 정보 가져오기
    loadVideos([
      "assets/videos/test1.mp4",
      "assets/videos/test2.mp4",
      "assets/videos/test3.mp4"
    ]);
  }

  Future<void> fetchUserInfo() async {
    var userService = UserDataGet();
    var response = await userService.getUserInfo();

    if (response["statusCode"] == 200) {
      setState(() {
        username = response["data"]["username"];
        email = response["data"]["email"];
        phone = response["data"]["phone"];
        egsScore = response["data"]["egs_score"].toDouble();
      });
    } else {
      print("❌ Error fetching user info: ${response["error"]}");
    }
  }

  Future<void> loadVideos(List<String> paths) async {
    for (var path in paths) {
      try {
        var controller = VideoPlayerController.asset(path);
        await controller.initialize();
        controllers.add(controller);
        setState(() {});
      } catch (error) {
        print("❌ Error loading video $path: $error");
      }
    }
  }

  @override
  void dispose() {
    for (var controller in controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.arrow_back, color: Color(0xFFFFB267)),
                  ),
                  const Expanded(
                    child: Center(
                      child: Text(
                        "Profile",
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFFFFB267)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 48),
                ],
              ),
              CustomCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10.0),
                          child: const Image(
                            image: NetworkImage('https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg'),
                            width: 50,
                            height: 50,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(username, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 18)),
                            Row(
                              children: [
                                Image.asset('assets/images/free-icon-leaf.png', height: 18),
                                const SizedBox(width: 5),
                                Text(egsScore.toString(), style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 14)),
                              ],
                            ),
                          ],
                        ),
                        const Spacer(),
                        CustomButton(
                          buttonText: '수정',
                          textWidth: 70.0,
                          textHeight: 30.0,
                          textSize: 14.0,
                          backColor: const Color(0xffF0F3FA),
                          textColor: const Color(0xFFFFB267),
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              CustomCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.call, color: Color(0xFFFFB267), size: 20),
                        const SizedBox(width: 5),
                        Text(phone),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Container(width: 500, height: 1, color: const Color(0xFFE9EEF8)),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Icon(Icons.mail_outline, color: Color(0xFFFFB267), size: 20),
                        const SizedBox(width: 5),
                        Text(email),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              const Row(
                children: [
                  Text("설정", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20)),
                ],
              ),
              const SizedBox(height: 12),
              CustomCard(
                child: Row(
                  children: [
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("다크모드 off", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16)),
                        SizedBox(height: 2),
                        Text("실시간 블랙박스 영상 확인", style: TextStyle(fontWeight: FontWeight.w300, fontSize: 14, color: Color(0xFF4C5980))),
                      ],
                    ),
                    const Spacer(),
                    Switch(
                      value: isDarkMode,
                      onChanged: (value) {
                        setState(() {
                          isDarkMode = value;
                        });
                      },
                      activeColor: const Color(0xFFFFB267),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  const Text("저장한 영상", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20)),
                  const Spacer(),
                  TextButton(
                    onPressed: () {},
                    child: const Text('더보기 >', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Color(0xFFFFB267))),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const Padding(
        padding: EdgeInsets.only(bottom: 20.0),
        child: BottomNavi(),
      ),
    );
  }
}
