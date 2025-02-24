import 'package:flutter/material.dart';
import 'package:flyaid5pamine/widgets/CustomButton.dart';
import 'package:flyaid5pamine/widgets/CustomAppBar.dart';
import 'package:flyaid5pamine/widgets/InputCustomTextField.dart';
import 'package:intl/intl.dart';

import 'login01.dart';

void main() {
  runApp(MyApp());
}

class Login02 extends StatelessWidget {
  final now = DateTime.now();
  @override
  Widget build(BuildContext context) {
    var date = DateFormat('yyyy-MM-dd (E)', 'ko').format(now);
    return Scaffold(
        appBar: CustomAppBar(),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.only(left: 20.0, top: 40.0, right: 20.0, bottom: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                  Container(
                  alignment: Alignment.centerLeft,  // ✅ 오른쪽 정렬
                    padding: const EdgeInsets.only(left: 20.0),
                    child: const Text('Nice to meet you👋', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w600, color: Color(0xFF2F2F2F),),
                  ),
                ),
                const SizedBox(height: 5),
                Container(
                  alignment: Alignment.centerLeft,  // ✅ 오른쪽 정렬
                  padding: const EdgeInsets.only(left: 20.0),
                  child: const Text('정보를 입력해주세요', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400, color: Color(0xFF888888),),
                  ),
                ),
                const SizedBox(height: 30),
                InputCustomTextField(hintText: '아이디', needCheckBox:true),
                const SizedBox(height: 8),
                InputCustomTextField(hintText: '비밀번호'),
                const SizedBox(height: 8),
                InputCustomTextField(hintText: '핸드폰', onlyNum:true, needCheckBox:true),
                const SizedBox(height: 8),
                InputCustomTextField(hintText: '이메일'),
                const SizedBox(height: 8),
                InputCustomTextField(hintText: '닉네임'),
                const SizedBox(height: 40),
                CustomButton(buttonText: '회원가입', onPressed: () {  },),
                const SizedBox(height: 50),
              ],
            ),
          ),
        )
    );
  }
}