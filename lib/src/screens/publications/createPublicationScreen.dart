import 'dart:io';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hiddplace/constants.dart';
import 'package:hiddplace/src/components/navbar/drawer.dart';
import 'package:hiddplace/src/components/navbar/navbar.dart';
import 'package:hiddplace/src/components/rounded_input.dart';
import 'package:hiddplace/src/components/rounded_textarea.dart';
import 'package:provider/provider.dart';
import 'package:hiddplace/src/services/publications.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_picker_platform_interface/image_picker_platform_interface.dart';

class CreatePublicationScreen extends StatefulWidget {
  const CreatePublicationScreen({super.key});

  @override
  State<CreatePublicationScreen> createState() => _CreatePublicationState();
}

class _CreatePublicationState extends State<CreatePublicationScreen> with SingleTickerProviderStateMixin {
  //Controladores para enviar informacion
  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();

  //image piker
  final ImagePicker imagePicker = ImagePicker();
  List<XFile>? imageFileList = [];
  void selectImages() async {
    final List<XFile> selectedImages = await imagePicker.pickMultiImage();
    if (selectedImages!.isNotEmpty) {
      imageFileList!.addAll(selectedImages);
    }
    setState(() {});
  }

  void savePublication() async {
    context.read<Publications>().savePublication(
          title: titleController.text,
          content: contentController.text,
          listImages: imageFileList,
          context: context,
        );
  }

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
              controller: titleController, bgcolor: kRegisterBgColor, color: kPrimaryColor, hint: "Titulo", icon: Icons.info_outline, isEmail: false),
          RoundedTextarea(
            controller: contentController,
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
                    itemCount: imageFileList!.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                    ),
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                          onTap: () => {
                                setState(() {
                                  imageFileList!.removeAt(index);
                                })
                              },
                          child: Padding(
                            padding: const EdgeInsets.all(5),
                            child: Image.file(
                              File(imageFileList![index].path),
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
              savePublication();
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
}
