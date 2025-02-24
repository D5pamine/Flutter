import 'package:flutter/material.dart';

import '../home01.dart';
import '../log02.dart';
import '../mypage01.dart';
import '../search01.dart';

class BottomNavi extends StatelessWidget {
  const BottomNavi({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 30,
      child: DecoratedBox(
        decoration: const BoxDecoration(
          // color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Home01()),
                );
              },
              child: Image.asset('assets/images/free-icon-home.png', height: 35,
              color: const Color(0xFF2F2F2F),),
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Log02()),
                );
              },
              child: Image.asset('assets/images/free-icon-clock.png', height: 40,
                color: const Color(0xFF2F2F2F),),
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Search01()),
                );
              },
              child: Image.asset('assets/images/free-icon-magnifying.png', height: 35,
                color: const Color(0xFF2F2F2F),),
            ),
             InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MyPage01()),
                );
              },
              child: Image.asset('assets/images/free-icon-user.png', height: 30,
                color: const Color(0xFF2F2F2F),),
             ),
          ],
        ),
      ),
    );
  }
}
