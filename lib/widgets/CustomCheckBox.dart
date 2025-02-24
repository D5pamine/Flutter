import 'package:flutter/material.dart';

class CustomCheckBox extends StatelessWidget {
  final isChecked = true;

  const CustomCheckBox({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Checkbox(
          tristate: true,
          value: isChecked,
          onChanged: (bool? value) {},
        ),
      ],
    );
  }
}