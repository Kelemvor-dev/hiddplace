import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hiddplace/constants.dart';
import 'package:provider/provider.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../../../models/services/publications.dart';

class PopNavbar extends StatefulWidget implements PreferredSizeWidget {
  final String title;
  final String categoryOne;
  final String categoryTwo;
  final bool searchBar;
  final bool backButton;
  final bool transparent;
  final bool reverseTextcolor;
  final bool rightOptions;
  final bool isOnSearch;
  final bool searchAutofocus;
  final bool noShadow;
  final Color bgColor;

  const PopNavbar(
      {super.key,
      this.title = "Home",
      this.categoryOne = "",
      this.categoryTwo = "",
      this.transparent = false,
      this.rightOptions = true,
      this.reverseTextcolor = false,
      this.isOnSearch = false,
      this.searchAutofocus = false,
      this.backButton = false,
      this.noShadow = false,
      this.bgColor = Colors.white,
      this.searchBar = false});

  final double _prefferedHeight = 180.0;

  @override
  _PopNavbarState createState() => _PopNavbarState();

  @override
  Size get preferredSize => Size.fromHeight(_prefferedHeight);
}

class _PopNavbarState extends State<PopNavbar> {
  ItemScrollController _scrollController = ItemScrollController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final bool categories = widget.categoryOne.isNotEmpty && widget.categoryTwo.isNotEmpty;

    return Container(
        height: 55,
        decoration: BoxDecoration(color: !widget.transparent ? widget.bgColor : Colors.transparent, boxShadow: [
          BoxShadow(
              color: !widget.transparent && !widget.noShadow ? UiColors.Kmuted : Colors.transparent,
              spreadRadius: -10,
              blurRadius: 12,
              offset: const Offset(0, 5))
        ]),
        child: Padding(
          padding: const EdgeInsets.only(left: 8.0, right: 8.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(left: 20),
                          child:Center(
                          child: Text(widget.title,
                              style: GoogleFonts.montserrat(
                                  textStyle: Theme.of(context).textTheme.headline4,
                                  fontSize: 19,
                                  fontWeight: FontWeight.w400,
                                  color: !widget.transparent
                                      ? (widget.bgColor == Colors.white ? Colors.black : Colors.white)
                                      : (widget.reverseTextcolor ? Colors.black : Colors.white))))),


                    ],
                  ),
                  if (widget.rightOptions)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      //Si quiero poner iconos en el PopNavbar
                      children: [
                        IconButton(
                          icon: const Icon(FontAwesomeIcons.circleXmark,
                            size: 30.0,
                            color: UiColors.white,
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          }),
                      ],
                    )
                ],
              ),
              if (widget.searchBar)
                const SizedBox(
                  height: 10.0,
                ),
              if (categories)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        // Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: (context) => Trending()));
                      },
                      child: Row(
                        children: [
                          const Icon(Icons.camera, color: Colors.black, size: 18.0),
                          const SizedBox(width: 8),
                          Text(widget.categoryOne, style: const TextStyle(color: Colors.black, fontSize: 14.0)),
                        ],
                      ),
                    ),
                    const SizedBox(width: 30),
                    Container(
                      color: Colors.black,
                      height: 25,
                      width: 1,
                    ),
                    const SizedBox(width: 30),
                    GestureDetector(
                      onTap: () {
                        // Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: (context) => Fashion()));
                      },
                      child: Row(
                        children: [
                          const Icon(Icons.shopping_cart, color: Colors.black, size: 18.0),
                          const SizedBox(width: 8),
                          Text(widget.categoryTwo, style: const TextStyle(color: Colors.black, fontSize: 14.0)),
                        ],
                      ),
                    )
                  ],
                ),
            ],
          ),
        ));
  }
}
