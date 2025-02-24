import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flyaid5pamine/login01.dart';
import 'package:flyaid5pamine/widgets/BottomNavi.dart';
import 'package:flyaid5pamine/widgets/CustomButton.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:video_player/video_player.dart';

void main() {
  runApp(MyApp());
}

class Write02 extends StatefulWidget {
  @override
  _Write02State createState() => _Write02State();
}

class _Write02State extends State<Write02> {
  List<VideoPlayerController> controllers = []; // 영상 컨트롤러
  late TextEditingController _timecontroller; // time 컨트롤러
  late TextEditingController _carnumbercontroller; // carnumber 컨트롤러
  late TextEditingController _reasoncontroller; // reason 컨트롤러
  late TextEditingController _detailcontroller; // detailtext 컨트롤러
  late TextEditingController _titlecontroller; // title 컨트롤러
  final Completer<GoogleMapController> _controller = Completer();
  LatLng _selectedLocation = LatLng(37.565943, 126.899274);

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.565943, 126.899274),
    zoom: 14.4746,
  );

  static const CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799, // 기존 값 유지 (방향)
      target: LatLng(37.565943, 126.899274),  // 새 위치 적용
      tilt: 59.440717697143555,  // 기존 값 유지 (기울기)
      zoom: 19.151926040649414  // 기존 값 유지 (확대 레벨)
  );

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
                  Icon(Icons.location_on, color: Color(0xFFFFB267),),
                  SizedBox(width: 3,),
                  Text('마포대교', style: TextStyle(fontWeight: FontWeight.w300, fontSize: 16,color: Color(0xFF848282)),),
                ],
              ),
              const SizedBox(height: 3,),
              SizedBox(
                width: 315, // 가로 크기
                height: 215, // 세로 크기
                child: Stack(
                  children: [
                    GoogleMap(
                      mapType: MapType.terrain,
                      initialCameraPosition: CameraPosition(
                        target: _selectedLocation,  // 변수명 수정
                        zoom: 18.4746,
                      ),
                      onMapCreated: (GoogleMapController controller) {
                        _controller.complete(controller);
                      },
                      onCameraMove: (CameraPosition position) {
                        setState(() {
                          _selectedLocation = position.target;  // 변수명 수정
                        });
                      },
                      onCameraIdle: () {
                        print("선택된 위치: $_selectedLocation");
                      },
                    ),
                    const Positioned(
                      top: 250 / 2 - 24, // SizedBox 높이의 절반에서 24px 빼서 중앙 배치
                      left: 315 / 2 - 24, // SizedBox 너비의 절반에서 24px 빼서 중앙 배치
                      child: Icon(Icons.location_pin, size: 48, color: Color(0xFFFFB267)),
                    ),
                    Positioned(
                      bottom: 10,
                      left: 90,
                      right: 90,
                      child: ElevatedButton(
                          onPressed: () {
                            print("사용자가 선택한 위치: $_selectedLocation");
                          },
                          child: const Text("이 위치 선택"),
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
                  backColor: const Color(0xffF0F3FA), onPressed: () {  },
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

