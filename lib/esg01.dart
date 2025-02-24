import 'package:flutter/material.dart';
import 'package:flyaid5pamine/login01.dart';
import 'package:flyaid5pamine/widgets/CustomButton.dart';
import 'package:flyaid5pamine/widgets/CustomAppBar.dart';
import 'package:flyaid5pamine/widgets/CustomCard.dart';
import 'package:flyaid5pamine/widgets/CustomColorBox.dart';
import 'package:flyaid5pamine/widgets/WeeklyBarchart.dart';

void main() {
  runApp(MyApp());
}

class Esg01 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(left: 20.0, top: 00.0, right: 20.0, bottom: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 0.0),
                  child: IconButton(onPressed: () {}, icon: const Icon(Icons.arrow_back, color: Color(0xFFFFB267)),),
                ),
              ),
              CustomCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text("나의 ESG 점수", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18)),
                    const SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            Image.asset('assets/images/free-icon-leaf.png', height: 18,),
                            const SizedBox(width: 5),
                            const Text("1544.00", style: TextStyle(fontWeight: FontWeight.w800, fontSize: 20, color: Colors.orange)),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 10,),
                    Container(width: 500, height: 1, color: const Color(0xFFE9EEF8)),
                    const SizedBox(height: 10,),
                    Row(
                      children: [
                        Text("감소 탄소량", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.grey[800])),
                        const Spacer(),
                        Text("- 500", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.grey[800])),
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
                      // crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("나의 신고 건수", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),),
                        const Spacer(),
                        Text("누적 24 건", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 24, color: Color(0xFFFFB267)),),
                      ],
                    ),
                    const SizedBox(height: 20,),
                    WeeklyBarChart(),
                  ],
                ),
              ),
              const SizedBox(height: 12,),
              CustomCard(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        // crossAxisAlignment: CrossAxisAlignment.start, // 상단 여백 줄이기
                        children: [
                          const Text("나의 환경 기여 효과", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),),
                          const Spacer(),
                          CustomButton(buttonText: '전체보기', textWidth: 70.0, textHeight: 30.0, textSize: 10.0,
                          backColor: Color(0xffF0F3FA), textColor: Color(0xff1F87FE), onPressed: () {  },
                          ),
                        ],
                      ),
                      const SizedBox(height: 10,),
                      Center(
                          child:
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset('assets/images/free-icon-tree.png', height: 60),
                                const SizedBox(width: 8,),
                                Image.asset('assets/images/free-icon-tree.png', height: 60),
                                const SizedBox(width: 8,),
                                Image.asset('assets/images/free-icon-tree.png', height: 60),
                              ],
                            ),
                        ),
                      const SizedBox(height: 18,),
                      const Row(
                        children: [
                          CustomColorBox(boxWidth: 12, boxHeight: 12, boxColor: Color(0xffFFB267),),
                          const SizedBox(width: 8,),
                          Text('200.0 의 탄소 절감 효과', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w400),),
                          const Spacer(),
                          Text('- 100', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xffFFB267)),)
                        ],
                      ),
                      const SizedBox(height: 8,),
                      Container(width: 500, height: 1, color: const Color(0xFFE9EEF8)),
                      const SizedBox(height: 8,),
                      const Row(
                        children: [
                          CustomColorBox(boxWidth: 12, boxHeight: 12, boxColor: Color(0xff219653),),
                          const SizedBox(width: 8,),
                          Text('나무 3 그루를 살렸어요', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w400),),
                          const Spacer(),
                          Text('- 300', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xff219653)),)
                        ],
                      ),
                    ],
                  ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}