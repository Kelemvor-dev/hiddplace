import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hiddplace/constants.dart';
import 'package:hiddplace/src/controllers/userController.dart';
import 'package:hiddplace/src/views/components/navbar/drawer.dart';
import 'package:hiddplace/src/views/components/navbar/navbar.dart';
import 'package:hiddplace/src/views/components/rounded_input.dart';
import 'package:hiddplace/src/models/providers/profile.dart';
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
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _lastnameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    //Llamamos la informacion del perfil en la base de datos(Firestore) con Provider
    Provider.of<ProfileData>(context, listen: false).getProfile();
    _nameController.text = Provider.of<ProfileData>(context, listen: false).name;
    _lastnameController.text = Provider.of<ProfileData>(context, listen: false).lastname;
    _phoneController.text = Provider.of<ProfileData>(context, listen: false).phone;

  }

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
                  controller: _nameController,
                  bgcolor: kRegisterBgColor,
                  color: kPrimaryColor,
                  hint: "Nombres",
                  icon: Icons.info_outline,
                  isEmail: false),
              RoundedInput(
                  controller: _lastnameController,
                  bgcolor: kRegisterBgColor,
                  color: kPrimaryColor,
                  hint: "Apellidos",
                  icon: Icons.info_outline,
                  isEmail: false),
              RoundedInput(
                  controller: _phoneController,
                  bgcolor: kRegisterBgColor,
                  color: kPrimaryColor,
                  hint: "Telefono",
                  icon: Icons.info_outline,
                  isEmail: false),
              InkWell(
                onTap: () {
                  UserController.editUser(context, _nameController, _lastnameController, _phoneController, _imageFile);
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
  //image piker
  void _setImageFileListFromFile(XFile? value) {
    _imageFile = (value == null ? null : <XFile>[value])!;
  }

  final ImagePickerPlatform _picker = ImagePickerPlatform.instance;

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
