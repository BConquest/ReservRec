import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:reservrec/dashboard.dart';
import 'package:reservrec/file_functions.dart';
import 'package:reservrec/signup.dart';
import 'package:reservrec/user_functions.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>  {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

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

    final snackBar = SnackBar(
        content: Text('Invalid Username or Password'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            print("YO WHATS POPPING NERDS");
          },
        )
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
            var isInit = (await isInitialRead("reservrec.csv") == false);
            if (await loginUser(
                usernameController.text, passwordController.text,
                isInit)) {
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (context) => Feed()));
            } else {
              print("Username or Password not Accepted");
              //Scaffold.of(context).showSnackBar(snackBar);
            }
          },
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
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => Signup()));
          },
        ),
      ),
    );

    final buttonForgotPassword = FlatButton(
        child: Text('Forgot Password',
          style: TextStyle(color: Colors.grey, fontSize: 16),),
        onPressed: null
    );

  return SafeArea(
        child: Scaffold(
          body: Center(
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

          ),
        )
    );
  }
}