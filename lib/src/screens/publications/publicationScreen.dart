import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hiddplace/constants.dart';
import 'package:provider/provider.dart';
import 'package:hiddplace/src/models/publications.dart';
import 'package:hiddplace/src/components/carusel.dart';

class PublicationScreen extends StatelessWidget {
  const PublicationScreen({super.key});

  Widget _buildComment(int index) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: ListTile(
        leading: Container(
          width: 50.0,
          height: 50.0,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black45,
                offset: Offset(0, 2),
                blurRadius: 6.0,
              ),
            ],
          ),
          child: const CircleAvatar(
            child: ClipOval(
              child: Image(
                height: 50.0,
                width: 50.0,
                image: AssetImage('assets/images/profile.jpeg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        title: const Text(
          'jeyson garcia',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: const Text('hola mundo'),
        trailing: IconButton(
          icon: const Icon(
            Icons.favorite_border,
          ),
          color: Colors.grey,
          onPressed: () => print('Like comment'),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final publications = Provider.of<List<Publication>>(context);
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: kPrimaryColor,
        onPressed: () {
          Navigator.pushNamed(context, 'createPublication');
        },
        child: const FaIcon(
          color: UiColors.white,
          FontAwesomeIcons.circlePlus,
          size: 35,
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
                                          ),
                                        ),
                                        subtitle: Text(
                                            '${publications[index].date?.toDate().day.toString()}-${publications[index].date?.toDate().month.toString()}-${publications[index].date?.toDate().year.toString()}'),
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
                                        borderRadius: BorderRadius.circular(80.0),
                                        boxShadow:  [
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
    );
  }
}
