import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:reservrec/src/dashboard.dart';
import 'package:reservrec/src/signup.dart';
import 'package:reservrec/src/user_functions.dart';

import 'package:firebase_auth/firebase_auth.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>  {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  _displaySnackBar(BuildContext context, s) {
    final snackBar = SnackBar(content: Text(s));
    Scaffold.of(context).showSnackBar(snackBar);
  }

  _clearInputs() {
    usernameController.clear();
    passwordController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final logo = Padding(
      padding: EdgeInsets.all(20),
      child: Hero(
          tag: 'hero',
          child: SizedBox(
            height: 160,
            child: Image.asset('assets/logo.png'),
          )
      ),
    );

    final inputEmail = Padding(
      padding: EdgeInsets.only(bottom: 10),
      child: TextField(
        keyboardType: TextInputType.emailAddress,
        controller: usernameController,
        decoration: InputDecoration(
            hintText: 'Email',
            contentPadding: EdgeInsets.symmetric(horizontal: 25, vertical: 20),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(50.0)
            )
        ),
      ),
    );

    final inputPassword = Padding(
      padding: EdgeInsets.only(bottom: 20),
      child: TextField(
        keyboardType: TextInputType.text,
        controller: passwordController,
        obscureText: true,
        decoration: InputDecoration(
            hintText: 'Password',
            contentPadding: EdgeInsets.symmetric(horizontal: 25, vertical: 20),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(50.0)
            )
        ),
      ),
    );

    final buttonLogin = Padding(
      padding: EdgeInsets.only(bottom: 5),
      child: ButtonTheme(
        height: 56,
        child: RaisedButton(
          child: Text(
              'Login', style: TextStyle(color: Colors.white, fontSize: 20)),
          color: Colors.red,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50)
          ),
          onPressed: () async {
            final User user = await signInWithEmailAndPassword(usernameController.text, passwordController.text);
            if (user == null) {
              _displaySnackBar(context, "Username or Password Invalid");
              return;
            } else {
              if (!user.emailVerified) {
                await user.sendEmailVerification();
                print("login_page.dart->buttonLogin email not verified");
                _displaySnackBar(context, "Your email has not been verified.");
                return;
              }
              _clearInputs();
              Navigator.push(context, MaterialPageRoute(builder: (context) => Feed()));
            }
          }
        ),
      ),
    );

    final buttonSignUp = Padding(
      padding: EdgeInsets.only(bottom: 5),
      child: ButtonTheme(
        height: 56,
        child: RaisedButton(
          child: Text(
              'Sign-Up', style: TextStyle(color: Colors.white, fontSize: 20)),
          color: Colors.red,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50)
          ),
          onPressed: () async {
            _clearInputs();
            Navigator.push(context, MaterialPageRoute(builder: (context) => Signup()));
          },
        ),
      ),
    );

    final buttonForgotPassword = FlatButton(
        child: Text('Forgot Password',
          style: TextStyle(color: Colors.grey, fontSize: 16),),
        onPressed: () async {
          _clearInputs();
          //final FirebaseAuth _auth = FirebaseAuth.instance;
          _displaySnackBar(context, "Invalid Email or Password");
          //await _auth.sendPasswordResetEmail(email: usernameController.text);
        }
    );

  return SafeArea(
        child: Scaffold(
          body: Builder(
            builder: (context) =>
              Center(
                child: ListView(
                  shrinkWrap: true,
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  children: <Widget>[
                    logo,
                    inputEmail,
                    inputPassword,
                    new ButtonBar(
                        alignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        buttonMinWidth: 1000,
                        children: <Widget> [
                          buttonSignUp,
                          buttonLogin,
                        ]
                    ),
                    buttonForgotPassword,
                  ],
                ),
              )
          ),
        )
    );
  }
}