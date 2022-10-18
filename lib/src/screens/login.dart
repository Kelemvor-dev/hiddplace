import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hiddplace/src/components/rounded_password_input.dart';
import 'package:provider/provider.dart';
import '../../constants.dart';
import '../components/rounded_input.dart';
import '../services/firebaseAuthMethods.dart';
import 'package:image_picker_platform_interface/image_picker_platform_interface.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> with SingleTickerProviderStateMixin {
  //Controladores para enviar informacion
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController lastnameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController imageUrlController = TextEditingController();

  void signUpUser() async {
    context.read<FirebaseAuthMethods>().signUpWithEmail(
          name: nameController.text,
          lastname: lastnameController.text,
          phone: phoneController.text,
          imageUrl: imageUrlController.text,
          email: emailController.text,
          password: passwordController.text,
          context: context,
        );
  }

  void loginUser() {
    context.read<FirebaseAuthMethods>().loginWithEmail(
          email: emailController.text,
          password: passwordController.text,
          context: context,
        );
  }

  bool isLogin = true;
  late Animation<double> containerSize;
  late AnimationController animationController;
  Duration animationDuration = const Duration(milliseconds: 270);

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);

    animationController =
        AnimationController(vsync: this, duration: animationDuration);
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  //image piker
  List<XFile>? _imageFile;
  void _setImageFileListFromFile(XFile? value) {
    _imageFile = value == null ? null : <XFile>[value];
  }
  final ImagePickerPlatform _picker = ImagePickerPlatform.instance;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    //viewInset se usa para determinar si el teclado se abre o no
    double viewInset = MediaQuery.of(context).viewInsets.bottom;
    double defaultLoginSize = size.height - (size.height * 0.2);
    double defaultRegisterSize = size.height - (size.height * 0.1);

    containerSize = Tween<double>(
            begin: size.height * 0.1, end: defaultRegisterSize)
        .animate(
            CurvedAnimation(parent: animationController, curve: Curves.linear));

    return Scaffold(
      body: Stack(
        children: [
          Positioned(
              top: -50,
              right: 0,
              child: Container(
                width: size.width,
                height: 500,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: kSecundaryColor),
              )),
          // Formulario de Iniciar sesión
          AnimatedOpacity(
            opacity: isLogin ? 1.0 : 0.0,
            duration: animationDuration * 4,
            child: Align(
              alignment: Alignment.center,
              child: SingleChildScrollView(
                child: SizedBox(
                  width: size.width,
                  height: defaultLoginSize,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Bienvenido a Hiddplace',
                        style: GoogleFonts.pacifico(
                            textStyle: Theme.of(context).textTheme.headline4,
                            fontSize: 24,
                            fontWeight: FontWeight.w400,
                            fontStyle: FontStyle.italic,
                            color: kPrimaryColor),
                      ),
                      const SizedBox(height: 40),
                      Image.asset(
                        'assets/logo.png',
                        width: 150,
                      ),
                      const SizedBox(height: 150),
                      RoundedInput(
                          controller: emailController,
                          bgcolor: kPrimaryColor,
                          color: kPrimaryColor,
                          hint: "E-mail",
                          icon: Icons.mail,
                          isEmail: true),
                      RoundedPasswordInput(
                          controller: passwordController,
                          hint: "Contraseña",
                          bgColor: kPrimaryColor),
                      const SizedBox(height: 20),
                      InkWell(
                        onTap: () {
                          loginUser();
                        },
                        borderRadius: BorderRadius.circular(30),
                        child: Container(
                          width: size.width * 0.4,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: kPrimaryColor),
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          alignment: Alignment.center,
                          child: const Text(
                            "Iniciar sesión",
                            style: TextStyle(
                              color: kSecundaryColor,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          AnimatedBuilder(
            animation: animationController,
            builder: (context, child) {
              if (viewInset == 0 && isLogin) {
                return buildRegisterContainer();
              } else if (!isLogin) {
                return buildRegisterContainer();
              }

              // retorna un container vacio para ocultar el widget
              return Container();
            },
          ),

          // Formulario de registros de usuarios
          AnimatedOpacity(
            opacity: isLogin ? 0.0 : 1.0,
            duration: animationDuration * 5,
            child: Visibility(
              visible: !isLogin,
              child: Align(
                alignment: Alignment.center,
                child: SingleChildScrollView(
                  child: SizedBox(
                    width: size.width,
                    height: defaultLoginSize,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 30),
                        Text(
                          'Registro',
                          style: GoogleFonts.pacifico(
                              textStyle: Theme.of(context).textTheme.headline4,
                              fontSize: 24,
                              fontWeight: FontWeight.w400,
                              fontStyle: FontStyle.italic,
                              color: kPrimaryColor),
                        ),
                        Stack(
                          children: [
                            Container(
                              width: size.width * 0.3,
                              height: size.width * 0.3,
                              clipBehavior: Clip.antiAlias,
                              decoration:
                                  const BoxDecoration(shape: BoxShape.circle),
                              child: _imageFile == null
                                  ? Image.asset(
                                      'assets/images/profile.jpeg',
                                      fit: BoxFit.cover,
                                    )
                                  : Image.file(File(_imageFile![0].path)),
                            ),
                            Positioned(
                              width: 150,
                              height: 150,
                              bottom: -45.0,
                              right: -45.0,
                              child: InkWell(
                                onTap: () {
                                  showModalBottomSheet(
                                      context: context,
                                      builder: ((builder) => bottomSheet()));
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
                            bgcolor: kPrimaryColor,
                            color: kPrimaryColor,
                            hint: "Nombres",
                            icon: Icons.info_outline,
                            isEmail: false),
                        RoundedInput(
                            controller: lastnameController,
                            bgcolor: kPrimaryColor,
                            color: kPrimaryColor,
                            hint: "Apellidos",
                            icon: Icons.info_outline,
                            isEmail: false),
                        RoundedInput(
                            controller: phoneController,
                            bgcolor: kPrimaryColor,
                            color: kPrimaryColor,
                            hint: "Telefono",
                            icon: Icons.info_outline,
                            isEmail: false),
                        // RoundedInput(
                        //     controller: imageUrlController,
                        //     bgcolor: kPrimaryColor,
                        //     color: kPrimaryColor,
                        //     hint: "Imagen",
                        //     icon: Icons.info_outline,
                        //     isEmail: false),
                        RoundedInput(
                            controller: emailController,
                            bgcolor: kPrimaryColor,
                            color: kPrimaryColor,
                            hint: "E-mail",
                            icon: Icons.mail,
                            isEmail: true),
                        RoundedPasswordInput(
                            controller: passwordController,
                            hint: "Contraseña",
                            bgColor: kPrimaryColor),
                        InkWell(
                          onTap: () {
                            signUpUser();
                          },
                          borderRadius: BorderRadius.circular(30),
                          child: Container(
                            width: size.width * 0.4,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                color: kPrimaryColor),
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            alignment: Alignment.center,
                            child: const Text(
                              "Regístrate",
                              style: TextStyle(
                                color: kSecundaryColor,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          // Cerrar formulario de registros de usuarios
          AnimatedOpacity(
            opacity: isLogin ? 0.0 : 1.0,
            duration: animationDuration,
            child: Align(
              alignment: Alignment.topCenter,
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: kPrimaryColor,
                  border: Border.all(
                    color: kRegisterBgColor,
                    width: 4,
                  ),
                ),
                width: size.width,
                height: size.height * 0.1,
                margin: const EdgeInsets.symmetric(vertical: 50),
                alignment: Alignment.center,
                child: IconButton(
                  icon: const Icon(
                    Icons.close,
                    color: kSecundaryColor,
                  ),
                  onPressed: isLogin
                      ? null
                      : () {
                          animationController.reverse();
                          setState(() {
                            isLogin = !isLogin;
                          });
                        },
                  color: kPrimaryColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildRegisterContainer() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        width: double.infinity,
        height: containerSize.value,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(40),
            topRight: Radius.circular(40),
          ),
          color: kRegisterBgColor,
        ),
        alignment: Alignment.center,
        child: GestureDetector(
          onTap: !isLogin
              ? null
              : () {
                  animationController.forward();
                  setState(() {
                    isLogin = !isLogin;
                  });
                },
          child: isLogin
              ? const Text(
                  "¿Aun no tienes cuenta? Regístrate",
                  style: TextStyle(
                    color: kPrimaryColor,
                    fontSize: 18,
                  ),
                )
              : null,
        ),
      ),
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
