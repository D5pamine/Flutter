import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget{
  final String buttonText;
  final double textWidth, textHeight, textSize;
  final Color backColor, textColor;
  final FontWeight fontWeight;
  final EdgeInsets padding;
  final VoidCallback onPressed;

  CustomButton({required this.buttonText, this.textWidth = 350.0, this.textHeight = 52.0, this.textSize = 18,
    this.backColor=const Color(0xffFFB267), this.textColor= const Color(0xff211D1D), this.fontWeight = FontWeight.w400,
    this.padding = const EdgeInsets.symmetric(horizontal: 10, vertical: 4), required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          // minimumSize: Size.zero,
          backgroundColor: backColor,
          foregroundColor: textColor,

          fixedSize: Size(textWidth, textHeight),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(15)),
          ),
          // padding: padding,
        ),
        child: Text(buttonText, style: TextStyle(fontSize: textSize, fontWeight: fontWeight),),);
  }
}