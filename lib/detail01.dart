import 'package:flutter/material.dart';
import 'package:flyaid5pamine/report01.dart';
import 'package:flyaid5pamine/report02.dart';
import 'package:flyaid5pamine/service/userdataget.dart';
import 'package:flyaid5pamine/service/videoget.dart';
import 'package:flyaid5pamine/widgets/BottomNavi.dart';
import 'package:flyaid5pamine/widgets/CustomButton.dart';
import 'package:flyaid5pamine/widgets/CustomColorBox.dart';
import 'package:flyaid5pamine/widgets/CustomIconText.dart';
import 'package:flyaid5pamine/write01.dart';
import 'package:video_player/video_player.dart';

import 'detail02.dart';
import 'home01_test.dart';
import 'log01.dart';
import 'main.dart';

void main() {
  runApp(MyApp());
}

class Detail01 extends StatefulWidget {
  final int detectedId;

  const Detail01({Key? key, required this.detectedId}) : super(key: key);

  @override
  _Detail01State createState() => _Detail01State();
}

class _Detail01State extends State<Detail01> {
  VideoPlayerController? _controller;
  List<Map<String, dynamic>> videoList = [];
  List<int> detectedIdList = [];
  final now = DateTime.now();
  String car_num = "Loading...";
  String location = "Loading...";
  String violation = "Loading...";
  String time = "Loading...";
  String time_day = "";
  String username = "Loading...";
  String userId = "Loading...";
  List<String> videoPaths = [];
  String finalurl = "";
  bool isPlaying = false; // 🎬 플레이 상태 추적
  int detected_id = 0;

