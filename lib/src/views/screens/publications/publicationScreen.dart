import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hiddplace/constants.dart';
import 'package:hiddplace/src/views/widgets/comments.dart';
import 'package:provider/provider.dart';
import 'package:hiddplace/src/models/entity/publications.dart';
import 'package:hiddplace/src/views/components/carusel.dart';

import '../../../../utils/cachedNetworkImage.dart';
import '../../../controllers/publicationController.dart';
import '../../widgets/profileModal.dart';

class PublicationScreen extends StatefulWidget {
  const PublicationScreen({super.key});

  @override
  State<PublicationScreen> createState() => _PublicationScreenState();
}

class _PublicationScreenState extends State<PublicationScreen> with SingleTickerProviderStateMixin {
  final userAuth = FirebaseAuth.instance.currentUser;
  final userId = FirebaseAuth.instance.currentUser?.uid;

  _buildComment(String? publicationID) {
    showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return Comments(
            publicationID: publicationID,
          );
        });
  }

  _buildProfile(String? userId) {
    showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return ProfileModal(
            userId: userId,
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final publications = Provider.of<List<Publication>>(context);
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.transparent,
        onPressed: () {
          Navigator.pushNamed(context, 'createPublication');
        },
        child: const FaIcon(
          color: kPrimaryColor,
          FontAwesomeIcons.circlePlus,
          size: 45,
        ),
      ),
      body: (publications != null)
          ? ListView.builder(
              padding: const EdgeInsets.all(5.5),
              itemCount: publications.length,
              itemBuilder: (context, index) {
                return Column(
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.only(top: 10.0),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: kRegisterBgColor,
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                InkWell(
                                    onTap: () {
                                      _buildProfile(publications[index].userID);
                                    },
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        SizedBox(
                                          width: MediaQuery.of(context).size.width * 0.9,
                                          child: ListTile(
                                            leading: Container(
                                              width: 80.0,
                                              height: 80.0,
                                              decoration: const BoxDecoration(
                                                shape: BoxShape.circle,
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: kPrimaryColor,
                                                    offset: Offset(0, 2),
                                                    blurRadius: 6.0,
                                                  ),
                                                ],
                                              ),
                                              child: Container(
                                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                                decoration: const BoxDecoration(shape: BoxShape.circle),
                                                child: publications[index].user!['imageUrl'] != ''
                                                    ? cachedNetworkImage(publications[index].user!['imageUrl'])
                                                    : Image.asset('assets/images/profile.jpeg'),
                                              ),
                                            ),
                                            title: Text(
                                              '${publications[index].user!['name']} ${publications[index].user!['lastname']}',
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            subtitle: Text(
                                                '${publications[index].date?.toDate().day.toString()}-${publications[index].date?.toDate().month.toString()}-${publications[index].date?.toDate().year.toString()}'),
                                          ),
                                        ),
                                      ],
                                    )),
                                Padding(
                                    padding: const EdgeInsets.only(left: 25, right: 25, top: 5),
                                    child: Text(
                                      '${publications[index].title}',
                                      style: GoogleFonts.montserrat(
                                          textStyle: Theme.of(context).textTheme.headline4,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w400,
                                          fontStyle: FontStyle.italic,
                                          color: kPrimaryColor),
                                    )),
                                Padding(
                                    padding: const EdgeInsets.only(left: 28, right: 28, top: 10),
                                    child: Text(
                                      '${publications[index].content}',
                                      textAlign: TextAlign.left,
                                      style: GoogleFonts.montserrat(
                                          textStyle: Theme.of(context).textTheme.headline4,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400,
                                          color: kPrimaryColor),
                                    )),
                                InkWell(
                                  //Por si a futuro quiero agregar funcinalidad a las imagenes
                                  onDoubleTap: () => print('Like post'),
                                  child: Container(
                                      margin: const EdgeInsets.all(10.0),
                                      width: double.infinity,
                                      height: 320.0,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(80.0),
                                        boxShadow: [
                                          BoxShadow(
                                            color: kPrimaryColor.withAlpha(80),
                                            offset: const Offset(0, 0),
                                            blurRadius: 99.0,
                                          ),
                                        ],
                                      ),
                                      child: Carousel(images: publications[index].images)),
                                ),
                                const SizedBox(height: 15.0),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Row(
                                        children: <Widget>[
                                          Row(
                                            children: <Widget>[
                                              //Logica Boton Like
                                              if (publications[index].likes!.contains(userId)) ...[
                                                IconButton(
                                                  icon: const Icon(
                                                    FontAwesomeIcons.solidThumbsUp,
                                                    color: UiColors.like,
                                                  ),
                                                  iconSize: 30.0,
                                                  onPressed: () => PublicationController.unlikePublication(
                                                      publications[index].id, publications[index].likes, userId, context),
                                                ),
                                              ] else ...[
                                                IconButton(
                                                  icon: const Icon(FontAwesomeIcons.thumbsUp),
                                                  iconSize: 30.0,
                                                  onPressed: () => PublicationController.likePublication(
                                                      publications[index].id, publications[index].likes, userId, context),
                                                ),
                                              ],
                                              Text(
                                                (publications[index].likes != null) ? '${publications[index].likes?.length}' : '0',
                                                style: const TextStyle(
                                                  fontSize: 14.0,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(width: 20.0),
                                          Row(
                                            children: <Widget>[
                                              IconButton(
                                                icon: const Icon(FontAwesomeIcons.comment),
                                                iconSize: 30.0,
                                                onPressed: () {
                                                  _buildComment(publications[index].id);
                                                },
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10.0),
                  ],
                );
              })
          : const Center(child: CircularProgressIndicator()),
    );
  }
}
