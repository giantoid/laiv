import 'package:laiv/controllers/auth_controller.dart';
import 'package:laiv/screens/home_screen.dart';
import 'package:laiv/utils/app_colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  AuthController _authController = AuthController();

  bool isLoginPressed = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.blackColor,
      body: Stack(children: [
        Center(
          child: ElevatedButton(
            child: Text("Login"),
            onPressed: () => performLogin(),
          ),
        ),
        isLoginPressed
            ? Center(child: CircularProgressIndicator())
            : Container()
      ]),
    );
  }

  void performLogin() {
    setState(() {
      isLoginPressed = true;
    });
    _authController.signIn().then((UserCredential user) {
      if (user != null) {
        authenticateUser(user);
      } else {
        print("There was an error");
      }
    });
  }

  void authenticateUser(UserCredential user) {
    _authController.authenticateUser(user).then((isNewUser) {
      setState(() {
        isLoginPressed = false;
      });
      if (isNewUser) {
        _authController.addDataToDb(user).then((value) {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) {
            return HomeScreen();
          }));
        });
      } else {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) {
          return HomeScreen();
        }));
      }
    });
  }
}
