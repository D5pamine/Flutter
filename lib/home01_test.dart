import 'package:flutter/material.dart';
import 'package:flyaid5pamine/esg01.dart';
import 'package:flyaid5pamine/service/userdataget.dart';
import 'package:flyaid5pamine/service/videoget.dart';
import 'package:flyaid5pamine/widgets/BottomNavi.dart';
import 'package:flyaid5pamine/widgets/CustomButton.dart';
import 'package:flyaid5pamine/widgets/WeeklyBarchart.dart';
import 'package:flyaid5pamine/main.dart';
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
  List<Map<String, dynamic>> videoList = []; // FastAPI에서 가져온 영상 데이터 리스트
  List<int> detectedIdList = [];
  final now = DateTime.now(); // 현재 날짜 저장
  String username = "Loading...";
  String userId = "Loading...";
  double egsScore = 0.0;
  List<String> videoPaths = [];

  @override
  void initState() {
    super.initState();
    fetchUserInfo(); // 사용자 정보 가져오기
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
        username = response["data"]["username"];
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

  Future<void> fetchVideos() async {
    if (userId == "Loading..." || userId.isEmpty) {
      print("⏳ userId를 가져오는 중... 영상 요청을 보류합니다.");
      return;
    } else {
      print("영상 요청을 실행합니다 멘탈 잡으세요");
    }

    var videoService = Videoget();
    var response = await videoService.getUserVideo(userId);

    print("fetchVideos 함수는 됨");

    if (response["statusCode"] == 200) {
      print("📹 영상 리스트: ${response["data"]}");
      setState(() {
        videoList = List<Map<String, dynamic>>.from(response["data"]);
        detectedIdList = videoList
            .map((video) => video["detected_id"] as int)
            .toList();
        print("✅ 영상 번호 가져오기: $detectedIdList");
      });
      await fetchAndLoadVideos();
    } else {
      print(response["error"]);
    }
  }

  Future<void> fetchAndLoadVideos() async {
    for (var detectedId in detectedIdList) {
      // 개별 ID로 API 요청하여 비디오 URL 가져오기
      String? videoUrl = await VideoStream().streamUserVideo(detectedId);
      print("🔍 요청한 detectedId: $detectedId");
      print("📥 가져온 비디오 URL: ${videoUrl}");
      if (videoUrl == null || videoUrl.isEmpty) {
        print("❌ 유효하지 않은 비디오 URL입니다. detectedId: $detectedId");
      } else {
        videoPaths.add(videoUrl);
        print("🔍 현재 비디오 경로 현황: $videoPaths");
      }
    }
    setState(() {}); // 영상 경로 로딩 완료 후 UI 업데이트
  }

  @override
  void dispose() {
    // 각 VideoItemWidget이 개별적으로 controller를 dispose하므로 여기서는 별도 처리 X
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body: Padding(
        padding:
        const EdgeInsets.only(left: 20.0, top: 0.0, right: 20.0, bottom: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 상단 인사 및 사용자 정보 영역
            Row(
              children: [
                const Column(
                  children: [
                    Text('Hi, David👋',
                        style: TextStyle(
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
                        MaterialPageRoute(builder: (context) => Log02()));
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
            // videoPaths에 있는 모든 영상을 가로 스크롤 리스트로 표시
            videoPaths.isNotEmpty
                ? SizedBox(
              height: 160, // 비디오 컨테이너 높이 지정
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: videoPaths.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20), // 둥근 모서리 적용
                      child: SizedBox(
                        height: 160,
                        child: AspectRatio(
                          aspectRatio: 18 / 12, // 고정 aspect ratio 18:12 적용
                          child: VideoItemWidget(videoUrl: videoPaths[index]),
                        ),
                      ),
                    ),
                  );
                },
              ),
            )
                : const Center(child: CircularProgressIndicator()),

            const SizedBox(height: 3),
            // ESG 점수 및 신고 건수 영역
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
                        Image.asset('assets/images/free-icon-leaf.png', height: 18),
                        const SizedBox(width: 5),
                        const Text("1544.00",
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

class VideoItemWidget extends StatefulWidget {
  final String videoUrl;
  const VideoItemWidget({Key? key, required this.videoUrl}) : super(key: key);

  @override
  _VideoItemWidgetState createState() => _VideoItemWidgetState();
}

class _VideoItemWidgetState extends State<VideoItemWidget> {
  VideoPlayerController? _itemController;

  @override
  void initState() {
    super.initState();
    _itemController = VideoPlayerController.network(widget.videoUrl)
      ..initialize().then((_) {
        setState(() {});
      });
  }

  @override
  void dispose() {
    _itemController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20), // 둥근 모서리 적용
        child: SizedBox(
          height: 160,
          child: AspectRatio(
            aspectRatio: _itemController?.value.isInitialized == true
                ? _itemController!.value.aspectRatio
                : 16 / 9, // 기본 aspect ratio 설정
            child: _itemController?.value.isInitialized == true
                ? VideoPlayer(_itemController!)
                : const Center(child: CircularProgressIndicator()),
          ),
        ),
      ),
    );
  }
}
