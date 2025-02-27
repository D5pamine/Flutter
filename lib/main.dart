import 'package:flutter/material.dart';
import 'package:flyaid5pamine/detail02.dart';
import 'package:flyaid5pamine/report02.dart';
import 'package:flyaid5pamine/result01.dart';
import 'package:flyaid5pamine/service/userservice.dart';
import 'package:flyaid5pamine/test01.dart';
import 'package:flyaid5pamine/widgets/CustomButton.dart';
import 'package:flyaid5pamine/widgets/CustomAppBar.dart';
import 'package:flyaid5pamine/widgets/InputCustomTextField.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flyaid5pamine/write02.dart';

import 'home01.dart';
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

class Login01 extends StatefulWidget {
  @override
  _Login01State createState() => _Login01State();
}

class _Login01State extends State<Login01> {
  final userIdController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    userIdController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true, // ✅ 키보드가 올라오면 화면 조정 가능
      appBar: const CustomAppBar(),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(), // ✅ 빈 화면 터치 시 키보드 숨김
        child: Center(
          child: SingleChildScrollView(
            // keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag, // ✅ 스크롤 시 키보드 자동 숨김
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center, // ✅ 세로 중앙 정렬
                crossAxisAlignment: CrossAxisAlignment.center, // ✅ 가로 중앙 정렬
                children: [
                  const SizedBox(height: 20),
                  const Text(
                    "Hi, there👋",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF2F2F2F),
                    ),
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    "로그인을 해주세요",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF888888),
                    ),
                  ),
                  const SizedBox(height: 40),
                  InputCustomTextField(
                    hintText: '아이디',
                    controller: userIdController,
                  ),
                  const SizedBox(height: 8),
                  InputCustomTextField(
                    hintText: '비밀번호',
                    controller: passwordController,
                  ),
                  const SizedBox(height: 20),
                  CustomButton(
                    buttonText: '로그인하기',
                    onPressed: () async {
                      try {
                        var userId = userIdController.text.trim();
                        var password = passwordController.text.trim();
                        var res = await UserLoginService()
                            .loginUser(user_id: userId, user_pw: password);

                        if (res['statusCode'] == 200) { // 로그인 성공
                          print("로그인 성공: $res");
                          showDialog(
                            context: context,
                            builder: (_) => AlertDialog(
                              title: const Text("로그인이 완료되었습니다", style: TextStyle(fontSize: 12)),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Home01()),
                                    );
                                  },
                                  child: const Text("확인"),
                                ),
                              ],
                            ),
                          );
                        } else { // 로그인 실패 처리
                          String errorMessage;
                          if (res['detail'] is List) {
                            errorMessage = (res['detail'] as List)
                                .map((e) => e['msg'])
                                .join('\n');
                          } else {
                            errorMessage =
                                res['detail']?.toString() ?? '알 수 없는 오류';
                          }
                          print("로그인 실패: $errorMessage");
                          showDialog(
                            context: context,
                            builder: (_) => AlertDialog(
                              title: const Text("로그인 실패"),
                              content: Text(errorMessage),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text("확인"),
                                ),
                              ],
                            ),
                          );
                        }
                      } catch (e) {
                        print("로그인 예외: ${e.toString()}");
                      }
                    },
                  ),
                  const SizedBox(height: 25),
                  Container(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Login02()),
                        );
                      },
                      child: const Text(
                        '회원가입 > ',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF2F2F2F),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextButton(
                    onPressed: () {},
                    child: const Text(
                      '아이디 / 비밀번호 찾기',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF2F2F2F),
                      ),
                    ),
                  ),
                  const SizedBox(height: 50),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}