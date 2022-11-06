import 'dart:ffi';

import 'package:flutter/material.dart';
import '../../views/components/input_container.dart';

class RoundedInput extends StatelessWidget {
  final IconData icon;
  final String hint;
  final Color color;
  final Color bgcolor;
  final bool isEmail;
  final TextEditingController controller;
  final int? maxLe;

  const RoundedInput({
    Key? key,
    required this.icon,
    required this.hint,
    required this.color,
    required this.bgcolor,
    required this.isEmail,
    required this.controller,
    this.maxLe,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InputContainer(
      bgColor: bgcolor,
      child: TextField(
          style: TextStyle(color: color),
          controller: controller,
          maxLength: maxLe ?? null,
          cursorColor: color,
          keyboardType: isEmail ? TextInputType.emailAddress : TextInputType.text,
          decoration: InputDecoration(
            icon: Icon(icon, color: color),
            hintText: hint,
            hintStyle: TextStyle(color: color),
            border: InputBorder.none,
          )),
    );
  }
}
