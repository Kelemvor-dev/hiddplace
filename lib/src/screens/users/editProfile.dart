import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hiddplace/constants.dart';
import 'package:hiddplace/src/components/navbar/drawer.dart';
import 'package:hiddplace/src/components/navbar/navbar.dart';
import 'package:hiddplace/src/components/rounded_input.dart';
import 'package:hiddplace/src/providers/profile.dart';
import 'package:hiddplace/src/services/firebaseAuthMethods.dart';
import 'package:image_picker_platform_interface/image_picker_platform_interface.dart';
import 'package:provider/provider.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfileScreen> {
  List<XFile>? _imageFile;

  //Controladores para enviar informacion
  final TextEditingController nameController = TextEditingController();
  final TextEditingController lastnameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    //Llamamos la informacion del perfil en la base de datos(Firestore) con Provider
    Provider.of<ProfileData>(context, listen: false).getProfile();
    nameController.text = Provider.of<ProfileData>(context, listen: false).name;
    lastnameController.text = Provider.of<ProfileData>(context, listen: false).lastname;
    phoneController.text = Provider.of<ProfileData>(context, listen: false).phone;

  }


  void editUser() async {
    context.read<FirebaseAuthMethods>().editProfile(
          name: nameController.text,
          lastname: lastnameController.text,
          phone: phoneController.text,
          imageUrl: _imageFile,
          context: context,
        );
  }

  //image piker
  void _setImageFileListFromFile(XFile? value) {
    _imageFile = (value == null ? null : <XFile>[value])!;
  }

  final ImagePickerPlatform _picker = ImagePickerPlatform.instance;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Consumer<ProfileData>(
      builder: (context, profile, child) {

        return Scaffold(
          appBar: const Navbar(title: "Editar Perfil", transparent: false, bgColor: kPrimaryColor),
          drawer: const NowDrawer(currentPage: "EditProfile"),
          body: Center(
              child: SingleChildScrollView(
                  child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                children: [
                  Container(
                    width: size.width * 0.3,
                    height: size.width * 0.3,
                    clipBehavior: Clip.antiAlias,
                    decoration: const BoxDecoration(shape: BoxShape.circle),
                    child: _imageFile == null
                        ? Image.network(
                            context.watch<ProfileData>().photoUrl,
                            fit: BoxFit.cover,
                          )
                        : Image.file(File(_imageFile![0].path)),
                  ),
                  Positioned(
                    width: 100,
                    height: 100,
                    bottom: 10.0,
                    right: 10.0,
                    child: InkWell(
                      onTap: () {
                        showModalBottomSheet(context: context, builder: ((builder) => bottomSheet()));
                      },
                      child: const Icon(
                        Icons.camera_alt,
                        color: kPrimaryColor,
                        size: 30.0,
                      ),
                    ),
                  )
                ],
              ),
              RoundedInput(
                  controller: nameController,
                  bgcolor: kRegisterBgColor,
                  color: kPrimaryColor,
                  hint: "Nombres",
                  icon: Icons.info_outline,
                  isEmail: false),
              RoundedInput(
                  controller: lastnameController,
                  bgcolor: kRegisterBgColor,
                  color: kPrimaryColor,
                  hint: "Apellidos",
                  icon: Icons.info_outline,
                  isEmail: false),
              RoundedInput(
                  controller: phoneController,
                  bgcolor: kRegisterBgColor,
                  color: kPrimaryColor,
                  hint: "Telefono",
                  icon: Icons.info_outline,
                  isEmail: false),
              InkWell(
                onTap: () {
                  editUser();
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
      },
    );
  }

  Widget bottomSheet() {
    return Container(
      height: 100.0,
      width: MediaQuery.of(context).size.width,
      decoration: const BoxDecoration(color: kSecundaryColor),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "Seleccione su foto de perfil",
            style: TextStyle(fontSize: 20.0, color: kPrimaryColor),
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                onTap: () {
                  takePhoto(ImageSource.camera);
                },
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(10.0, 10.0, 20.0, 0.0),
                  child: Row(
                    children: const [
                      Icon(
                        Icons.camera,
                        color: kPrimaryColor,
                      ),
                      Text(
                        " Camara",
                        style: TextStyle(color: kPrimaryColor),
                      )
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  takePhoto(ImageSource.gallery);
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

  void takePhoto(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.getImage(
        source: source,
      );
      setState(() {
        _setImageFileListFromFile(pickedFile);
      });
    } catch (e) {
      print(e.toString());
    }
  }
}
