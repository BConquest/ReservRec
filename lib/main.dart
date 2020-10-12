import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:reservrec/login_page.dart';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

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
      home: LoginPage(),
    );
  }
}
