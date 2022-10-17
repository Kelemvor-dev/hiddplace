import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  const RoundedButton({
    Key? key,
    required this.title,
    required this.bgColor,
    required this.textColor,
    required this.onTap,
  }) : super(key: key);

  final String title;
  final Color bgColor;
  final Color textColor;
  final GestureTapCallback? onTap;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return InkWell(
      onTap: () {
        onTap;
      },
      borderRadius: BorderRadius.circular(30),
      child: Container(
        width: size.width * 0.4,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30), color: bgColor),
        padding: const EdgeInsets.symmetric(vertical: 15),
        alignment: Alignment.center,
        child: Text(
          title,
          style: TextStyle(
            color: textColor,
            fontSize: 18,
          ),
        ),
      ),
    );
  }
}
