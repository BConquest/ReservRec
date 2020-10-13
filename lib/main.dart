import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:reservrec/login_page.dart';

import 'package:reservrec/user_functions.dart';

User Me = User(
    userID: -1,
    name: "voidName",
    email: "void@void.void",
    password: "voidPw",
    picture: "default",
    school: "University of Alabama",
    verified: false);

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ReservRec Login Page',
      theme: ThemeData (
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        body: LoginPage(),
      ),
    );
  }
}
