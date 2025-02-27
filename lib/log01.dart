import 'package:flutter/material.dart';
import 'package:flyaid5pamine/service/userdataget.dart';
import 'package:flyaid5pamine/service/videoget.dart';
import 'package:flyaid5pamine/widgets/BottomNavi.dart';
import 'package:flyaid5pamine/widgets/CustomAppBar.dart';
import 'package:flyaid5pamine/widgets/CustomButton.dart';
import 'package:flyaid5pamine/widgets/MovieCard.dart';
import 'package:video_player/video_player.dart';

import 'detail01.dart';
import 'main.dart';

void main() {
  runApp(MyApp());
}

class Log01 extends StatefulWidget {
  @override
  _Log01State createState() => _Log01State();
}

class _Log01State extends State<Log01> {
  // 여러 영상에 대한 컨트롤러들을 저장할 리스트
  List<VideoPlayerController> _controllers = [];
  List<Map<String, dynamic>> videoList = []; // FastAPI에서 가져온 영상 데이터 리스트
  List<int> detectedIdList = [];
  final now = DateTime.now();
  var car_num = "Loading...";
  String location = "Loading...";
  String violation = "Loading...";
  String time = "Loading...";
  String username = "Loading...";
  String userId = "Loading...";
  List<String> videoPaths = [];
  int selectedMovieCardIndex = -1;
  int choseVideo = 0;

  @override
  void initState() {
    super.initState();
    fetchUserInfo();
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
        print("✅ fetchVideos 데이터 가져오기: $videoList");
      });
      await fetchAndLoadVideos();
      if (videoPaths.isNotEmpty) {
        await initializeVideoControllers();
      }
    } else {
      print(response["error"]);
    }
  }

  Future<void> fetchAndLoadVideos() async {
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
    print("🔍 최종 비디오 경로 현황: $videoPaths");
  }

  Future<void> initializeVideoControllers() async {
    // 기존 컨트롤러 dispose
    for (var ctrl in _controllers) {
      await ctrl.dispose();
    }
    _controllers.clear();

    // videoPaths의 각 URL마다 컨트롤러를 생성 및 초기화
    for (var url in videoPaths) {
      VideoPlayerController controller = VideoPlayerController.network(url);
      await controller.initialize();
      _controllers.add(controller);
    }
    setState(() {});
  }

  @override
  void dispose() {
    // 모든 컨트롤러 dispose
    for (var ctrl in _controllers) {
      ctrl.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body: Padding(
        padding: const EdgeInsets.only(left: 20.0, top: 10.0, right: 20.0, bottom: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${_controllers.length} 개의 새로운 이벤트',
              style: const TextStyle(
                fontWeight: FontWeight.w300,
                color: Color(0xFF000000),
              ),
            ),
            const SizedBox(height: 10),
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
                  buttonText: '최근 신고 영상',
                  textWidth: 95.0,
                  textHeight: 40.0,
                  textSize: 11.0,
                  fontWeight: FontWeight.w600,
                  backColor: const Color(0xffF0F3FA),
                  onPressed: () {},
                ),
              ],
            ),
            const SizedBox(height: 10),
            // Moviecard 리스트를 세로 스크롤로 표시
            SizedBox(
              height: 420,
              width: 315,
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  children: [
                    for (var i = 0; i < detectedIdList.length; i++) ...[
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedMovieCardIndex = i;
                            print("✅ 사용자가 선택한 영상 번호: ${detectedIdList[i]}");
                            choseVideo = detectedIdList[selectedMovieCardIndex];
                          });
                        },
                      child: Builder(
                        builder: (context) {
                          // 인덱스별로 videoList의 'time' 값을 콘솔에 출력
                          if(_controllers.length > i)
                            print("Index $i, time: ${_controllers[i]}");
                          return _controllers.length > i
                              ? Moviecard(
                            controllers: _controllers[i],
                            reportcontent: videoList[i]['car_num'].toString(),
                            reportlocation: videoList[i]['location'].toString(),
                            reportreason: videoList[i]['violation'].toString(),
                            reporttime: videoList[i]['time'].toString().split('T')[1],
                            reportdate: videoList[i]['time'].toString().split('T')[0],
                            cardLineColor: selectedMovieCardIndex == i
                              ? const Color(0xffFFB267)
                                : const Color(0xffD2D2D2),
                          )
                              : const Center(child: CircularProgressIndicator());
                          },
                        ),
                      ),
                      const SizedBox(height: 10),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            CustomButton(
              buttonText: '상세보기',
              fontWeight: FontWeight.w600,
              onPressed: () {
                int detectedId = videoList[0]['detected_id'];
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Detail01(detectedId: choseVideo,)));
              },
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
