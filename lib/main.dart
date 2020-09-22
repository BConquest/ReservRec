import 'package:flutter/material.dart';
import 'package:reservrec/dashboard.dart';
import 'package:reservrec/login_page.dart';

void main() {
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
      home: LoginPage(),
    );
  }
}
