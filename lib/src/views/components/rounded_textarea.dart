import 'package:flutter/material.dart';
import '../../views/components/input_container.dart';

class RoundedTextarea extends StatelessWidget {
  final IconData icon;
  final String hint;
  final Color color;
  final Color bgcolor;
  final TextEditingController controller;

  const RoundedTextarea({
    Key? key,
    required this.icon,
    required this.hint,
    required this.color,
    required this.bgcolor,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InputContainer(
      bgColor: bgcolor,
      child: TextField(
          minLines: 6,
          maxLines: null,
          maxLength: 280,
          keyboardType: TextInputType.multiline,
          controller: controller,
          cursorColor: color,
          decoration: InputDecoration(
            prefixIcon: Container(transform: Matrix4.translationValues(-12, -48.0, 0.0), child: Icon(icon, color: color)),
            hintText: hint,
            border: InputBorder.none,
          )),
    );
  }
}
