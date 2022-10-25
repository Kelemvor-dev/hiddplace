import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hiddplace/constants.dart';
import 'package:hiddplace/src/app.dart';

// ignore: depend_on_referenced_packages
import 'package:page_transition/page_transition.dart';
import 'package:lottie/lottie.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.leanBack,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      theme: ThemeData(
        primarySwatch: UiColors.kToWhite,
      ),
      home: const SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: Column(
        children: [
          Container(
            // padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
            child: Text(
              'Hiddplace',
              style: GoogleFonts.montserrat(
                  textStyle: Theme.of(context).textTheme.headline4,
                  fontSize: 40,
                  fontWeight: FontWeight.w400,
                  color: UiColors.white),
            ),
          ),
          const SizedBox(height: 20),
          Container(
            width: 200,
              child:Lottie.asset('assets/hiddplace_animated.json')
          ),
          // se puede usar imagenes
        ],
      ),
      backgroundColor: kPrimaryColor,
      nextScreen: const App(),
      splashIconSize: 280,
      duration: 4000,
      splashTransition: SplashTransition.scaleTransition,
      pageTransitionType: PageTransitionType.bottomToTop,
    );
  }
}