  @override
  void initState() {
    super.initState();
    fetchUserInfo();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  void initializeVideoPlayer() {
    _controller = VideoPlayerController.networkUrl(Uri.parse(finalurl))
      ..initialize().then((_) {
        if (mounted) {
          setState(() {}); // UI 갱신
        }
      });
  }

  Future<void> fetchUserInfo() async {
    var userService = UserDataGet();
    var response;

    try {
      response = await userService.getUserInfo();
    } catch (e, stacktrace) {
      print("❌ fetchUserInfo() 예외 발생: $e");
      print("🛑 Stacktrace: $stacktrace");
      return;
    }

    if (response != null && response["statusCode"] == 200) {
      setState(() {
        username = response["data"]["username"];
        userId = response["data"]["user_id"];
      });

      fetchVideos();
    } else {
      print("❌ 사용자 정보 가져오기 실패: ${response?["error"] ?? "응답 없음"}");
    }
  }

  Future<void> fetchVideos() async {
    if (userId == "Loading..." || userId.isEmpty) {
      return;
    }

    var videoService = Videoget();
    var response = await videoService.getUserVideo(userId);

    if (response["statusCode"] == 200) {
      setState(() {
        videoList = List<Map<String, dynamic>>.from(response["data"]);
        detectedIdList = videoList.map((video) => video["detected_id"] as int).toList();

        var matchedVideo = videoList.firstWhere(
              (video) => video['detected_id'] == widget.detectedId,
          orElse: () => {},
        );

        if (matchedVideo.isNotEmpty) {
          car_num = matchedVideo['car_num'];
          location = matchedVideo['location'];
          violation = matchedVideo['violation'];
          time = matchedVideo['time'];
          time_day = time.split('T')[0];
          detected_id = matchedVideo['detected_id'];
          finalurl = 'http://192.168.11.42:8000/video-stream/$detected_id';
        }

        initializeVideoPlayer();
      });

      await fetchAndLoadVideos();
    } else {
      print(response["error"]);
    }
  }

  Future<void> fetchAndLoadVideos() async {
    for (var detectedId in detectedIdList) {
      String? videoUrl = await VideoStream().streamUserVideo(detectedId);

      if (videoUrl != null && videoUrl.isNotEmpty) {
        if (detectedId == widget.detectedId) {
          videoPaths.add(videoUrl);
          finalurl = videoUrl;
        }
      }
    }
  }

  void togglePlayPause() {
    setState(() {
      if (_controller!.value.isPlaying) {
        _controller?.pause();
        isPlaying = false;
      } else {
        _controller?.play();
        isPlaying = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(left: 20.0, top: 40.0, right: 20.0, bottom: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    height: 300,
                    width: 320,
                    child: _controller == null || !_controller!.value.isInitialized
                        ? const Center(child: CircularProgressIndicator()) // 🔹 비디오가 준비되지 않으면 로딩 표시
                        : AspectRatio(
                      aspectRatio: _controller!.value.aspectRatio,
                      child: VideoPlayer(_controller!),
                    ),
                  ),
                  Positioned(
                    top: 10,
                    left: 10,
                    child: CircleAvatar(
                      backgroundColor: Colors.black54,
                      radius: 20,
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back),
                        color: Colors.white,
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ),
                  if (_controller != null && _controller!.value.isInitialized)
                    GestureDetector(
                      onTap: () {
                        if (_controller != null && _controller!.value.isInitialized) {
                          togglePlayPause();
                        }
                      },
                      child: AnimatedOpacity(
                        opacity: isPlaying ? 0.0 : 1.0,
                        duration: const Duration(milliseconds: 300),
                        child: CircleAvatar(
                          backgroundColor: Colors.black54,
                          radius: 30,
                          child: Icon(
                            isPlaying ? Icons.pause : Icons.play_arrow,
                            color: Colors.white,
                            size: 40,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 15),
            Row(
              children: [
                Text(time.split('T')[0], style: const TextStyle(fontSize: 30, fontWeight: FontWeight.w600)),
                const Spacer(),
                const Icon(Icons.location_on, color: Color(0xFF848282)),
                const SizedBox(width: 3),
                Text(location.split(' ')[0], style: const TextStyle(fontSize: 16, color: Color(0xFF848282))),
              ],
            ),
            const SizedBox(height: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const CustomColorBox(
                      boxWidth: 35,
                      boxHeight: 35,
                      boxColor: Color(0xFFEDEDED),
                      customIcon: Icon(Icons.watch_later),
                    ),
                    CustomIconText(
                      boxWidth: 35,
                      boxHeight: 35,
                      boxColor: const Color(0xFFEDEDED),
                      customText: time.contains('T') ? time.split('T')[1] : "시간 없음",
                      customIcon: const Icon(Icons.watch_later),
                    ),
                    const SizedBox(width: 20),
                    Row(
                      children: [
                        const CustomColorBox(
                          boxWidth: 35,
                          boxHeight: 35,
                          boxColor: Color(0xFFEDEDED),
                          customIcon: Icon(Icons.car_crash),
                        ),
                        CustomIconText(
                          boxWidth: 35,
                          boxHeight: 35,
                          boxColor: const Color(0xFFEDEDED),
                          customText: car_num,
                          customIcon: const Icon(Icons.car_crash),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const CustomColorBox(
                      boxWidth: 35,
                      boxHeight: 35,
                      boxColor: Color(0xFFEDEDED),
                      customIcon: Icon(Icons.star),
                    ),
                    const SizedBox(width: 5,),
                    CustomIconText(
                      boxWidth: 35,
                      boxHeight: 35,
                      boxColor: const Color(0xFFEDEDED),
                      customText: violation,
                      customIcon: const Icon(Icons.star),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Text(location.split(' ')[0], style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                    const SizedBox(width: 5,),
                    Text('$violation 신고', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                  ],
                ),
                const SizedBox(height: 5),
                SizedBox(
                  height: 79,
                  width: 315,
                  child: SingleChildScrollView(
                    child: Text(
                      '영상에서는 $car_num 차량의 $violation 장면이 기록되어 있습니다. 이는 교차로 내 사고 위험을 초래한 명백한 도로교통법 위반 사례입니다.',
                      style: const TextStyle(color: Color(0xFF848282)),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                CustomButton(
                  buttonText: '수정하기',
                  textWidth: 155,
                  fontWeight: FontWeight.w600,
                  backColor: const Color(0xffF0F3FA),
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => Write01(detectedId: widget.detectedId,)));
                  },
                ),
                const SizedBox(width: 10,),
                CustomButton(
                  buttonText: '신고하기',
                  textWidth: 155,
                  fontWeight: FontWeight.w600,
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => Report01()));
                  },
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: const Padding(
        padding: EdgeInsets.only(bottom: 20.0),
        child: BottomNavi(),
      ),
    );
  }

}
