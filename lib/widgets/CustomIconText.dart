import 'package:flutter/material.dart';

import 'CustomColorBox.dart';

class CustomIconText extends StatelessWidget {
  final double boxWidth, boxHeight;
  final Color boxColor;
  final Icon? customIcon;
  final String customText;

  const CustomIconText({Key? key, required this.boxWidth, required this.boxHeight, required this.boxColor, this.customIcon, required this.customText});

  @override
  Widget build(BuildContext context){
    return Row( // ✅ 여러 개의 위젯을 담으려면 Row 또는 Column 사용
      children: [
        // CustomColorBox(
        //   boxWidth: boxWidth,
        //   boxHeight: boxHeight,
        //   boxColor: boxColor,
          // customIcon: customIcon,
        // ),
        const SizedBox(width: 5), // ✅ 간격 조정
        Text(customText,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 16,
            color: Color(0xFF848282),
          ),
        ),
      ],
    );

  }
}