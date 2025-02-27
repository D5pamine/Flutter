import 'package:flutter/material.dart';
import 'package:flyaid5pamine/detail01.dart';
import 'package:flyaid5pamine/service/userdataget.dart';
import 'package:flyaid5pamine/service/videoget.dart';
import 'package:flyaid5pamine/widgets/BottomNavi.dart';
import 'package:flyaid5pamine/widgets/CustomButton.dart';
import 'package:flyaid5pamine/widgets/CustomColorBox.dart';
import 'package:flyaid5pamine/widgets/CustomIconText.dart';
import 'package:video_player/video_player.dart';

import 'main.dart';

void main() {
  runApp(MyApp());
}

class Write01 extends StatefulWidget {
  final int detectedId;

  const Write01({Key? key, required this.detectedId}) : super(key: key);

  @override
  _Write01State createState() => _Write01State();
}

class _Write01State extends State<Write01> {
  List<VideoPlayerController> controllers = []; // 영상 컨트롤러
  late TextEditingController _timecontroller; // time 컨트롤러
  late TextEditingController _carnumbercontroller; // carnumber 컨트롤러
  late TextEditingController _reasoncontroller; // reason 컨트롤러
  late TextEditingController _detailcontroller; // detailtext 컨트롤러
  late TextEditingController _titlecontroller; // title 컨트롤러
  // 위치 수정 컨트롤러도 만들어야 함

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

  // CustomIconText 안에 기본으로 채워지는 Text
  String _timeText = "15:26";
  String _carNumber = "서울 12가 3456";
  String _reason = "칼치기, 신호 위반, 과속";
  String _detailText = "영상에서는 [서울 12가 3456] 차량이 신호를 무시하고 적색 신호에 교차로를 통과하는 장면이 기록되어 있습니다. 이는 교차로 내 사고 위험을 초래한 명백한 신호 위반 사례입니다.";
  String _title = "2월 13일 마포대교 칼치기";

  bool _isEditingTime = false;
  bool _isEditingCarNumber = false;
  bool _isEditingReason = false;
  bool _isEditingDetailText = false;
  bool _isEditingTitle = false;

