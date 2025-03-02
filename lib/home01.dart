import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flyaid5pamine/esg01.dart';
import 'package:flyaid5pamine/log01.dart';
import 'package:flyaid5pamine/service/userdataget.dart';
import 'package:flyaid5pamine/service/videoget.dart';
import 'package:flyaid5pamine/widgets/BottomNavi.dart';
import 'package:flyaid5pamine/widgets/CustomButton.dart';
import 'package:flyaid5pamine/widgets/WeeklyBarchart.dart';
import 'package:flyaid5pamine/main.dart';
import 'package:flyaid5pamine/widgets/CustomAppBar.dart';
import 'package:video_player/video_player.dart';

import 'home01_test.dart';
import 'log02.dart';

void main() {
  runApp(MyApp());
}

class Home01 extends StatefulWidget {
  @override
  _Home01State createState() => _Home01State();
}

class _Home01State extends State<Home01> {
  VideoPlayerController? _controller; // nullable로 선언
  List<Map<String, dynamic>> videoList = []; // FastAPI에서 가져온 영상 데이터 리스트
  List<int> detectedIdList = [];
  final now = DateTime.now(); // 현재 날짜 저장
  String username = "Loading...";
  String userId = "Loading...";
  double egsScore = 0.0;
  List<String> videoPaths = [];
  Timer? _timer; // 주기적 갱신을 위한 타이머

