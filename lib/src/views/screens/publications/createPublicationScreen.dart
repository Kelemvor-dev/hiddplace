import 'dart:io';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hiddplace/constants.dart';
import 'package:hiddplace/src/controllers/publicationController.dart';
import 'package:hiddplace/src/views/components/navbar/drawer.dart';
import 'package:hiddplace/src/views/components/navbar/navbar.dart';
import 'package:hiddplace/src/views/components/rounded_input.dart';
import 'package:hiddplace/src/views/components/rounded_textarea.dart';
import 'package:lottie/lottie.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_picker_platform_interface/image_picker_platform_interface.dart';

class CreatePublicationScreen extends StatefulWidget {
  const CreatePublicationScreen({super.key});

  @override
  State<CreatePublicationScreen> createState() => _CreatePublicationState();
}

class _CreatePublicationState extends State<CreatePublicationScreen> with SingleTickerProviderStateMixin {
  //Controladores para enviar informacion
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: const Navbar(title: "Crear Publicación", transparent: false, bgColor: kPrimaryColor),
      drawer: const NowDrawer(currentPage: "createPublication"),
      body: Center(
          child: SingleChildScrollView(
              child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          RoundedInput(
            controller: _titleController,
            bgcolor: kRegisterBgColor,
            color: kPrimaryColor,
            hint: "Titulo",
            icon: Icons.info_outline,
            isEmail: false,
            maxLe: 30,
          ),
          RoundedTextarea(
            controller: _contentController,
            bgcolor: kRegisterBgColor,
            color: kPrimaryColor,
            hint: "Descripción",
            icon: Icons.info_outline,
          ),
          Text(
            'Imagenes',
            style: GoogleFonts.montserrat(
                textStyle: Theme.of(context).textTheme.headline4, fontSize: 20, fontWeight: FontWeight.w400, color: kPrimaryColor),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(2),
            margin: const EdgeInsets.only(left: 40, right: 40),
            height: 200,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: kRegisterBgColor,
                border: Border.all(
                  color: kPrimaryColor,
                  width: 1,
                )),
            child: Scaffold(
              body: Padding(
                padding: const EdgeInsets.all(9),
                child: GridView.builder(
                    physics: const ScrollPhysics(),
                    itemCount: _imageFileList!.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                    ),
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                          onTap: () => {
                                setState(() {
                                  _imageFileList!.removeAt(index);
                                })
                              },
                          child: Padding(
                            padding: const EdgeInsets.all(5),
                            child: Image.file(
                              File(_imageFileList![index].path),
                              fit: BoxFit.cover,
                            ),
                          ));
                    }),
              ),
              floatingActionButton: SizedBox(
                  width: 40,
                  child: FloatingActionButton(
                    backgroundColor: kPrimaryColor,
                    onPressed: () {
                      showModalBottomSheet(context: context, builder: ((builder) => bottomSheet()));
                    },
                    child: const FaIcon(
                      color: UiColors.white,
                      FontAwesomeIcons.circlePlus,
                      size: 30,
                    ),
                  )),
            ),
          ),
          const SizedBox(height: 20),
          InkWell(
            onTap: () {
              showModalBottomSheet<void>(
                context: context,
                isScrollControlled: true,
                builder: (BuildContext context) {
                  return Container(
                    height: MediaQuery.of(context).size.height,
                    color: kPrimaryColor,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text(
                            'Cargando...',
                            style: GoogleFonts.montserrat(
                                textStyle: Theme.of(context).textTheme.headline4, fontSize: 40, fontWeight: FontWeight.w400, color: UiColors.white),
                          ),
                          const SizedBox(height: 20),
                          SizedBox(width: 200, child: Lottie.asset('assets/hiddplace_animated.json')),
                        ],
                      ),
                    ),
                  );
                },
              );
              PublicationController.savePublication(context,_titleController,_contentController,_imageFileList);
            },
            borderRadius: BorderRadius.circular(30),
            child: Container(
              width: size.width * 0.4,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(30), color: kPrimaryColor),
              padding: const EdgeInsets.symmetric(vertical: 15),
              alignment: Alignment.center,
              child: const Text(
                "Guardar",
                style: TextStyle(
                  color: kSecundaryColor,
                  fontSize: 18,
                ),
              ),
            ),
          ),
        ],
      ))),
    );
  }

  Widget bottomSheet() {
    return Container(
      height: 110.0,
      width: MediaQuery.of(context).size.width,
      decoration: const BoxDecoration(color: kSecundaryColor),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "Seleccione las fotos de la publicación",
            style: TextStyle(fontSize: 20.0, color: kPrimaryColor),
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // InkWell(
              //   onTap: () {
              //     takePhoto(ImageSource.camera);
              //   },
              //   child: Padding(
              //     padding: const EdgeInsets.fromLTRB(10.0, 10.0, 20.0, 0.0),
              //     child: Row(
              //       children: const [
              //         Icon(
              //           Icons.camera,
              //           color: kPrimaryColor,
              //         ),
              //         Text(
              //           " Camara",
              //           style: TextStyle(color: kPrimaryColor),
              //         )
              //       ],
              //     ),
              //   ),
              // ),
              InkWell(
                onTap: () {
                  selectImages();
                },
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(10.0, 10.0, 20.0, 0.0),
                  child: Row(
                    children: const [
                      Icon(
                        Icons.image,
                        color: kPrimaryColor,
                      ),
                      Text(
                        " Galeria",
                        style: TextStyle(color: kPrimaryColor),
                      )
                    ],
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
  //image piker
  final ImagePicker imagePicker = ImagePicker();
  List<XFile>? _imageFileList = [];

  void selectImages() async {
    final List<XFile> selectedImages = await imagePicker.pickMultiImage();
    if (selectedImages!.isNotEmpty) {
      _imageFileList!.addAll(selectedImages);
    }
    setState(() {});
  }
}