  @override
  void initState() {
    super.initState();
    _timecontroller = TextEditingController(text: _timeText);
    _carnumbercontroller = TextEditingController(text: _carNumber);
    _reasoncontroller = TextEditingController(text: _reason);
    _detailcontroller = TextEditingController(text: _detailText);
    _titlecontroller = TextEditingController(text: _title);

    fetchUserInfo();
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
      _timecontroller.dispose();
      _carnumbercontroller.dispose();
      _reasoncontroller.dispose();
      _detailcontroller.dispose();
      _titlecontroller.dispose();
      _controller?.dispose();

      controller.dispose();  // ✅ 각 컨트롤러에 대해 개별적으로 dispose() 실행
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 20.0, top: 40.0, right: 20.0, bottom: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child:
                Stack(
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
              const SizedBox(height: 15,),
              Row(
                children: [
                  Text(time.split('T')[0], style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600),),
                  Spacer(),
                  Icon(Icons.location_on, color: Color(0xFF848282),),
                  SizedBox(width: 3,),
                  Text('마포대교', style: TextStyle(fontWeight: FontWeight.w300, fontSize: 16,color: Color(0xFF848282)),),
                ],
              ),
              const SizedBox(height: 3,),
              SizedBox(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const CustomColorBox(
                          boxWidth: 40,
                          boxHeight: 40,
                          boxColor: Color(0xFFEDEDED),
                          // customText: _timeText,
                          customIcon: Icon(Icons.watch_later),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _isEditingTime = true;
                              _timecontroller.text = _timeText;
                            });
                          },
                          child: _isEditingTime // _isEditing 이어야 하나
                              ? SizedBox(
                            width: 80,
                            height: 50,
                            child: TextField(
                              controller: _timecontroller,
                              autofocus: true,
                              decoration: const InputDecoration(border: OutlineInputBorder(),),
                              onSubmitted: (value) {
                                setState(() {
                                  _timeText = value;
                                  _isEditingTime = false;
                                });
                              },
                            ),
                          ):
                          CustomIconText(
                            boxWidth: 80,
                            boxHeight: 40,
                            boxColor: const Color(0xFFEDEDED),
                            customText: time.contains('T') ? time.split('T')[1] : "시간 없음",
                            customIcon: const Icon(Icons.watch_later),
                          ),
                        ),
                        const SizedBox(width: 20,),
                        const CustomColorBox(
                          boxWidth: 40,
                          boxHeight: 40,
                          boxColor: Color(0xFFEDEDED),
                          // customText: _timeText,
                          customIcon: Icon(Icons.car_crash),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _isEditingCarNumber = true;
                              _carnumbercontroller.text = _carNumber;
                            });
                          },
                          child: _isEditingCarNumber
                              ? SizedBox(
                            width: 130,
                            height: 50,
                            child: TextField(
                              controller: _carnumbercontroller,
                              autofocus: true,
                              decoration: const InputDecoration(border: OutlineInputBorder()),
                              onSubmitted: (value) {
                                setState(() {
                                  _carNumber = value;
                                  _isEditingCarNumber = false;
                                });
                              },
                            ),
                          ):
                          CustomIconText(
                            boxWidth: 80,
                            boxHeight: 40,
                            boxColor: const Color(0xFFEDEDED),
                            customText: car_num,
                            customIcon: const Icon(Icons.car_crash),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10,),
                    Row(
                      children: [
                        const CustomColorBox(
                          boxWidth: 40,
                          boxHeight: 40,
                          boxColor: Color(0xFFEDEDED),
                          // customText: _timeText,
                          customIcon: Icon(Icons.star),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _isEditingReason = true;
                              _reasoncontroller.text = _reason;
                            });
                          },
                          child: _isEditingReason
                              ? SizedBox(
                            width: 200,
                            height: 50,
                            child: TextField(
                              controller: _reasoncontroller,
                              autofocus: true,
                              decoration: const InputDecoration(border: OutlineInputBorder()),
                              onSubmitted: (value) {
                                setState(() {
                                  _reason = value;
                                  _isEditingReason = false;
                                });
                              },
                            ),
                          ):
                          CustomIconText(
                            boxWidth: 80,
                            boxHeight: 40,
                            boxColor: const Color(0xFFEDEDED),
                            customText: violation,
                            customIcon: const Icon(Icons.star),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5,),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _isEditingTitle = true;
                          _titlecontroller.text = _title;
                        });
                      },
                      child: _isEditingTitle
                          ? SizedBox(
                        width: 220,
                        height: 50,
                        child: TextField(
                          controller: _titlecontroller,
                          autofocus: true,
                          decoration: const InputDecoration(border: OutlineInputBorder()),
                          onSubmitted: (value) {
                            setState(() {
                              _title = value;
                              _isEditingTitle = false;
                            });
                          },
                        ),
                      ):
                      SizedBox(
                        child: Row(
                          children: [
                            Text(location.split(' ')[0], style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                            const SizedBox(width: 5,),
                            Text('$violation 신고', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 5,),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _isEditingDetailText = true;
                          _detailcontroller.text = _detailText;
                        });
                      },
                      child: _isEditingDetailText
                          ? ConstrainedBox(  // ✅ 높이 자동 조절 가능하도록 설정
                        constraints: const BoxConstraints(minHeight: 100, maxHeight: 100), // ✅ 최소 & 최대 높이 지정
                        child: TextField(
                          controller: _detailcontroller,
                          autofocus: true,
                          decoration: const InputDecoration(border: OutlineInputBorder()),
                          maxLines: null,  // ✅ 여러 줄 입력 가능
                          keyboardType: TextInputType.multiline, // ✅ 엔터 키 입력 시 줄바꿈 허용
                          textInputAction: TextInputAction.newline,  // ✅ 엔터 키를 줄바꿈으로 사용
                          onChanged: (value) {
                            setState(() {
                              _detailText = value;  // ✅ 입력 중에도 실시간 업데이트
                            });
                          },
                          onEditingComplete: () {  // ✅ 키보드에서 "완료" 버튼 누르면 키보드 닫기
                            setState(() {
                              _isEditingDetailText = false;
                            });
                            FocusScope.of(context).unfocus();  // ✅ 포커스 해제 (키보드 닫기)
                          },
                        ),
                      )
                          : SizedBox(
                        height: 90,
                        width: 315,
                        child: SingleChildScrollView( // 🔹 스크롤 가능하게 설정
                          child: Text(
                              '영상에서는 $car_num 차량의 $violation 장면이 기록되어 있습니다. 이는 교차로 내 사고 위험을 초래한 명백한 도로교통법 위반 사례입니다.',
                            style: const TextStyle(color: Color(0xFF848282)), ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 15,),
              Padding(
                padding: const EdgeInsets.only(bottom: 0),
                child: CustomButton(
                  buttonText: '저장하기',
                  textWidth: 315,
                  fontWeight: FontWeight.w600,
                  backColor: const Color(0xffF0F3FA), onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Detail01(detectedId: widget.detectedId,)),
                  );
                },
                ),
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