  @override
  void initState() {
    super.initState();
    fetchUserInfo(); // 사용자 정보 가져오기
    // 초기 로딩 시 기본 알림(예시)
    showSnackbar();
    // 일정 주기마다 영상 목록을 갱신 (예: 60초마다)
    _timer = Timer.periodic(Duration(seconds: 60), (timer) {
      fetchVideos();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller?.dispose();
    super.dispose();
  }

  // 유저 정보 가져오기
  Future<void> fetchUserInfo() async {
    print("🚀 fetchUserInfo() 실행 시작");

    var userService = UserDataGet();
    var response;

    try {
      response = await userService.getUserInfo();
      print("🔍 API 응답 받음: $response");
    } catch (e, stacktrace) {
      print("❌ fetchUserInfo()에서 예외 발생: $e");
      print("🛑 Stacktrace: $stacktrace");
      return;
    }

    if (response != null && response["statusCode"] == 200) {
      print("✅ 사용자 정보 정상 수신");
      setState(() {
        username = response["data"]["username"].substring(1);
        userId = response["data"]["user_id"];
        // egsScore = response["data"]["egs_score"];
      });

      print("🔍 fetchVideos() 실행 전, userId 값: $userId");
      fetchVideos();
      print("✅ fetchVideos() 실행됨");
    } else {
      print("❌ Error fetching user info: ${response?["error"] ?? "응답 없음"}");
    }
  }

  // 새 영상 업로드 시 알림용 스낵바 함수
  void showNewVideoAlert() {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("새 영상이 업로드 되었습니다."),
          duration: const Duration(seconds: 3),
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(20),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    }
  }

  // 초기 로딩 시 기본 알림 (예시)
  void showSnackbar() {
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text("🚀 전방에 스텔스 차량이 감지되었습니다."),
            duration: const Duration(seconds: 3),
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.all(20),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );
      }
    });
  }

  Future<void> fetchVideos() async {
    if (userId == "Loading..." || userId.isEmpty) {
      print("⏳ userId를 가져오는 중... 영상 요청을 보류합니다.");
      return; // userId가 아직 준비되지 않았다면 실행하지 않음
    } else {
      print("영상 요청을 실행합니다 멘탈 잡으세요");
    }

    var videoService = Videoget();
    var response = await videoService.getUserVideo(userId);

    print("fetchVideos 함수는 됨");

    if (response["statusCode"] == 200) {
      print("📹 영상 리스트: ${response["data"]}");

      // 새로 받아온 영상 목록
      List<Map<String, dynamic>> newVideoList =
      List<Map<String, dynamic>>.from(response["data"]);

      // 기존 목록이 있을 때 새 영상이 추가되었다면 알림 표시
      if (videoList.isNotEmpty && newVideoList.length > videoList.length) {
        showNewVideoAlert();
      }

      setState(() {
        videoList = newVideoList; // 리스트 저장
        detectedIdList = videoList
            .map((video) => video["detected_id"] as int)
            .toList();
        print("✅ 영상 번호 가져오기: $detectedIdList");
      });

      await fetchAndLoadVideos();

      if (videoPaths.isNotEmpty) {
        initializeVideoPlayer();
      }
    } else {
      print(response["error"]);
    }
  }

  Future<void> fetchAndLoadVideos() async {
    videoPaths.clear();
    for (var detectedId in detectedIdList) {
      String? videoUrl = await VideoStream().streamUserVideo(detectedId);

      print("🔍 요청한 detectedId: $detectedId");
      print("📥 가져온 비디오 URL: ${videoUrl ?? '❌ URL 없음'}");

      if (videoUrl == null || videoUrl.isEmpty) {
        print("❌ 유효하지 않은 비디오 URL입니다. detectedId: $detectedId");
      } else {
        videoPaths.add(videoUrl);
        print("🔍 현재 비디오 경로 현황: $videoPaths");
      }
    }
    // 예시: 추가 URL (테스트 용도)
    videoPaths.add('http://192.168.35.8:8000/video-stream/11');
    print("🔍 최종 비디오 경로 현황: $videoPaths");
  }

  void initializeVideoPlayer() {
    // videoPaths의 첫 번째 URL로 _controller 초기화
    _controller = VideoPlayerController.network(videoPaths[0])
      ..initialize().then((_) {
        setState(() {
          // 초기화 후 UI 갱신
        });
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body: Padding(
        padding: const EdgeInsets.only(
            left: 20.0, top: 0.0, right: 20.0, bottom: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Column(
                  children: [
                    Text("반가워요, $username님",
                        style: const TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF2F2F2F))),
                  ],
                ),
                const Spacer(),
                ClipRRect(
                  borderRadius: BorderRadius.circular(50.0),
                  child: const Image(
                    image: NetworkImage(
                        'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg'),
                    width: 40,
                    height: 40,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                const Text('오늘의 안전 리포트',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF2F2F2F))),
                const Spacer(),
                TextButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Log01()));
                  },
                  child: const Text('더보기 >',
                      style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF888888))),
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
                  fontWeight: FontWeight.w600,
                  onPressed: () {},
                ),
                const SizedBox(width: 10),
                CustomButton(
                  buttonText: '과거 신고 영상',
                  textWidth: 95.0,
                  textHeight: 40.0,
                  textSize: 11.0,
                  fontWeight: FontWeight.w600,
                  backColor: const Color(0xffF0F3FA),
                  onPressed: () {},
                ),
              ],
            ),
            const SizedBox(height: 4),
            /// 비디오가 로드된 후에만 화면에 표시
            Center(
              child: _controller != null && _controller!.value.isInitialized
                  ? Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: SizedBox(
                    height: 160,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: videoPaths.length,
                      itemBuilder: (context, index) {
                        return SizedBox(
                          width: 240,
                          child: VideoItemWidget(videoUrl: videoPaths[index]),
                        );
                      },
                    ),
                  ),
                ),
              )
                  : const Center(child: CircularProgressIndicator()),
            ),
            const SizedBox(height: 3),
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("나의 ESG 점수",
                        style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 18,
                            color: Color(0xFF2F2F2F))),
                    Row(
                      children: [
                        Image.asset('assets/images/free-icon-leaf.png',
                            height: 18),
                        const SizedBox(width: 5),
                        const Text("0.0",
                            style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 18,
                                color: Color(0xFFFFB267))),
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
                  backColor: const Color(0xffF0F3FA),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Esg01()));
                  },
                ),
              ],
            ),
            const SizedBox(height: 10),
            Container(width: 500, height: 1, color: const Color(0xFFE9EEF8)),
            const SizedBox(height: 12),
            const Row(
              children: [
                Center(
                    child: Text("나의 신고 건수",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF2F2F2F)))),
              ],
            ),
            const SizedBox(height: 15),
            WeeklyBarChart(),
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
