import 'package:flutter/material.dart';

class CustomColorBox extends StatelessWidget {
  final double boxWidth, boxHeight;
  final Color boxColor;
  final Icon? customIcon;

  const CustomColorBox({Key? key, required this.boxWidth, required this.boxHeight, required this.boxColor, this.customIcon});

  @override
  Widget build(BuildContext context){
    return Container(
      height: boxWidth,
      width: boxHeight,
      decoration:
      BoxDecoration(
        color: boxColor,
        borderRadius: BorderRadius.circular(3),
      ),
      child: customIcon != null ? customIcon : null,
    );
  }
}