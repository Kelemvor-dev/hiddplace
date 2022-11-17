import 'package:flutter/material.dart';

const kPrimaryColor = Color(0xff261E17);
const kBackgroundColor = Color(0XFF594D42);
const kSecundaryColor = Color(0xFFEDEAE3);
const kRegisterBgColor = Color(0xFFEDEAE3);

class UiColors {
  static const Color ktabs = Color.fromRGBO(222, 222, 222, 0.3);

  static const Color kmuted = Color.fromRGBO(136, 152, 170, 1.0);

  static const Color like = Color.fromRGBO(255, 0, 0, 1.0);

  static const Color black = Color(0xFF000000);

  static const Color white = Color(0xFFFFFFFF);

  static const Color defaultColor = Color.fromRGBO(136, 136, 136, 1.0);

  static const Color primary = kPrimaryColor;

  static const Color secondary = Color.fromRGBO(68, 68, 68, 1.0);

  static const Color label = Color.fromRGBO(254, 36, 114, 1.0);

  static const Color neutral = Color.fromRGBO(255, 255, 255, 0.2);

  static const Color tabs = Color.fromRGBO(222, 222, 222, 0.3);

  static const Color info = Color.fromRGBO(44, 168, 255, 1.0);

  static const Color error = Color.fromRGBO(255, 54, 54, 1.0);

  static const Color success = Color.fromRGBO(24, 206, 15, 1.0);

  static const Color warning = Color.fromRGBO(255, 178, 54, 1.0);

  static const Color text = Color.fromRGBO(44, 44, 44, 1.0);

  static const Color bgColorScreen = Color.fromRGBO(255, 255, 255, 1.0);

  static const Color border = Color.fromRGBO(231, 231, 231, 1.0);

  static const Color inputSuccess = Color.fromRGBO(27, 230, 17, 1.0);

  static const Color input = Color.fromRGBO(220, 220, 220, 1.0);

  static const Color inputError = Color.fromRGBO(255, 54, 54, 1.0);

  static const Color muted = Color.fromRGBO(136, 152, 170, 1.0);

  // static const Color text = Color.fromRGBO(50, 50, 93, 1.0);

  static const Color time = Color.fromRGBO(154, 154, 154, 1.0);

  static const Color priceColor = Color.fromRGBO(234, 213, 251, 1.0);

  static const Color active = Color.fromRGBO(249, 99, 50, 1.0);

  static const Color buttonColor = Color.fromRGBO(156, 38, 176, 1.0);

  static const Color placeholder = Color.fromRGBO(159, 165, 170, 1.0);

  static const Color switchON = Color.fromRGBO(249, 99, 50, 1.0);

  static const Color switchOFF = Color.fromRGBO(137, 137, 137, 1.0);

  static const Color gradientStart = Color.fromRGBO(107, 36, 170, 1.0);

  static const Color gradientEnd = Color.fromRGBO(172, 38, 136, 1.0);

  static const Color socialFacebook = Color.fromRGBO(59, 89, 152, 1.0);

  static const Color socialTwitter = Color.fromRGBO(91, 192, 222, 1.0);

  static const Color socialDribbble = Color.fromRGBO(234, 76, 137, 1.0);

  static const MaterialColor kToWhite = MaterialColor(
    0xffe55f48, // 0% comes in here, this will be color picked if no shade is selected when defining a Color property which doesn’t require a swatch.
    <int, Color>{
      50: Color(0xffffffff), //10%
      100: Color(0xffffffff), //20%
      200: Color(0xffffffff), //30%
      300: Color(0xffffffff), //40%
      400: Color(0xffffffff), //50%
      500: Color(0xffffffff), //60%
      600: Color(0xffffffff), //70%
      700: Color(0xffffffff), //80%
      800: Color(0xffffffff), //90%
      900: Color(0xffffffff), //100%
    },
  );
}