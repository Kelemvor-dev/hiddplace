import 'package:flutter/material.dart';
import 'input_container.dart';

class RoundedInput extends StatelessWidget {

  final IconData icon;
  final String hint;
  final Color color;
  final Color bgcolor;
  final bool isEmail;
  final TextEditingController controller;

  const RoundedInput(
      {Key? key,
      required this.icon,
      required this.hint,
      required this.color,
      required this.bgcolor,
      required this.isEmail,
      required this.controller,
      })
      : super(key: key);



  @override
  Widget build(BuildContext context) {
    return InputContainer(
      bgColor: bgcolor,
      child: TextField(
          controller: controller,
          cursorColor: color,

          keyboardType:
              isEmail ? TextInputType.emailAddress : TextInputType.text,
          decoration: InputDecoration(
            icon: Icon(icon, color: color),
            hintText: hint,
            border: InputBorder.none,
          )),

    );
  }
}
