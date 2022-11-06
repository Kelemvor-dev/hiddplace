import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hiddplace/constants.dart';
import 'package:hiddplace/src/models/entity/comments.dart';
import 'package:hiddplace/src/models/entity/publications.dart';
import 'package:hiddplace/src/models/entity/publicationsUser.dart';
import 'package:hiddplace/src/models/providers/profile.dart';
import 'package:hiddplace/src/views/screens/home.dart';
import 'package:hiddplace/src/views/screens/login.dart';
import 'package:hiddplace/src/views/screens/publications/createPublicationScreen.dart';
import 'package:hiddplace/src/views/screens/users/editProfile.dart';
import 'package:hiddplace/src/models/services/firebaseAuthMethods.dart';
import 'package:hiddplace/src/models/services/publications.dart';
import 'package:provider/provider.dart';

class App extends StatelessWidget {
  const App({super.key});

  get publicationID => null;

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
        ),
        StreamProvider<List<Publication>>(
          create: (_) => Publications().getPublications(),
          initialData: const [],
        ),
        StreamProvider<List<PublicationUser>>(
          create: (_) => Publications().getPublicationsByUserID(),
           initialData: const [],
         ),
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
