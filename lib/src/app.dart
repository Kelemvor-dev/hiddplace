import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hiddplace/constants.dart';
import 'package:hiddplace/src/models/entity/followers.dart';
import 'package:hiddplace/src/models/entity/publications.dart';
import 'package:hiddplace/src/models/entity/publicationsUser.dart';
import 'package:hiddplace/src/models/providers/profile.dart';
import 'package:hiddplace/src/models/repository/chat.dart';
import 'package:hiddplace/src/models/repository/follower.dart';
import 'package:hiddplace/src/views/screens/chat/chatTalkScreen.dart';
import 'package:hiddplace/src/views/screens/chat/newTalkScreen.dart';
import 'package:hiddplace/src/views/screens/home.dart';
import 'package:hiddplace/src/views/screens/login.dart';
import 'package:hiddplace/src/views/screens/publications/createPublicationScreen.dart';
import 'package:hiddplace/src/views/screens/users/editProfile.dart';
import 'package:hiddplace/src/models/repository/firebaseAuthMethods.dart';
import 'package:hiddplace/src/models/repository/publications.dart';
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
        Provider<Follower>(
          create: (_) => Follower(),
        ),
        Provider<Chat>(
          create: (_) => Chat(),
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
        StreamProvider<List<FollowersModel>>(
          create: (_) => Follower().getFollowers(),
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
          'newTalk': (context) => const NewTalkScreen(),
          'chatTalk': (context) => const ChatTalkScreen(),
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
