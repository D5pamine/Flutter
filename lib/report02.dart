import 'package:flutter/material.dart';
import 'package:flyaid5pamine/home01.dart';
import 'package:flyaid5pamine/login01.dart';
import 'package:flyaid5pamine/widgets/BottomNavi.dart';
import 'package:flyaid5pamine/widgets/CustomButton.dart';
import 'package:flyaid5pamine/widgets/CustomAppBar.dart';

void main() {
  runApp(MyApp());
}

class Report02 extends StatelessWidget {
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
            const SizedBox(
              height: 530,
              width: 315,
              child: Center(
                child:
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,  // ✅ 세로 방향 (Column) 중앙 정렬
                  crossAxisAlignment: CrossAxisAlignment.center,  // ✅ 가로 방향 (Row) 중앙 정렬
                  children: [
                    Icon(Icons.check_circle_outline, size: 150, color: Color(0xFFFFB267),),
                    SizedBox(height: 15,),
                    Text('신고완료!', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 23, color: Color(0xFF888888)),),
                  ],
                ),
              ),
            ),
            CustomButton(buttonText: '메인으로',
              fontWeight: FontWeight.w600, onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Home01()),
                );
              },),
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