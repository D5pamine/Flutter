import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'CustomButton.dart';

class InputCustomTextField extends StatelessWidget {
  final String hintText;
  final bool onlyNum;
  final bool needCheckBox;
  final TextEditingController controller;

  InputCustomTextField({
    required this.hintText,
    this.onlyNum = false,
    this.needCheckBox = false,
    TextEditingController? controller,
  }) : controller = controller ?? TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFD2D2D2), width: 1.5),
      ),
      width: 315.0,
      height: 52.0,
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        children: [
          Center(
            child: SizedBox(
              width: 70,
              child: Text(
                hintText,
                style: const TextStyle(color: Colors.grey, fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Container(width: 1, height: 20, color: Colors.grey),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: controller,
              keyboardType: onlyNum
                  ? const TextInputType.numberWithOptions(decimal: false)
                  : TextInputType.text,
              inputFormatters: onlyNum
                  ? [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(11),
              ]
                  : null,
              decoration: const InputDecoration(
                border: InputBorder.none,
              ),
            ),
          ),
          if (needCheckBox) const SizedBox(width: 10),
          if (needCheckBox)
            CustomButton(
              buttonText: '중복확인',
              textWidth: 50.0,
              textHeight: 40.0,
              textSize: 10.0,
              backColor: const Color(0xffF0F3FA),
              textColor: const Color(0xff1F87FE),
              onPressed: () {},
            ),
        ],
      ),
    );
  }
}