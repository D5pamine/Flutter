import 'package:flutter/material.dart';
import 'package:flyaid5pamine/report01.dart';
import 'package:flyaid5pamine/widgets/BottomNavi.dart';
import 'package:flyaid5pamine/widgets/CustomButton.dart';
import 'package:flyaid5pamine/widgets/CustomIconText.dart';
import 'package:flyaid5pamine/write01.dart';
import 'package:video_player/video_player.dart';

import 'login01.dart';

void main() {
  runApp(MyApp());
}

class Detail01 extends StatefulWidget {
  @override
  _Detail01 createState() => _Detail01();
}

class _Detail01 extends State<Detail01> {
  List<VideoPlayerController> controllers = [];
  final now = DateTime.now();

  @override
  void initState() {
    super.initState();
    List<String> videoPaths = [
      "assets/videos/test1.mp4",
      "assets/videos/test2.mp4",
      "assets/videos/test3.mp4"
    ];
    print("Loading video paths: $videoPaths");
    loadVideos(videoPaths);
  }

  Future<void> loadVideos(List<String> paths) async {
    for (var path in paths) {
      try {
        var controller = VideoPlayerController.asset(path);
        await controller.initialize();  // ✅ 비디오가 완전히 초기화된 후 다음으로 진행
        controllers.add(controller);
        setState(() {});
        print("✅ Loaded video: $path");  // ✅ 정상적으로 로드된 비디오 출력
      } catch (error) {
        print("❌ Error loading video $path: $error");  // ✅ 오류 발생 시 출력
      }
    }
  }

  @override
  void dispose() {
    for (var controller in controllers) {
      controller.dispose();  // ✅ 각 컨트롤러에 대해 개별적으로 dispose() 실행
    }
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(padding: const EdgeInsets.only(left: 20.0, top: 40.0, right: 20.0, bottom: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child:
              Stack(
                children: [
                  SizedBox(
                    height: 300,  // ✅ 비디오 개별 높이 지정
                    child: AspectRatio(
                      aspectRatio:  18 / 12,
                      child: VideoPlayer(controllers[0]),  // ✅ 각 비디오 컨트롤러 사용),
                    ),
                  ),
                  Positioned(
                    top: 10,  // 🔹 위쪽 여백 조절
                    left: 10,  // 🔹 왼쪽 여백 조절
                    child: CircleAvatar(
                      backgroundColor: Colors.black54,  // 🔹 반투명 검정 배경
                      radius: 20,
                      child: IconButton(icon: const Icon(Icons.arrow_back), color: Colors.white, onPressed: () {},),
                    ),
                  ),
                  Positioned(
                    top: 10,
                    right: 10,
                    child: CircleAvatar(
                      backgroundColor: Colors.black54,
                      radius: 20,
                      child: IconButton(icon: const Icon(Icons.bookmark), color: Colors.white, onPressed: () {},),
                    ),
                  ),
                  Positioned(
                    bottom: 10, // 🔹 비디오 하단에서 10px 위쪽에 배치
                    left: 0,   // 🔹 왼쪽 정렬
                    right: 0,  // 🔹 오른쪽 정렬 -> 이렇게 하면 중앙 정렬됨
                    child: Align(
                      alignment: Alignment.center, // 🔹 가운데 정렬
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 5),
                        decoration: BoxDecoration(
                          color: Colors.black54, // 🔹 반투명한 배경색
                          borderRadius: BorderRadius.circular(20), // 🔹 둥근 모서리
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min, // 🔹 내용 크기에 맞게 조정
                          children: [
                            IconButton(
                              icon: const Icon(Icons.fast_rewind, color: Colors.white),
                              onPressed: () {
                                print("⏪ 뒤로 감기");
                              },
                            ),
                            IconButton(
                              icon: Icon(
                                controllers[0].value.isPlaying ? Icons.pause : Icons.play_arrow,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                setState(() {
                                  controllers[0].value.isPlaying
                                      ? controllers[0].pause()
                                      : controllers[0].play();
                                });
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.fast_forward, color: Colors.white),
                              onPressed: () {
                                print("⏩ 앞으로 감기");
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                ],
              ),
            ),
            const SizedBox(height: 15,),
            const Row(
              children: [
                Text('2025.02.13', style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600),),
                Spacer(),
                Icon(Icons.location_on, color: Color(0xFF848282),),
                SizedBox(width: 3,),
                Text('마포대교', style: TextStyle(fontWeight: FontWeight.w300, fontSize: 16,color: Color(0xFF848282)),),
              ],
            ),
            const SizedBox(height: 12,),
            const SizedBox(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CustomIconText(
                        boxWidth: 35,
                        boxHeight: 35,
                        boxColor: const Color(0xFFEDEDED),
                        customText: '15:26',
                        customIcon:const Icon(Icons.watch_later),
                      ),
                      const SizedBox(width: 20,),
                      const CustomIconText(
                          boxWidth: 35,
                          boxHeight: 35,
                          boxColor: Color(0xFFEDEDED),
                          customText: '서울 12가 3456',
                          customIcon:Icon(Icons.car_crash)
                      ),
                    ],
                  ),
                  const SizedBox(height: 10,),
                  const CustomIconText(
                      boxWidth: 35,
                      boxHeight: 35,
                      boxColor: Color(0xFFEDEDED),
                      customText: '칼치기, 신호 위반, 과속',
                      customIcon:Icon(Icons.star)
                  ),
                  const SizedBox(height: 10,),
                  const Text('2월 13일 마포대교 칼치기', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),),
                  const SizedBox(height: 5,),
                  const SizedBox(
                    height: 100,
                    width: 315,
                    child: SingleChildScrollView( // 🔹 스크롤 가능하게 설정
                      child: Text(
                        '영상에서는 [서울 12가 3456] 차량이 신호를 무시하고 적색 신호에 교차로를 통과하는 장면이 기록되어 있습니다. 이는 교차로 내 사고 위험을 초래한 명백한 신호 위반 사례입니다.',
                        style: TextStyle(color: Color(0xFF848282)),
                      ),
                    ),
                  ),

                ],
              ),
            ),
            Row(
              children: [
                CustomButton(
                  buttonText: '수정하기',
                  textWidth: 155,
                  fontWeight: FontWeight.w600,
                  backColor: const Color(0xffF0F3FA), onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Write01()),
                  );
                },
                ),
                const SizedBox(width: 10,),
                CustomButton(
                  buttonText: '신고하기',
                  textWidth: 155,
                  fontWeight: FontWeight.w600, onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Report01()),
                  );
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

