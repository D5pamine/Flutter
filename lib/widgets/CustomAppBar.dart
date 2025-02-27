import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {

  const CustomAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var now = DateTime.now();
    var date = DateFormat('yyyy-MM-dd (E)', 'ko').format(now);

    return AppBar(
      automaticallyImplyLeading: false, // ✅ 기본 뒤로가기 버튼 제거
      titleSpacing: 20, // ✅ 제목을 완전히 왼쪽에 붙이기
      title: Padding(
        padding: const EdgeInsets.only(left: 00.0, top: 00.0, right: 00.0, bottom: 00.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.asset('assets/images/Pchew_logo.png', height: 50,),
            Text(
              date,
              style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 15),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(60); // ✅ AppBar의 높이 지정
}
