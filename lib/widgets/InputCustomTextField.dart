import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'CustomButton.dart';

class InputCustomTextField extends StatelessWidget{
  final String hintText;
  final bool onlyNum;
  final bool needCheckBox;

  InputCustomTextField({required this.hintText,
    this.onlyNum=false, this.needCheckBox=false});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),  // 둥근 테두리 적용
        border: Border.all(color: const Color(0xFFD2D2D2), width: 1.5),  // 테두리 스타일
      ),
      width: 315.0,
      height: 52.0,
      padding: const EdgeInsets.symmetric(horizontal: 15),  // 내부 패딩 추가
      child: Row(
        children: [
          Center(
            child: SizedBox(
              width:70,
              child: Text(
                hintText,  // 아이디 / 비밀번호 텍스트 (고정)
                style: const TextStyle(color: Colors.grey, fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          const SizedBox(width: 10),  // ✅ 아이디/비밀번호 글자와 입력칸 사이 간격
          Container(width: 1, height: 20, color: Colors.grey),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              keyboardType: onlyNum
                  ? const TextInputType.numberWithOptions(decimal: false)  // ✅ 숫자만 입력 가능
                  : TextInputType.text,
              inputFormatters: onlyNum
                  ? [
                FilteringTextInputFormatter.digitsOnly,  // ✅ 숫자만 입력 허용
                LengthLimitingTextInputFormatter(11),     // ✅ 최대 11자리 제한
              ]
                  : null,  // ✅ `null`로 설정하면 기본 동작 유지
              decoration: const InputDecoration(
                border: InputBorder.none,
              ),
            ),
          ),
          if (needCheckBox == true)
            const SizedBox(width: 10), // ✅ 버튼과 입력 필드 사이 간격 추가

          if (needCheckBox == true)
            CustomButton(buttonText: '중복확인', textWidth: 50.0, textHeight: 40.0, textSize: 10.0,
                backColor: Color(0xffF0F3FA), textColor: Color(0xff1F87FE), onPressed: () {  },),
        ],
      ),
    );
  }
}