import 'package:flutter/material.dart';
import 'package:flyaid5pamine/widgets/BottomNavi.dart';
import 'package:flyaid5pamine/widgets/CustomButton.dart';
import 'package:flyaid5pamine/widgets/CustomIconText.dart';
import 'package:video_player/video_player.dart';

import 'main.dart';

void main() {
  runApp(MyApp());
}

class Detail02 extends StatefulWidget {
  @override
  _Detail02 createState() => _Detail02();
}

class _Detail02 extends State<Detail02> {
  List<VideoPlayerController> controllers = [];
  bool _showOverlay = true;
  bool _showControls = true;

  @override
  void initState() {
    super.initState();
    List<String> videoPaths = [
      "assets/videos/test1.mp4",
      "assets/videos/test2.mp4",
      "assets/videos/test3.mp4"
    ];
    loadVideos(videoPaths);
  }

  void _toggleControls() {
    setState(() {
      _showControls = !_showControls;
      if (_showControls) {
        _showOverlay = true;
        Future.delayed(const Duration(seconds: 3), () {
          setState(() {
            _showControls = true;
            _showOverlay = true;
          });
        });
      }
    });
  }

  Future<void> loadVideos(List<String> paths) async {
    for (var path in paths) {
      try {
        var controller = VideoPlayerController.asset(path);
        await controller.initialize();
        controllers.add(controller);
        setState(() {});
      } catch (error) {
        print("❌ Error loading video $path: $error");
      }
    }
  }

  @override
  void dispose() {
    for (var controller in controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(left: 20.0, top: 40.0, right: 20.0, bottom: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Stack(
                children: [
                  SizedBox(
                    height: 300,
                    child: AspectRatio(
                      aspectRatio: 18 / 12,
                      child: GestureDetector(
                        onTap: _toggleControls,
                        child: VideoPlayer(controllers[0]),
                      ),
                    ),
                  ),
                  if (_showOverlay)
                    Positioned.fill(
                      child: Container(
                        color: Colors.black.withOpacity(0.5),
                        child: const Center(
                          child: Text(
                            "신고 완료",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
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
                        onPressed: () {},
                      ),
                    ),
                  ),
                  Positioned(
                    top: 10,
                    right: 10,
                    child: CircleAvatar(
                      backgroundColor: Colors.black54,
                      radius: 20,
                      child: IconButton(
                        icon: const Icon(Icons.bookmark),
                        color: Colors.white,
                        onPressed: () {},
                      ),
                    ),
                  ),
                  if (_showControls)
                    Positioned(
                      bottom: 10,
                      left: 0,
                      right: 0,
                      child: Align(
                        alignment: Alignment.center,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 5),
                          decoration: BoxDecoration(
                            color: Colors.black54,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.fast_rewind, color: Colors.white),
                                onPressed: () {},
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
                                    _showOverlay = false;
                                    // _showControls = false;
                                    // _toggleControls();
                                  });
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.fast_forward, color: Colors.white),
                                onPressed: () {},
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 15),
            const Row(
              children: [
                Text('2025.02.13', style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600)),
                Spacer(),
                Icon(Icons.location_on, color: Color(0xFF848282)),
                SizedBox(width: 3),
                Text('마포대교', style: TextStyle(fontWeight: FontWeight.w300, fontSize: 16, color: Color(0xFF848282))),
              ],
            ),
            const SizedBox(height: 12),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CustomIconText(
                      boxWidth: 35,
                      boxHeight: 35,
                      boxColor: Color(0xFFEDEDED),
                      customText: '15:26',
                      customIcon: Icon(Icons.watch_later),
                    ),
                    SizedBox(width: 20),
                    CustomIconText(
                      boxWidth: 35,
                      boxHeight: 35,
                      boxColor: Color(0xFFEDEDED),
                      customText: '서울 12가 3456',
                      customIcon: Icon(Icons.car_crash),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                CustomIconText(
                  boxWidth: 35,
                  boxHeight: 35,
                  boxColor: Color(0xFFEDEDED),
                  customText: '칼치기, 신호 위반, 과속',
                  customIcon: Icon(Icons.star),
                ),
                SizedBox(height: 10),
                Text('2월 13일 마포대교 칼치기', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                SizedBox(height: 5),
                SizedBox(
                  height: 100,
                  width: 315,
                  child: SingleChildScrollView(
                    child: Text(
                      '영상에서는 [서울 12가 3456] 차량이 신호를 무시하고 적색 신호에 교차로를 통과하는 장면이 기록되어 있습니다. 이는 교차로 내 사고 위험을 초래한 명백한 신호 위반 사례입니다.',
                      style: TextStyle(color: Color(0xFF848282)),
                    ),
                  ),
                ),
              ],
            ),
            CustomButton(
              buttonText: '결과보기',
              textWidth: 315,
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
