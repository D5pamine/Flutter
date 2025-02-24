import 'package:flutter/material.dart';
import 'package:flyaid5pamine/esg01.dart';
import 'package:flyaid5pamine/widgets/BottomNavi.dart';
import 'package:flyaid5pamine/widgets/CustomButton.dart';
import 'package:flyaid5pamine/widgets/WeeklyBarchart.dart';
import 'package:flyaid5pamine/login01.dart';
import 'package:flyaid5pamine/widgets/CustomAppBar.dart';
import 'package:video_player/video_player.dart';

import 'log02.dart';

void main() {
  runApp(MyApp());
}

class Home01 extends StatefulWidget {
  @override
  _Home01State createState() => _Home01State();
}

class _Home01State extends State<Home01> {
  List<VideoPlayerController> controllers = [];
  final now = DateTime.now(); // ✅ 현재 날짜 저장

  @override
  void initState() {
    super.initState();
    List<String> videoPaths = [
      "assets/videos/test1.mp4",
      "assets/videos/test2.mp4",
      "assets/videos/test3.mp4"
    ];

    print("Loading video paths: $videoPaths");  // ✅ 파일 목록 출력 확인

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
      appBar: const CustomAppBar(),
      body: Padding(
        padding: const EdgeInsets.only(left: 20.0, top: 00.0, right: 20.0, bottom: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Column(
                  children: [
                    Text('Hi, David👋',
                        style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600, color: Color(0xFF2F2F2F))),
                  ],
                ),
                const Spacer(),
                ClipRRect(
                  borderRadius: BorderRadius.circular(50.0),
                  child: const Image(
                    image: NetworkImage('https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg'),
                    width: 40,
                    height: 40,
                  ),
                ),
              ],
            ),
            // const SizedBox(height: 5),
            Row(
              children: [
                const Text('오늘의 안전 리포트',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Color(0xFF2F2F2F))),
                const Spacer(),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Log02()),
                    );
                  },
                  child: const Text('더보기 >',
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Color(0xFF888888))),
                ),
              ],
            ),
            Row(
              children: [
                CustomButton(
                  buttonText: '최근 검출 영상',
                  textWidth: 95.0,
                  textHeight: 40.0,
                  textSize: 11.0,
                  fontWeight: FontWeight.w600, onPressed: () {  },
                ),
                const SizedBox(width: 10),
                CustomButton(
                  buttonText: '과거 신고 영상',
                  textWidth: 95.0,
                  textHeight: 40.0,
                  textSize: 11.0,
                  fontWeight: FontWeight.w600,
                  backColor: const Color(0xffF0F3FA), onPressed: () {  },
                ),
              ],
            ),
            const SizedBox(height: 10),
            /// ✅ 비디오가 로드된 후에만 화면에 표시
            SingleChildScrollView(
              scrollDirection: Axis.horizontal, // ✅ 가로 스크롤 활성화
              child: Row(
                children: [
                  for (var i = 0; i < controllers.length; i++) // ✅ for 문으로 리스트 생성
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20), // ✅ 둥근 모서리 적용
                        child: SizedBox(
                          height: 160,  // ✅ 비디오 개별 높이 지정
                          child: AspectRatio(
                            aspectRatio:  18 / 12,
                            child: VideoPlayer(controllers[i]),  // ✅ 각 비디오 컨트롤러 사용
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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("나의 ESG 점수", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18, color: Color(0xFF2F2F2F)),),
                    Row(
                      children: [
                        Image.asset('assets/images/free-icon-leaf.png', height: 18,),
                        const SizedBox(width: 5,),
                        const Text("1544.00", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18, color: Color(0xFFFFB267)),),
                      ],
                    ),
                  ],
                ),
                const Spacer(),
                CustomButton(
                  buttonText: '자세히 보기',
                  textWidth: 95.0,
                  textHeight: 40.0,
                  textSize: 11.0,
                  fontWeight: FontWeight.w700,
                  backColor: const Color(0xffF0F3FA), onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Esg01()),
                  );
                },
                ),
              ],
            ),
            const SizedBox(height: 10,),
            Container(width: 500, height: 1, color: const Color(0xFFE9EEF8)),
            const SizedBox(height: 12,),
            const Row(
              children: [
                Center(child: Text("나의 신고 건수", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Color(0xFF2F2F2F)),)),
              ],
            ),
            const SizedBox(height: 15,),
            WeeklyBarChart(),
            // const SizedBox(height: 20,),
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