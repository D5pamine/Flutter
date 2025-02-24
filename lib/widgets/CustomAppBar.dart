import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String titleText;

  const CustomAppBar({Key? key, this.titleText='픽카추'}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var now = DateTime.now();
    var date = DateFormat('yyyy-MM-dd (E)', 'ko').format(now);

    return AppBar(
      title: Padding(
        padding: const EdgeInsets.only(left: 20.0, top: 40.0, right: 20.0, bottom: 20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              titleText,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 28),
            ),
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
