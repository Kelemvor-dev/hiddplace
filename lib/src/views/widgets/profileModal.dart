import 'package:avatar_view/avatar_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hiddplace/constants.dart';
import 'package:hiddplace/src/controllers/followerController.dart';
import 'package:hiddplace/src/models/entity/publications.dart';
import 'package:hiddplace/src/models/providers/profile.dart';
import 'package:hiddplace/src/models/repository/follower.dart';
import 'package:hiddplace/src/models/repository/publications.dart';

import '../../../utils/cachedNetworkImage.dart';

class ProfileModal extends StatefulWidget {
  final String? userId;

  const ProfileModal({Key? key, required this.userId}) : super(key: key);

  @override
  State<ProfileModal> createState() => _ProfileModalState();
}

class _ProfileModalState extends State<ProfileModal> {
  final userId = FirebaseAuth.instance.currentUser?.uid;
  @override
  Widget build(BuildContext context) {
    return Container(
        height: 200,
        color: kPrimaryColor,
        child: FutureBuilder(
            future: ProfileData().getProfileByID(widget.userId),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator(color: UiColors.white));
              } else if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasError) {
                  return const Text('Ha ocurrido un error');
                } else if (snapshot.hasData) {
                  return Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 10, top: 20),
                        child: Row(
                          children: [
                            if (snapshot.data['imageUrl'].toString() == '') ...[
                              const AvatarView(
                                radius: 60,
                                borderWidth: 8,
                                borderColor: kSecundaryColor,
                                avatarType: AvatarType.CIRCLE,
                                backgroundColor: Colors.white,
                                imagePath: "assets/images/profile.jpeg",
                                placeHolder: Icon(
                                  Icons.person,
                                  size: 50,
                                ),
                                errorWidget: Icon(
                                  Icons.error,
                                  size: 50,
                                ),
                              ),
                            ] else ...[
                              Container(
                                width: 80.0,
                                height: 80.0,
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                decoration: const BoxDecoration(shape: BoxShape.circle),
                                child: snapshot.data['imageUrl'] != ''
                                    ? cachedNetworkImage(snapshot.data['imageUrl'])
                                    : Image.asset('assets/images/profile.jpeg'),
                              ),
                            ],
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  StreamBuilder(
                                    stream: Publications().getNumPublicationsByUser(widget.userId),
                                    builder: (context, publications) {
                                      return Padding(
                                        padding: const EdgeInsets.only(left: 10, right: 8),
                                        child: Column(
                                          children: [
                                            Text(
                                              (publications.data?.docs != null) ? '${publications.data?.docs!.length}' : '0',
                                              style: GoogleFonts.montserrat(
                                                  textStyle: Theme.of(context).textTheme.headline4,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w400,
                                                  color: UiColors.white),
                                            ),
                                            Text(
                                              'Publicaciones',
                                              style: GoogleFonts.montserrat(
                                                  textStyle: Theme.of(context).textTheme.headline4,
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w400,
                                                  color: UiColors.white),
                                            )
                                          ],
                                        ),
                                      );
                                    }
                                  ),
                                  StreamBuilder(
                                      stream: Follower().getfollowedsByID(widget.userId),
                                      builder: (context, followers) {
                                        return Padding(
                                          padding: const EdgeInsets.only(right: 8),
                                          child: Column(
                                            children: [
                                              Text(
                                                (followers.data?.docs != null) ? '${followers.data?.docs!.length}' : '0',
                                                style: GoogleFonts.montserrat(
                                                    textStyle: Theme.of(context).textTheme.headline4,
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w400,
                                                    color: UiColors.white),
                                              ),
                                              Text(
                                                'Seguidores',
                                                style: GoogleFonts.montserrat(
                                                    textStyle: Theme.of(context).textTheme.headline4,
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.w400,
                                                    color: UiColors.white),
                                              )
                                            ],
                                          ),
                                        );
                                      }),
                                  StreamBuilder(
                                      stream: Follower().getFollowersByID(widget.userId),
                                      builder: (context, followed) {
                                        return Column(
                                          children: [
                                            Text(
                                              (followed.data?.docs != null) ? '${followed.data?.docs!.length}' : '0',
                                              style: GoogleFonts.montserrat(
                                                  textStyle: Theme.of(context).textTheme.headline4,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w400,
                                                  color: UiColors.white),
                                            ),
                                            Text(
                                              'Seguidos',
                                              style: GoogleFonts.montserrat(
                                                  textStyle: Theme.of(context).textTheme.headline4,
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w400,
                                                  color: UiColors.white),
                                            )
                                          ],
                                        );
                                      })
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: Text('${snapshot.data['name'].toString()} ${snapshot.data['lastname'].toString()}',
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 22)),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 42, right: 32),
                        child: StreamBuilder(
                          stream: Follower().getfollowedsByIDAndUserID(userId,widget.userId),
                          builder: (context, followedUser) {
                            if (followedUser.connectionState == ConnectionState.waiting) {
                              return const CircularProgressIndicator(color: kPrimaryColor,);
                            } else if (followedUser.connectionState == ConnectionState.active
                                || followedUser.connectionState == ConnectionState.done) {
                              if (followedUser.hasError) {
                                return const Text('Error');
                              } else if (followedUser.hasData) {
                                return SingleChildScrollView(
                                    scrollDirection: Axis.vertical,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        if (userId != snapshot.data['userID']) ...[
                                          //Botones Seguir y dejar de seguir
                                          if(followedUser.data!.docs.isNotEmpty)...[
                                            TextButton(
                                              onPressed: () {
                                                FollowerController.unfollow(followedUser.data!.docs[0]['id'], context);
                                              },
                                              child: Container(
                                                width: 150,
                                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: kBackgroundColor),
                                                padding: const EdgeInsets.symmetric(vertical: 5),
                                                alignment: Alignment.center,
                                                child: const Text(
                                                  "Dejar de Seguir",
                                                  style: TextStyle(
                                                    color: UiColors.white,
                                                    fontSize: 16,
                                                  ),
                                                ),
                                              ),
                                            )
                                          ]else...[
                                            TextButton(
                                              onPressed: () {
                                                FollowerController.follow(userId, snapshot.data['userID'], snapshot.data, context);
                                              },
                                              child: Container(
                                                width: 100,
                                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: kBackgroundColor),
                                                padding: const EdgeInsets.symmetric(vertical: 5),
                                                alignment: Alignment.center,
                                                child: const Text(
                                                  "Seguir",
                                                  style: TextStyle(
                                                    color: UiColors.white,
                                                    fontSize: 16,
                                                  ),
                                                ),
                                              ),
                                            )
                                          ]
                                        ] else ...[
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pushNamedAndRemoveUntil(context, 'editProfile', (Route<dynamic> route) => false);
                                            },
                                            child: Container(
                                              width: 100,
                                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: kBackgroundColor),
                                              padding: const EdgeInsets.symmetric(vertical: 5),
                                              alignment: Alignment.center,
                                              child: const Text(
                                                "Editar Perfil",
                                                style: TextStyle(
                                                  color: UiColors.white,
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      ],
                                    ));
                              } else {
                                return const Text('Empty data');
                              }
                            } else {
                              return Text('State: ${snapshot.connectionState}');
                            }
                          }
                        ),
                      )
                    ],
                  );
                } else {
                  return const Text('Empty data');
                }
              } else {
                return Text('State: ${snapshot.connectionState}');
              }
            }));
  }
}
