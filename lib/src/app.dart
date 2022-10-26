import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hiddplace/constants.dart';
import 'package:hiddplace/src/providers/profile.dart';
import 'package:hiddplace/src/screens/home.dart';
import 'package:hiddplace/src/screens/login.dart';
import 'package:hiddplace/src/screens/publications/createPublicationScreen.dart';
import 'package:hiddplace/src/screens/users/editProfile.dart';
import 'package:hiddplace/src/services/firebaseAuthMethods.dart';
import 'package:hiddplace/src/services/publications.dart';
import 'package:provider/provider.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<FirebaseAuthMethods>(
          create: (_) => FirebaseAuthMethods(FirebaseAuth.instance),
        ),
        Provider<Publications>(
          create: (_) => Publications(),
        ),
        StreamProvider(
          create: (context) => context.read<FirebaseAuthMethods>().authState,
          initialData: null,
        ),
          ChangeNotifierProvider(
            create: (_) => ProfileData(),

        )
      ],
      child: MaterialApp(
        title: 'Hiddplace',
        theme: ThemeData(
          primarySwatch: UiColors.kToWhite,
        ),
        initialRoute: 'home',
        debugShowCheckedModeBanner: false,
        routes: {
          'home': (context) => const AuthWrapper(),
          'editProfile': (context) => const EditProfileScreen(),
          'createPublication': (context) => const CreatePublicationScreen(),
        },
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User?>();

    if (firebaseUser != null) {
      return const Home();
    }
    return const Login();
  }
}
