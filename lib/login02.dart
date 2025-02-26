import 'package:flutter/material.dart';
import 'package:flyaid5pamine/service/userservice.dart';
import 'package:flyaid5pamine/widgets/CustomButton.dart';
import 'package:flyaid5pamine/widgets/CustomAppBar.dart';
import 'package:flyaid5pamine/widgets/InputCustomTextField.dart';
import 'package:intl/intl.dart';

import 'main.dart';
import 'login03.dart';

void main() {
  runApp(MyApp());
}

class Login02 extends StatefulWidget {
  @override
  _Login02State createState() => _Login02State();
}

class _Login02State extends State<Login02> {
  var userIdController = TextEditingController();
  var passwordController = TextEditingController();
  var usernameController = TextEditingController();
  var emailController = TextEditingController();
  var phoneController = TextEditingController();

  // final TextEditingController userIdController = TextEditingController();
  // final TextEditingController passwordController = TextEditingController();
  // final TextEditingController usernameController = TextEditingController();
  // final TextEditingController emailController = TextEditingController();
  // final TextEditingController phoneController = TextEditingController();

  // site_id와 site_pw가 필요하다면 추가 입력 필드 혹은 고정 값을 사용
  var siteId = "testId";
  var sitePw = "testPw";

  @override
  void dispose() {
    userIdController.dispose();
    passwordController.dispose();
    usernameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    var date = DateFormat('yyyy-MM-dd (E)', 'ko').format(now);

    return Scaffold(
      appBar: const CustomAppBar(),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(
            left: 20.0,
            top: 40.0,
            right: 20.0,
            bottom: 20.0,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.only(left: 20.0),
                child: const Text(
                  'Nice to meet you👋',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2F2F2F),
                  ),
                ),
              ),
              const SizedBox(height: 5),
              Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.only(left: 20.0),
                child: const Text(
                  '정보를 입력해주세요',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF888888),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              InputCustomTextField(
                hintText: '아이디',
                // needCheckBox: true,
                controller: userIdController,
              ),
              const SizedBox(height: 8),
              InputCustomTextField(
                hintText: '비밀번호',
                controller: passwordController,
              ),
              const SizedBox(height: 8),
              InputCustomTextField(
                hintText: '핸드폰',
                onlyNum: true,
                // needCheckBox: true,
                controller: phoneController,
              ),
              const SizedBox(height: 8),
              InputCustomTextField(
                hintText: '이메일',
                controller: emailController,
              ),
              const SizedBox(height: 8),
              InputCustomTextField(
                hintText: '닉네임',
                controller: usernameController,
              ),
              const SizedBox(height: 40),
              CustomButton(
                buttonText: '회원가입',
                onPressed: () async {
                  try {
                    // 입력된 값을 가져오기
                    var userId = userIdController.text.trim();
                    var password = passwordController.text.trim();
                    var username = usernameController.text.trim();
                    var email = emailController.text.trim();
                    var phone = phoneController.text.trim();

                    // 필요한 경우 입력값 검증 로직 추가

                    // API 호출
                    var res = await UserService().createUser(
                      user_id: userId,
                      user_pw: password,
                      username: username,
                      email: email,
                      phone: phone,
                      site_id: siteId,
                      site_pw: sitePw,
                    );

                    // 회원가입 성공 시 처리
                    if (res["message"] == "회원가입 성공!") {
                      print("회원가입 성공: $res");
                      showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: const Text("회원가입이 완료되었습니다!"),
                          // content: Text("성공: ${res.toString()}"),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context); // 다이얼로그 닫기
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(builder: (context) => Login03()),
                                );
                              },
                              child: const Text("확인"),
                            ),
                          ],
                        ),
                      );
                    } else {
                      // 실패 처리: detail 필드에서 에러 메시지 추출
                      String errorMessage;
                      if (res['detail'] is List) {
                        errorMessage = (res['detail'] as List)
                            .map((e) => e['msg'])
                            .join('\n');
                      } else {
                        errorMessage = res['detail']?.toString() ?? '알 수 없는 오류';
                      }
                      print("회원가입 실패: $errorMessage");
                      showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: const Text("회원가입 실패", style: TextStyle(fontSize: 12)),
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
                    /// 예외 처리
                    print("회원가입 예외: ${e.toString()}");
                  }
                },
              ),
              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }
}
