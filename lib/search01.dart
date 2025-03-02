import 'package:flutter/material.dart';
import 'package:flyaid5pamine/service/videoget.dart';
import 'package:flyaid5pamine/widgets/BottomNavi.dart';
import 'package:flyaid5pamine/widgets/CustomButton.dart';
import 'package:flyaid5pamine/widgets/CustomAppBar.dart';
import 'package:flyaid5pamine/widgets/MovieCard.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:video_player/video_player.dart';

import 'main.dart';

void main() {
  runApp(MyApp());
}

class Search01 extends StatefulWidget {
  @override
  _Search01State createState() => _Search01State();

}


void fetchStealthVideos() async {
  var videoService = VideoGetByViolation();
  var response = await videoService.getVideosByViolation("stealth");

  if (response["statusCode"] == 200) {
    print("📹 Stealth violation videos: ${response["data"]}");
  } else {
    print("🚨 오류 발생: ${response["error"]}");
  }
}


class _Search01State extends State<Search01> {
  final now = DateTime.now();
  DateTime _selectedDay = DateTime.now();
  String selectedButton = "";
  List<dynamic> videos = [];
  List<int> detectedIdList = [];
  List<VideoPlayerController> _controllers = [];

  @override
  void initState() {
    super.initState();
    fetchStealthVideos();
  }

  void toggleButton(String buttonText) {
    setState(() {
      selectedButton = buttonText; // 선택한 버튼 업데이트
    });
    VideoGetByViolation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false, // ✅ 기본 설정 유지
      appBar: const CustomAppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag, // ✅ 스크롤 시 키보드 닫힘
          child: Padding(
            padding: const EdgeInsets.only(left: 20.0, top: 10.0, right: 20.0, bottom: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    // ✅ 검색 바
                    const Expanded(
                      child: SearchBar(
                        trailing: [
                          Padding(
                            padding: EdgeInsets.all(12.0),
                            child: Icon(Icons.search),
                          ),
                        ],
                        constraints: BoxConstraints(maxHeight: 50), // 검색 바 크기 조정
                      ),
                    ),

                    const SizedBox(width: 10), // 검색 바와 캘린더 버튼 간격

                    // ✅ 캘린더 버튼 (네모 박스 안에 넣기)
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: const Color(0xffF0F3FA),
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
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
                              content: SizedBox(
                                height: 400,
                                child: TableCalendar(
                                  locale: 'ko_KR',
                                  firstDay: DateTime.utc(2010, 10, 16),
                                  lastDay: DateTime.utc(2030, 3, 14),
                                  focusedDay: DateTime.now(),
                                  calendarFormat: CalendarFormat.month,
                                  headerStyle: const HeaderStyle(
                                    formatButtonVisible: false,
                                    titleCentered: true,
                                    titleTextStyle: TextStyle(fontSize: 14),
                                  ),
                                  calendarStyle: const CalendarStyle(
                                    defaultTextStyle: TextStyle(fontSize: 12),
                                    weekendTextStyle: TextStyle(fontSize: 12, color: Colors.red),
                                    selectedTextStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                                  ),
                                  daysOfWeekStyle: const DaysOfWeekStyle(
                                    weekdayStyle: TextStyle(fontSize: 12),
                                    weekendStyle: TextStyle(fontSize: 12, color: Colors.red),
                                  ),
                                  onDaySelected: (selectedDay, focusedDay) {
                                    setState(() {
                                      _selectedDay = selectedDay;
                                    });
                                    Navigator.pop(context);
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
                const SizedBox(height: 15),
                SizedBox(
                  height: 460,
                  width: 315,
                  child: Center(
                    child:
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,  // ✅ 세로 방향 (Column) 중앙 정렬
                      crossAxisAlignment: CrossAxisAlignment.start,  // ✅ 가로 방향 (Row) 중앙 정렬
                      children: [
                        const SizedBox(height: 10,),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              CustomButton(
                                buttonText: '칼치기',
                                textWidth: 95.0,
                                textHeight: 40.0,
                                textSize: 11.0,
                                fontWeight: FontWeight.w600,
                                backColor: selectedButton == '칼치기' ? Colors.orange : const Color(0xffF0F3FA), // 색상 변경
                                onPressed: () async {
                                  toggleButton('칼치기');
                                  final result = await VideoGetByViolation().getVideosByViolation('weaving');
                                  print(result);
                                },
                              ),
                              const SizedBox(width: 10,),
                              CustomButton(
                                buttonText: '헬멧 미착용',
                                textWidth: 95.0,
                                textHeight: 40.0,
                                textSize: 11.0,
                                fontWeight: FontWeight.w600,
                                backColor: selectedButton == '헬멧 미착용' ? Colors.orange : const Color(0xffF0F3FA), // 색상 변경
                                onPressed: () async {
                                  toggleButton('헬멧 미착용');
                                  final result = await VideoGetByViolation().getVideosByViolation('no helmet');
                                  print(result);
                                  detectedIdList = result['detected_id'];
                                  print(detectedIdList);
                                },
                              ),
                              const SizedBox(width: 10,),
                              CustomButton(
                                buttonText: '스텔스',
                                textWidth: 95.0,
                                textHeight: 40.0,
                                textSize: 11.0,
                                fontWeight: FontWeight.w600,
                                backColor: selectedButton == '스텔스' ? Colors.orange : const Color(0xffF0F3FA), // 색상 변경
                                onPressed: () async {
                                  toggleButton('스텔스');
                                  final result = await VideoGetByViolation().getVideosByViolation('stealth');
                                  print(result[0]['detected_id']);
                                },
                              ),
                              const SizedBox(width: 10,),
                              CustomButton(
                                buttonText: '과적',
                                textWidth: 95.0,
                                textHeight: 40.0,
                                textSize: 11.0,
                                fontWeight: FontWeight.w600,
                                backColor: selectedButton == '과적' ? Colors.orange : const Color(0xffF0F3FA), // 색상 변경
                                onPressed: () async {
                                  toggleButton('과적');
                                  final result = await VideoGetByViolation().getVideosByViolation('overloading');
                                  print(result);
                                },
                              ),
                            ],
                          ),
                        ),
                        // Moviecard(
                        //   controllers: _controllers[0],
                        //   reportcontent: '신호 위반 (적색 신호에 교차로 통과)',
                        //   reportlocation: '서울특별시 강남구 도산대로 123',
                        //   reportreason: '도로교통법 제 5조 (신호준수 의무위반)',
                        //   reporttime: '2025년 2월 6일 오후 3시 45분',
                        //   reportdate: '2025.02.13',
                        //   cardLineColor: const Color(0xffFFB267),
                        // ),
                        const SizedBox(height: 10,),
                      ],
                    ),
                  ),
                ),
                CustomButton(buttonText: '검색하기',
                  fontWeight: FontWeight.w600, onPressed: () {  },),
              ],

            ),
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
