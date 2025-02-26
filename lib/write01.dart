import 'package:flutter/material.dart';
import 'package:flyaid5pamine/detail01.dart';
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

  final now = DateTime.now(); // 우상단 날짜 받아오기

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
      _timecontroller.dispose();
      _carnumbercontroller.dispose();
      _reasoncontroller.dispose();
      _detailcontroller.dispose();
      _titlecontroller.dispose();

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
                            customText: _timeText,
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
                            customText: _carNumber,
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
                            customText: _reason,
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
                        child: Text(
                          _title,
                          style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600),
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
                            _detailText,
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
                    MaterialPageRoute(builder: (context) => Detail01()),
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

