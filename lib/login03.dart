import 'package:flutter/material.dart';
import 'package:flyaid5pamine/main.dart';
import 'package:flyaid5pamine/widgets/CustomButton.dart';
import 'package:flyaid5pamine/widgets/CustomAppBar.dart';
import 'package:flyaid5pamine/widgets/InputCustomTextField.dart';
import 'package:flyaid5pamine/widgets/CustomCheckBox.dart';

import 'home01.dart';

void main() {
  runApp(MyApp());
}

class Login03 extends StatefulWidget {
  @override
  _Login03State createState() => _Login03State();
}

class _Login03State extends State<Login03> {
  var siteIdController = TextEditingController();
  var sitePwController = TextEditingController();

  @override
  void dispose() {
    siteIdController.dispose();
    sitePwController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();

    return Scaffold(
        appBar: const CustomAppBar(),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.only(left: 20.0, top: 40.0, right: 20.0, bottom: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("국민안전신문고 연동", style: TextStyle(fontSize: 28, fontWeight: FontWeight.w700, color: Color(0xFF2F2F2F),),),
                const SizedBox(height: 8),
                const Text("국민안전신문고로 로그인하기\n최초 로그인 시 1회만 수행해요", textAlign: TextAlign.center, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: Color(0xFF888888),),),
                const SizedBox(height: 20),
                InputCustomTextField(hintText: '아이디',
                  controller: siteIdController,),
                const SizedBox(height: 8),
                InputCustomTextField(hintText: '비밀번호',
                  controller: sitePwController,),
                const SizedBox(height: 20),
                const Row(
                  children: [
                    CustomCheckBox(),  // ✅ 체크박스
                    Text(
                      '계정 연동을 위해 본인의 계정 정보를 제공 및 사용에 동의합니다',
                      style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
                const Text('해당 목적 이외의 용도로는 사용하지 않습니다\n국민안전신문고 회원가입 후 이용해주세요',textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 10, color: Color(0xFF888888)),),
                const SizedBox(height: 20),
                CustomButton(buttonText: '로그인하기', onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Home01()),
                  );
                },),
                const SizedBox(height: 25),
                const SizedBox(height: 20),
                const SizedBox(height: 50),
              ],
            ),
          ),
        )
    );
  }
}