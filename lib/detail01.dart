import 'package:flutter/material.dart';
import 'package:flyaid5pamine/report01.dart';
import 'package:flyaid5pamine/service/userdataget.dart';
import 'package:flyaid5pamine/service/videoget.dart';
import 'package:flyaid5pamine/widgets/BottomNavi.dart';
import 'package:flyaid5pamine/widgets/CustomButton.dart';
import 'package:flyaid5pamine/widgets/CustomIconText.dart';
import 'package:flyaid5pamine/write01.dart';
import 'package:video_player/video_player.dart';

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
  String finalurl = "";

  @override
  void initState() {
    super.initState();
    fetchUserInfo();
    fetchAndLoadVideos();
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
        // widget.detectedId와 일치하는 영상 데이터 찾기
        var matchedVideo = videoList.firstWhere(
              (video) => video['detected_id'] == widget.detectedId,
          orElse: () => {},
        );
        if (matchedVideo.isNotEmpty) {
          // 예시: car_num 값을 출력
          print("일치하는 영상의 car_num: ${matchedVideo['car_num']}");
          print("일치하는 영상의 location: ${matchedVideo['location']}");
          print("일치하는 영상의 violation: ${matchedVideo['violation']}");
          print("일치하는 영상의 time: ${matchedVideo['time']}");
          print("일치하는 영상의 time: ${matchedVideo['time']}");

          car_num = matchedVideo['car_num'];
          location = matchedVideo['location'];
          violation = matchedVideo['violation'];
          time = matchedVideo['time'];
        }
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
        if (detectedId == widget.detectedId) { // 여기서 detectedId를 직접 비교합니다.
          videoPaths.add(videoUrl);
          print("🔍 현재 비디오 경로 현황: $videoPaths");
          print(videoUrl);
          finalurl = videoUrl;
          print("🔍 최종 경로: $finalurl");
        }
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

    // 비디오 컨트롤러 초기화 (비동기 처리)
    for (var url in videoPaths) {
      VideoPlayerController controller = VideoPlayerController.network(url);

      // 🔥 컨트롤러 상태가 변경될 때 자동으로 UI 업데이트
      controller.addListener(() {
        if (mounted) {
          setState(() {});
        }
      });

      await controller.initialize(); // ✅ 비디오 초기화
      _controllers.add(controller);
    }

    if (_controllers.isNotEmpty) {
      _controllers[0].play(); // ✅ 첫 번째 비디오 자동 재생
    }

    setState(() {}); // ✅ UI 업데이트
  }


  @override
  void dispose() {
    // 모든 컨트롤러 dispose
    for (var ctrl in _controllers) {
      ctrl.dispose();
    }
    super.dispose();
  }


  Widget build(BuildContext context) {
    if (_controllers.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: Text('상세보기 - ID: ${widget.detectedId}'),
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }
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
                    height: 300,  // 비디오 영역 높이 지정
                    child: AspectRatio(
                      aspectRatio: 18 / 12,
                      child: videoPaths.isEmpty
                          ? const Center(child: CircularProgressIndicator())
                          : VideoItemWidget(videoUrl: videoPaths[0]),
                      ),
                    ),
                  Positioned(
                    top: 10,  // 🔹 위쪽 여백 조절
                    left: 10,  // 🔹 왼쪽 여백 조절
                    child: CircleAvatar(
                      backgroundColor: Colors.black54,  // 🔹 반투명 검정 배경
                      radius: 20,
                      child: IconButton(icon: const Icon(Icons.arrow_back),
                        color: Colors.white,
                        onPressed: () {
                          Navigator.pop(context);
                        },),
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
                                _controllers[0].value.isPlaying ? Icons.pause : Icons.play_arrow,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                setState(() {
                                  _controllers[0].value.isPlaying
                                      ? _controllers[0].pause()
                                      : _controllers[0].play();
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
            Row(
              children: [
                Text(time.toString().split('T')[0], style: const TextStyle(fontSize: 30, fontWeight: FontWeight.w600),),
                const Spacer(),
                const Icon(Icons.location_on, color: Color(0xFF848282),),
                const SizedBox(width: 3,),
                Text(location.split(' ')[0], style: const TextStyle(fontWeight: FontWeight.w300, fontSize: 16,color: Color(0xFF848282)),),
                const Text(" "),
                Text(location.split(' ')[1], style: const TextStyle(fontWeight: FontWeight.w300, fontSize: 16,color: Color(0xFF848282)),),

              ],
            ),
            const SizedBox(height: 12,),
            SizedBox(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CustomIconText(
                        boxWidth: 35,
                        boxHeight: 35,
                        boxColor: const Color(0xFFEDEDED),
                        customText: time.toString().split('T')[1],
                        customIcon:const Icon(Icons.watch_later),
                      ),
                      const SizedBox(width: 20,),
                      CustomIconText(
                          boxWidth: 35,
                          boxHeight: 35,
                          boxColor: const Color(0xFFEDEDED),
                          customText: car_num,
                          customIcon:const Icon(Icons.car_crash)
                      ),
                    ],
                  ),
                  const SizedBox(height: 10,),
                  CustomIconText(
                      boxWidth: 35,
                      boxHeight: 35,
                      boxColor: const Color(0xFFEDEDED),
                      customText: violation,
                      customIcon:const Icon(Icons.star)
                  ),
                  const SizedBox(height: 10,),
                  Text('$location $violation 차량', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),),
                  const SizedBox(height: 5,),
                  SizedBox(
                    height: 100,
                    width: 315,
                    child: SingleChildScrollView( // 🔹 스크롤 가능하게 설정
                      child: Text(
                        '영상에서는 $car_num 차량이 신호를 무시하고 적색 신호에 교차로를 통과하는 장면이 기록되어 있습니다. 이는 교차로 내 사고 위험을 초래한 명백한 신호 위반 사례입니다.',
                        style: const TextStyle(color: Color(0xFF848282)),
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

