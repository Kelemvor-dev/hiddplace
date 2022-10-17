import 'package:flutter/material.dart';

import '../../constants.dart';
import 'input_container.dart';

class RoundedPasswordInput extends StatelessWidget {
  final String hint;
  final Color bgColor;
  final TextEditingController controller;

  const RoundedPasswordInput({
    Key? key,
    required this.hint,
    required this.bgColor,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InputContainer(
      bgColor: bgColor,
      child: TextField(
          controller: controller,
          cursorColor: kPrimaryColor,
          obscureText: true,
          decoration: InputDecoration(
            icon: Icon(Icons.lock, color: bgColor),
            hintText: hint,
            border: InputBorder.none,
          )),
    );
  }
}
