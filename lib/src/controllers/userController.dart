import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../models/repository/firebaseAuthMethods.dart';

class UserController{
  static void signUpUser(BuildContext context,nameController,lastnameController,phoneController,imageFile,emailController,passwordController) async {
    context.read<FirebaseAuthMethods>().signUpWithEmail(
      name: nameController.text,
      lastname: lastnameController.text,
      phone: phoneController.text,
      imageUrl: imageFile,
      email: emailController.text,
      password: passwordController.text,
      context: context,
    );
  }

  static void loginUser(BuildContext context,emailController,passwordController) {
    context.read<FirebaseAuthMethods>().loginWithEmail(
      email: emailController.text,
      password: passwordController.text,
      context: context,
    );
  }

  static void editUser(BuildContext context, nameController,lastnameController,phoneController,List<XFile>? imageFile) async {
    context.read<FirebaseAuthMethods>().editProfile(
      name: nameController.text,
      lastname: lastnameController.text,
      phone: phoneController.text,
      imageUrl: imageFile,
      context: context,
    );
  }
}