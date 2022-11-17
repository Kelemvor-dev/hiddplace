import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants.dart';

class Alert {
  static alertAuth(context, message) async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)), //this right here
              child: Stack(
                alignment: Alignment.topCenter,
                children: [
                  Container(
                    height: 200,
                    width: double.infinity,
                    color: kPrimaryColor,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(10, 70, 10, 10),
                      child: Column(
                        children: [
                          Text(
                            'Error',
                            style: GoogleFonts.montserrat(
                                textStyle: Theme.of(context).textTheme.headline4, fontSize: 20, fontWeight: FontWeight.w400, color: UiColors.white),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            message,
                            style: GoogleFonts.montserrat(
                                textStyle: Theme.of(context).textTheme.headline4, fontSize: 16, fontWeight: FontWeight.w400, color: UiColors.white),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          TextButton(
                            style: TextButton.styleFrom(backgroundColor: Colors.white, padding: const EdgeInsets.all(2)),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text(
                              'Aceptar',
                              style: GoogleFonts.montserrat(
                                  textStyle: Theme.of(context).textTheme.headline4, fontSize: 12, fontWeight: FontWeight.w400, color: kPrimaryColor),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                      top: -60,
                      child: CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 60,
                        child: Container(
                          margin: const EdgeInsets.only(top: 50),
                          child: const Icon(
                            FontAwesomeIcons.bug,
                            color: kPrimaryColor,
                          ),
                        ),
                      ))
                ],
              ));
        });
  }

  static alertSucess(context, message) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return Dialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)), //this right here
            child: Stack(
              alignment: Alignment.topCenter,
              children: [
                Container(
                  height: 225,
                  width: double.infinity,
                  color: kPrimaryColor,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(10, 70, 10, 10),
                    child: Column(
                      children: [
                        Text(
                          'Proceso Exitoso',
                          style: GoogleFonts.montserrat(
                              textStyle: Theme.of(context).textTheme.headline4, fontSize: 20, fontWeight: FontWeight.w400, color: UiColors.white),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          message,
                          style: GoogleFonts.montserrat(
                              textStyle: Theme.of(context).textTheme.headline4, fontSize: 14, fontWeight: FontWeight.w400, color: UiColors.white),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        TextButton(
                          style: TextButton.styleFrom(backgroundColor: Colors.white, padding: const EdgeInsets.all(2)),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            'Aceptar',
                            style: GoogleFonts.montserrat(
                                textStyle: Theme.of(context).textTheme.headline4, fontSize: 12, fontWeight: FontWeight.w400, color: kPrimaryColor),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Positioned(
                    top: -60,
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 60,
                      child: Container(
                        margin: const EdgeInsets.only(top: 50),
                        child: const Icon(
                          FontAwesomeIcons.fileCircleCheck,
                          color: kPrimaryColor,
                        ),
                      ),
                    ))
              ],
            ));
      },
    );
  }
}
