import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hiddplace/constants.dart';
import 'package:hiddplace/src/components/carusel.dart';
import 'package:hiddplace/src/components/navbar/drawer.dart';
import 'package:hiddplace/src/models/publicationsUser.dart';
import 'package:hiddplace/src/providers/profile.dart';
import 'package:hiddplace/src/services/publications.dart';
import 'package:provider/provider.dart';
import 'package:avatar_view/avatar_view.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileState();
}

class _ProfileState extends State<ProfileScreen> {
  final userId = FirebaseAuth.instance.currentUser?.uid;
  @override
  void initState() {
    super.initState();
  }

  void deletePubli(id){
    context.read<Publications>().deletePublication(context, userId, id);
  }

  @override
  Widget build(BuildContext context) {
    final publications = Provider.of<List<PublicationUser>>(context);

    return Consumer<ProfileData>(
      builder: (context, profile, child) {
        return Scaffold(
          drawer: const NowDrawer(currentPage: "Profile"),
          body: Stack(
            children: [
              Column(
                children: [
                  Flexible(
                    flex: 1,
                    child: Container(
                        decoration: const BoxDecoration(
                            // image: DecorationImage(
                            //     image: AssetImage("assets/imgs/bg-profile.png"),
                            //     fit: BoxFit.cover),
                            color: kPrimaryColor),
                        child: Stack(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(top: 10, right: 0),
                              child: Column(
                                children: [
                                  if (context.watch<ProfileData>().photoUrl == '') ...[
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
                                    Container( width:130,
                                        child:CircleAvatar(backgroundImage: NetworkImage(context.watch<ProfileData>().photoUrl), radius: 65.0))
                                  ],
                                  Padding(
                                    padding: const EdgeInsets.only(top: 10.0),
                                    child: Text('${context.watch<ProfileData>().name} ${context.watch<ProfileData>().lastname}',
                                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 22)),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 20.0, left: 42, right: 32),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      mainAxisSize: MainAxisSize.max,
                                      //Si quiero agregar mas cosas dentro del perfil children: [],
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        )),
                  ),
                  Flexible(
                      flex: 2,
                      child: SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        child: Column(
                        // Aqui van las publicaciones
                        children: [
                          Container(
                            child: (publications != null)
                                ? ListView.builder(
                                    padding: const EdgeInsets.all(5.5),
                                    itemCount: publications.length,
                                    shrinkWrap: true,
                                    physics: const NeverScrollableScrollPhysics(),
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
                                                    children: <Widget>[
                                                      Row(
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
                                                                      ? Image.network(
                                                                          publications[index].user!['imageUrl'],
                                                                          fit: BoxFit.cover,
                                                                        )
                                                                      : Image.asset('assets/images/profile.jpeg'),
                                                                ),
                                                              ),
                                                              title: Text(
                                                                '${publications[index].user!['name']} ${publications[index].user!['lastname']}',
                                                                style: const TextStyle(
                                                                  fontWeight: FontWeight.bold,
                                                                  fontSize: 14
                                                                ),
                                                              ),
                                                              subtitle: Text(
                                                                  '${publications[index].date?.toDate().day.toString()}-${publications[index].date?.toDate().month.toString()}-${publications[index].date?.toDate().year.toString()}'),
                                                              trailing: IconButton(
                                                                icon: const Icon(FontAwesomeIcons.trashCan,color: UiColors.error,),
                                                                color: Colors.black,
                                                                onPressed: () => deletePubli(publications[index].id),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      Text(
                                                        '${publications[index].title}',
                                                        style: GoogleFonts.montserrat(
                                                            textStyle: Theme.of(context).textTheme.headline4,
                                                            fontSize: 18,
                                                            fontWeight: FontWeight.w400,
                                                            color: kPrimaryColor),
                                                      ),
                                                      Padding(
                                                          padding: const EdgeInsets.only(left: 25, right: 25, top: 5),
                                                          child: Text(
                                                            '${publications[index].content}',
                                                            textAlign: TextAlign.justify,
                                                            style: GoogleFonts.montserrat(
                                                                textStyle: Theme.of(context).textTheme.headline4,
                                                                fontSize: 16,
                                                                fontWeight: FontWeight.w400,
                                                                color: kPrimaryColor),
                                                          )),
                                                      InkWell(
                                                        onDoubleTap: () => print('Like post'),
                                                        child: Container(
                                                            margin: const EdgeInsets.all(10.0),
                                                            width: double.infinity,
                                                            height: 320.0,
                                                            decoration: BoxDecoration(
                                                              borderRadius: BorderRadius.circular(10.0),
                                                              boxShadow: const [
                                                                BoxShadow(
                                                                  color: kPrimaryColor,
                                                                  offset: Offset(0, 10),
                                                                  blurRadius: 90.0,
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
                                                                    IconButton(
                                                                      icon: const Icon(FontAwesomeIcons.thumbsUp),
                                                                      iconSize: 30.0,
                                                                      onPressed: () => print('Like post'),
                                                                    ),
                                                                    const Text(
                                                                      '2,515',
                                                                      style: TextStyle(
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
                                                                        print('Chat');
                                                                      },
                                                                    ),
                                                                    const Text(
                                                                      '350',
                                                                      style: TextStyle(
                                                                        fontSize: 14.0,
                                                                        fontWeight: FontWeight.w600,
                                                                      ),
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
                          )
                        ]),
                      )),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
