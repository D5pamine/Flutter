import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget{
  final Widget child;
  final double? cardHeight, cardWidth;
  final EdgeInsets padding, margin;
  final Color cardLineColor;
  final BorderRadius cardBoarderR;

  const CustomCard({Key? key, required this.child, this.cardHeight,
  this.padding = const EdgeInsets.all(13.0),
    this.margin = const EdgeInsets.symmetric(vertical: 00.0),
    this.cardWidth = 315.0, this.cardLineColor = Colors.white,  this.cardBoarderR = const BorderRadius.all(Radius.circular(16)),
  }) : super(key: key);

  @override
  Widget build(BuildContext context){
    return Container(
      alignment: Alignment.center, // ✅ 컨테이너 내부에서 요소를 세로/가로 중앙 정렬
      height: cardHeight,
      width: cardWidth,
      margin: margin,
      padding: padding,
      decoration:
      BoxDecoration(
        border: Border.all(color: cardLineColor, width: 2.0),
        color: Colors.white,
      borderRadius: cardBoarderR,
        boxShadow:[
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 8,
            spreadRadius: 2,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: child,
    );
  }
}