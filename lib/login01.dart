import 'package:flutter/material.dart';
import 'package:flyaid5pamine/widgets/CustomButton.dart';
import 'package:flyaid5pamine/widgets/CustomAppBar.dart';
import 'package:flyaid5pamine/widgets/InputCustomTextField.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'login02.dart';
import 'login03.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('ko', 'KR'),
      ],
      locale: const Locale('ko'),
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
        useMaterial3: true,
      ),
      home: Login01(),
    );
  }
}

class Login01 extends StatelessWidget {
  final now = DateTime.now();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const CustomAppBar(),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.only(left: 20.0, top: 40.0, right: 20.0, bottom: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Hi, there👋", style: TextStyle(fontSize: 28, fontWeight: FontWeight.w600, color: Color(0xFF2F2F2F),),),
                const Text("로그인을 해주세요", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400, color: Color(0xFF888888),),),
                const SizedBox(height: 40),
                InputCustomTextField(hintText: '아이디'),
                const SizedBox(height: 8),
                InputCustomTextField(hintText: '비밀번호'),
                const SizedBox(height: 20),
                CustomButton(buttonText: '로그인하기',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Login03()),
                    );
                  },),
                const SizedBox(height: 25),
                Container(
                  alignment: Alignment.centerRight,  // ✅ 오른쪽 정렬
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Login02()),
                      );
                    },
                    child: const Text('회원가입 > ', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600, color: Color(0xFF2F2F2F),),),
                  ),
                ),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: () {},
                  child: const Text('아이디 / 비밀번호 찾기', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400, color: Color(0xFF2F2F2F),),),
                ),
                const SizedBox(height: 50),
              ],
            ),
          ),
        )
    );
  }
}