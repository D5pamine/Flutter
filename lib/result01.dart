import 'package:flutter/material.dart';
import 'package:flyaid5pamine/main.dart';
import 'package:flyaid5pamine/widgets/BottomNavi.dart';
import 'package:flyaid5pamine/widgets/CustomButton.dart';
import 'package:flyaid5pamine/widgets/CustomAppBar.dart';
import 'package:flyaid5pamine/widgets/CustomCard.dart';

void main() {
  runApp(MyApp());
}

class Result01 extends StatelessWidget {
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
            SizedBox(
              height: 530,
              width: 315,
              child: Center(
                child:
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,  // ✅ 세로 방향 (Column) 중앙 정렬
                  crossAxisAlignment: CrossAxisAlignment.center,  // ✅ 가로 방향 (Row) 중앙 정렬
                  children: [
                    CustomCard(
                      cardLineColor: const Color(0xFFFFB267),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text("접수", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 30, color: Color(0xFFFFB267))),
                          const SizedBox(height: 20,),
                          Container(width: 500, height: 1, color: const Color(0xFFE9EEF8)),
                          const SizedBox(height: 20,),
                          const Center(
                              child: Text('제보가 접수되었습니다', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Color(0xFF888888)),),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            CustomButton(buttonText: '돌아가기',
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