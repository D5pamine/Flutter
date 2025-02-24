import 'package:flutter/material.dart';
import 'package:flyaid5pamine/login01.dart';
import 'package:flyaid5pamine/widgets/BottomNavi.dart';
import 'package:flyaid5pamine/widgets/CustomButton.dart';
import 'package:flyaid5pamine/widgets/CustomAppBar.dart';
import 'package:flyaid5pamine/widgets/CustomCard.dart';
import 'package:video_player/video_player.dart';

void main() {
  runApp(MyApp());
}

class MyPage01 extends StatefulWidget {
  @override
  _MyPage01State createState() => _MyPage01State();
}

class _MyPage01State extends State<MyPage01> {
  List<VideoPlayerController> controllers = [];
  bool isDarkMode = false;

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
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(left: 20.0, top: 00.0, right: 20.0, bottom: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween, // 요소 간 간격 자동 조정
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.arrow_back, color: Color(0xFFFFB267)),
                  ),
                  const Expanded(
                    child: Center(
                      child: Text(
                        "Profile",
                        style: TextStyle(fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFFFB267),
                        ), // 스타일 추가
                      ),
                    ),
                  ),
                  const SizedBox(width: 48), // 뒤로가기 버튼과 균형을 맞추기 위해 추가 (아이콘 크기와 동일)
                ],
              ),
              CustomCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10.0),
                          child: const Image(
                            image: NetworkImage('https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg'),
                            width: 50,
                            height: 50,
                          ),
                        ),
                        const SizedBox(width: 10,),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('David Jang',style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),),
                            Row(
                              children: [
                                Image.asset('assets/images/free-icon-leaf.png', height: 18,),
                                const SizedBox(width: 5),
                                const Text("1544.00", style: TextStyle(fontWeight: FontWeight.w400, fontSize: 14)),
                              ],
                            ),
                          ],
                        ),
                        const Spacer(),
                        CustomButton(buttonText: '수정', textWidth: 70.0, textHeight: 30.0, textSize: 14.0,
                          backColor: const Color(0xffF0F3FA), textColor: const Color(0xFFFFB267), onPressed: () {  },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12,),
              CustomCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.call, color: Color(0xFFFFB267), size: 20,),
                        SizedBox(width: 5,),
                        Text('+82 010-3372-2611'),
                      ],
                    ),
                    const SizedBox(height: 10,),
                    Container(width: 500, height: 1, color: const Color(0xFFE9EEF8)),
                    const SizedBox(height: 10,),
                    const Row(
                      children: [
                        Icon(Icons.mail_outline, color: Color(0xFFFFB267), size: 20,),
                        SizedBox(width: 5,),
                        Text('Ccolornyong@gmail.com'),
                      ],
                    ),
                    const SizedBox(height: 10,),
                    Container(width: 500, height: 1, color: const Color(0xFFE9EEF8)),
                  ],
                ),
              ),
              const SizedBox(height: 12,),
              const Row(
                children: [
                  Text("설정", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20),),
                ],
              ),
              const SizedBox(height: 12,),
              CustomCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("다크모드 off", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),),
                            SizedBox(height: 2,),
                            Text("실시간 블랙박스 영상 확인", style: TextStyle(fontWeight: FontWeight.w300, fontSize: 14, color: Color(0xFF4C5980)),),
                          ],
                        ),
                        const Spacer(),
                        Switch(
                          value: isDarkMode,
                          onChanged: (value) {
                            setState(() {
                              isDarkMode = value;
                            });
                          },
                          activeColor: const Color(0xFFFFB267), // 활성화 색상 (오렌지색)
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10,),
              Row(
                children: [
                  const Text("저장한 영상", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20),),
                  const Spacer(),
                  TextButton(
                    onPressed: () {},
                    child: const Text('더보기 >',
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Color(0xFFFFB267))),
                  ),
                ],
              ),
              const SizedBox(height: 10,),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal, // ✅ 가로 스크롤 활성화
                child: Row(
                  children: [
                    for (var i = 0; i < controllers.length; i++) // ✅ for 문으로 리스트 생성
                      Padding(
                        padding: const EdgeInsets.only(right: 12.0),
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