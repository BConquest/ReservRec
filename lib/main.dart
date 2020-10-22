import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:reservrec/login_page.dart';
import 'package:reservrec/user_functions.dart';

UserClass Me = UserClass(
    userID: -1,
    name: "voidName",
    email: "void@void.void",
    password: "voidPw",
    picture: "default",
    school: "University of Alabama",
    verified: false);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ReservRec Login Page',
      theme: ThemeData (
        primarySwatch: Colors.red,
      ),
      home: Scaffold(
        body: LoginPage(),
      ),
    );
  }
}
