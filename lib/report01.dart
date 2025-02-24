import 'package:flutter/material.dart';
import 'package:flyaid5pamine/login01.dart';
import 'package:flyaid5pamine/report02.dart';
import 'package:flyaid5pamine/widgets/BottomNavi.dart';
import 'package:flyaid5pamine/widgets/CustomAppBar.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

void main() {
  runApp(MyApp());
}

class Report01 extends StatefulWidget {
  const Report01({Key? key}) : super(key: key);
  @override
  _Report01State createState() => _Report01State();
}

class _Report01State extends State<Report01> {
  final now = DateTime.now();

  @override
  void initState() {
    super.initState();
    // 5초 후 Login01 화면으로 전환
    Future.delayed(const Duration(seconds: 5), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Report02()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body: Padding(
        padding: const EdgeInsets.only(left: 20.0, top: 10.0, right: 20.0, bottom: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 0.0),
                child: IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.arrow_back, color: Color(0xFFFFB267)),
                ),
              ),
            ),
            const SizedBox(height: 130),
            LoadingAnimationWidget.newtonCradle(
              color: const Color(0xFFFFB267),
              size: 150,
            ),
            const Text(
              "잠시만 기다려주세요",
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20, color: Color(0xFF888888)),
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
