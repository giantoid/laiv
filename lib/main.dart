import 'package:laiv/controllers/auth_controller.dart';
import 'package:laiv/screens/home_screen.dart';
import 'package:laiv/screens/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'screens/widgets/loading.dart';
import 'screens/widgets/someting_wrong.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Initialize FlutterFire:
      future: _initialization,
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          return SomethingWentWrong();
        }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          AuthController _controller = AuthController();
          return MaterialApp(
            title: "Firebase",
            debugShowCheckedModeBanner: false,
            initialRoute: '/',
            theme: ThemeData(brightness: Brightness.dark),
            home: FutureBuilder(
              future: _controller.getCurrentUser(),
              builder: (context, AsyncSnapshot<User> snapshot) {
                if (snapshot.hasData) {
                  return HomeScreen();
                } else {
                  return LoginScreen();
                }
              },
            ),
          );
        }

        // Otherwise, show something whilst waiting for initialization to complete
        return Loading();
      },
    );
  }
}
