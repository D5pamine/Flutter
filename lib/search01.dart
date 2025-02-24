import 'package:flutter/material.dart';
import 'package:flyaid5pamine/widgets/BottomNavi.dart';
import 'package:flyaid5pamine/widgets/CustomButton.dart';
import 'package:flyaid5pamine/widgets/CustomAppBar.dart';
import 'package:flyaid5pamine/widgets/MovieCard.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:video_player/video_player.dart';

import 'login01.dart';

void main() {
  runApp(MyApp());
}

class Search01 extends StatefulWidget {
  @override
  _Search01State createState() => _Search01State();
}

class _Search01State extends State<Search01> {
  final now = DateTime.now();
  DateTime _selectedDay = DateTime.now();
  List<VideoPlayerController> controllers = [];

  @override
  void initState() {
    super.initState();
    List<String> videoPaths = [
      "assets/videos/test1.mp4",
      "assets/videos/test2.mp4",
      "assets/videos/test3.mp4",
    ];
    print("Loading video paths: $videoPaths");
    loadVideos(videoPaths);
  }

  Future<void> loadVideos(List<String>paths) async {
    for (var path in paths) {
      try {
        var controller = VideoPlayerController.asset(path);
        await controller.initialize();
        controllers.add(controller);
        setState(() {});
        print("Loading video: $path");
      } catch (error) {
        print("Error loading video $path: $error");
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

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body: Padding(
        padding: const EdgeInsets.only(left: 20.0, top: 10.0, right: 20.0, bottom: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // 검색 바
                const SearchBar(
                  trailing: [
                    Padding(
                      padding: EdgeInsets.all(12.0),
                      child: Icon(Icons.search),
                    ), // 오른쪽(뒤쪽)에 배치
                  ],
                  constraints: BoxConstraints(maxWidth: 260, maxHeight: 50), // 높이 조정
                ),

                const SizedBox(width: 10), // 검색 바와 버튼 사이 간격

                // 캘린더 버튼 (네모 박스 안에 넣기)
                Container(
                  width: 50,  // 네모 크기
                  height: 50, // 네모 크기
                  decoration: BoxDecoration(
                    color: const Color(0xffF0F3FA), // 배경색 (필요에 따라 변경)
                    borderRadius: BorderRadius.circular(30), // 둥근 테두리
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1), // 그림자 효과
                        blurRadius: 4,
                        offset: const Offset(2, 2),
                      ),
                    ],
                  ),
                  child: IconButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          // title: const Text("날짜 선택"),
                          content: SizedBox(
                            height: 400,  // 캘린더 크기 조절 (최소한의 공간 유지)
                            // width: 250,
                            child: TableCalendar(
                              locale: 'ko_KR', // 한국어 설정
                              firstDay: DateTime.utc(2010, 10, 16),
                              lastDay: DateTime.utc(2030, 3, 14),
                              focusedDay: DateTime.now(),
                              calendarFormat: CalendarFormat.month,

                              // ✅ 캘린더 크기 조정
                              headerStyle: const HeaderStyle(
                                formatButtonVisible: false, // "2 weeks" 버튼 숨김
                                titleCentered: true, // 제목 가운데 정렬
                                titleTextStyle: TextStyle(fontSize: 14), // 월/연도 폰트 크기 줄이기
                              ),

                              calendarStyle: const CalendarStyle(
                                defaultTextStyle: TextStyle(fontSize: 12), // 기본 날짜 폰트 크기 줄이기
                                weekendTextStyle: TextStyle(fontSize: 12, color: Colors.red), // 주말 폰트 크기 조정
                                selectedTextStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.bold), // 선택된 날짜 크기 조정
                              ),

                              daysOfWeekStyle: const DaysOfWeekStyle(
                                weekdayStyle: TextStyle(fontSize: 12), // 요일 폰트 크기 조정
                                weekendStyle: TextStyle(fontSize: 12, color: Colors.red),
                              ),

                              onDaySelected: (selectedDay, focusedDay) {
                                _selectedDay = selectedDay;
                                print(_selectedDay);
                                Navigator.pop(context); // 날짜 선택 후 닫기
                              },
                            ),
                          ),

                        ),
                      );
                    },
                    icon: const Icon(Icons.calendar_month),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 480,
              width: 315,
              child: Center(
                child:
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,  // ✅ 세로 방향 (Column) 중앙 정렬
                  crossAxisAlignment: CrossAxisAlignment.start,  // ✅ 가로 방향 (Row) 중앙 정렬
                  children: [
                    const SizedBox(height: 15,),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          CustomButton(
                            buttonText: '칼치기',
                            textWidth: 95.0,
                            textHeight: 40.0,
                            textSize: 11.0,
                            fontWeight: FontWeight.w600, onPressed: () {  },
                            // backColor: const Color(0xffF0F3FA),
                          ),
                          const SizedBox(width: 10,),
                          CustomButton(
                            buttonText: '헬멧 미착용',
                            textWidth: 95.0,
                            textHeight: 40.0,
                            textSize: 11.0,
                            fontWeight: FontWeight.w600,
                            backColor: const Color(0xffF0F3FA), onPressed: () {  },
                          ),
                          const SizedBox(width: 10,),
                          CustomButton(
                            buttonText: '스텔스',
                            textWidth: 95.0,
                            textHeight: 40.0,
                            textSize: 11.0,
                            fontWeight: FontWeight.w600,
                            backColor: const Color(0xffF0F3FA), onPressed: () {  },
                          ),
                          const SizedBox(width: 10,),
                          CustomButton(
                            buttonText: '과적',
                            textWidth: 95.0,
                            textHeight: 40.0,
                            textSize: 11.0,
                            fontWeight: FontWeight.w600,
                            backColor: const Color(0xffF0F3FA), onPressed: () {  },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10,),
                    Moviecard(
                      controllers: controllers[0],
                      reportcontent: '신호 위반 (적색 신호에 교차로 통과)',
                      reportlocation: '서울특별시 강남구 도산대로 123',
                      reportreason: '도로교통법 제 5조 (신호준수 의무위반)',
                      reporttime: '2025년 2월 6일 오후 3시 45분',
                      reportdate: '2025.02.13',
                      cardLineColor: const Color(0xffFFB267),
                    ),
                  ],
                ),
              ),
            ),
            CustomButton(buttonText: '검색하기',
              fontWeight: FontWeight.w600, onPressed: () {  },),
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