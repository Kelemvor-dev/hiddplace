import 'package:flutter/material.dart';

import '../../../constants.dart';
import '../../views/components/input_container.dart';

class RoundedPasswordInput extends StatelessWidget {
  final String hint;
  final Color bgColor;
  final Color color;
  final TextEditingController controller;



  const RoundedPasswordInput({
    Key? key,
    required this.hint,
    required this.bgColor,
    required this.color,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InputContainer(
      bgColor: bgColor,
      child: TextField(
          style: TextStyle(color: color),
          controller: controller,
          cursorColor: color,
          obscureText: true,
          decoration: InputDecoration(
            icon: Icon(Icons.lock, color: color),
            hintText: hint,
            hintStyle: TextStyle(color: color),
            border: InputBorder.none,
          )),
    );
  }
}
