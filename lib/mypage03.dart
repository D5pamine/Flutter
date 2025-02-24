import 'package:flutter/material.dart';
import 'package:flyaid5pamine/login01.dart';
import 'package:flyaid5pamine/widgets/BottomNavi.dart';
import 'package:flyaid5pamine/widgets/CustomButton.dart';
import 'package:flyaid5pamine/widgets/CustomAppBar.dart';
import 'package:flyaid5pamine/widgets/MovieCard.dart';
import 'package:video_player/video_player.dart';

void main() {
  runApp(MyApp());
}

class Mypage03 extends StatefulWidget {
  @override
  _MyPage03State createState() => _MyPage03State();
}

class _MyPage03State extends State<Mypage03> {
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
      appBar: const CustomAppBar(),
      body: Padding(
        padding: const EdgeInsets.only(left: 20.0, top: 10.0, right: 20.0, bottom: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('3개의 저장 영상', style: TextStyle(fontWeight: FontWeight.w300, color: Color(0xFF000000))),
            const SizedBox(height: 10),
            SizedBox(
              height: 500,
              width: 315,
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column( // ✅ Column을 추가하여 여러 Moviecard 배치 가능
                  children: [
                    Moviecard(
                      controllers: controllers[0],
                      reportcontent: '신호 위반 (적색 신호에 교차로 통과)',
                      reportlocation: '서울특별시 강남구 도산대로 123',
                      reportreason: '도로교통법 제 5조 (신호준수 의무위반)',
                      reporttime: '2025년 2월 6일 오후 3시 45분',
                      reportdate: '2025.02.13',
                      cardLineColor: const Color(0xffFFB267),
                    ),
                    const SizedBox(height: 10),
                    Moviecard(
                      controllers: controllers[1],
                      reportcontent: '불법 유턴 (신호 위반 및 중앙선 침범)',
                      reportlocation: '서울특별시 서초구 반포대로 45',
                      reportreason: '도로교통법 제 13조 (중앙선 침범 금지)',
                      reporttime: '2025년 3월 10일 오후 2시 30분',
                      reportdate: '2025.03.11',
                    ),
                    const SizedBox(height: 10),
                    Moviecard(
                      controllers: controllers[2],
                      reportcontent: '보행자 보호 위반 (보행자 방해)',
                      reportlocation: '서울특별시 용산구 이태원로 50',
                      reportreason: '도로교통법 제 27조 (보행자 보호 의무)',
                      reporttime: '2025년 4월 5일 오후 1시 15분',
                      reportdate: '2025.04.06',
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ),
            CustomButton(
              buttonText: '상세보기',
              fontWeight: FontWeight.w600, onPressed: () {  },
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