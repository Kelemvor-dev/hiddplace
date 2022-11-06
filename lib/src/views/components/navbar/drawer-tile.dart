import 'package:flutter/material.dart';
import 'package:hiddplace/constants.dart';

class DrawerTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback? onTap;
  final bool isSelected;
  final Color iconColor;

  const DrawerTile(
      {super.key, required this.title,
      required this.icon,
      this.onTap,
      this.isSelected = false,
      this.iconColor = UiColors.text});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
          margin: const EdgeInsets.only(top: 6),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                    color: isSelected
                        ? UiColors.black.withOpacity(0.07)
                        : Colors.transparent,
                    offset: Offset(0, 0.5),
                    spreadRadius: 3,
                    blurRadius: 10)
              ],
              color: isSelected ? UiColors.white : UiColors.primary,
              borderRadius: BorderRadius.all(Radius.circular(54))),
          child: Row(
            children: [
              Icon(icon,
                  size: 18,
                  color: isSelected
                      ? UiColors.primary
                      : UiColors.white),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(title,
                    style: TextStyle(
                        letterSpacing: .3,
                        fontSize: 16,

                        color: isSelected
                            ? UiColors.primary
                            : UiColors.white)),
              )
            ],
          )),
    );
  }
}
