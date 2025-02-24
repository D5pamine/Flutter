import 'package:flutter/material.dart';
import 'package:flyaid5pamine/widgets/BottomNavi.dart';
import 'package:flyaid5pamine/widgets/CustomAppBar.dart';
import 'package:flyaid5pamine/widgets/CustomButton.dart';

import 'login01.dart';

void main() {
  runApp(MyApp());
}

class Log01 extends StatelessWidget {
  final now = DateTime.now();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body: Padding(
          padding: const EdgeInsets.only(left: 20.0, top: 10.0, right: 20.0, bottom: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // const Text('3개의 새로운 이벤트', style: TextStyle(fontWeight: FontWeight.w300, color: Color(0xFF000000)),),
              const SizedBox(height: 10,),
              Row(
                children: [
                  CustomButton(
                    buttonText: '최근 검출 영상',
                    textWidth: 95.0,
                    textHeight: 40.0,
                    textSize: 11.0,
                    fontWeight: FontWeight.w600, onPressed: () {  },
                  ),
                  const SizedBox(width: 10),
                  CustomButton(
                    buttonText: '최근 신고 영상',
                    textWidth: 95.0,
                    textHeight: 40.0,
                    textSize: 11.0,
                    fontWeight: FontWeight.w600,
                    backColor: const Color(0xffF0F3FA), onPressed: () {  },
                  ),
                ],
              ),
              SizedBox(
                height: 450,
                width: 315,
                child: Center(
                    child:
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,  // ✅ 세로 방향 (Column) 중앙 정렬
                      crossAxisAlignment: CrossAxisAlignment.center,  // ✅ 가로 방향 (Row) 중앙 정렬
                      children: [
                        Image.asset('assets/images/free-icon-tree.png', height: 180),
                        const SizedBox(height: 15,),
                        const Text('오늘은 영상이 없어요', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 23, color: Color(0xFFFFB267)),),
                      ],
                    ),
                ),
              ),
              CustomButton(buttonText: '상세보기',
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