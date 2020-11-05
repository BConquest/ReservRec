import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:reservrec/models/user.dart';
import 'package:reservrec/src/login_page.dart';
import 'package:reservrec/src/user_functions.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:reservrec/repository/dataRepository.dart';
import 'package:reservrec/src/hashing.dart';

//import 'package:image_picker/image_picker.dart';

final firestoreInstance = FirebaseFirestore.instance;

class Signup extends StatefulWidget {
  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPController = TextEditingController();
  final emailController = TextEditingController();
  final DataRepository repository = DataRepository();

  var userPicture = 'https://i.imgur.com/DfGZewB.png';

  _clearInputs() {
    usernameController.clear();
    passwordController.clear();
    confirmPController.clear();
    emailController.clear();
  }

  _displaySnackBar(BuildContext context, s) {
    final snackBar = SnackBar(content: Text(s));
    print(snackBar);
    //Scaffold.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    // TODO Change To be custom profile picture
    final logo = Padding(
      padding: EdgeInsets.all(20),
      child: Hero(
          tag: 'hero',
          child: SizedBox(
            height: 160,
            child: Image.network(
              userPicture
            )
          )
      ),
    );

    final inputUsername = Padding(
      padding: EdgeInsets.all(5),

      child: TextField(
        keyboardType: TextInputType.name,
        controller: usernameController,
        decoration: InputDecoration(
            hintText: 'Username',
            contentPadding: EdgeInsets.symmetric(horizontal: 25, vertical: 20),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(50.0)
            ),
        ),
      ),
    );

    final inputPassword = Padding(
      padding: EdgeInsets.all(5),
      child: TextField(
        keyboardType: TextInputType.text,
        obscureText: true,
        controller: passwordController,
        decoration: InputDecoration(
            hintText: 'Password',
            contentPadding: EdgeInsets.symmetric(horizontal: 25, vertical: 20),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(50.0)
            )
        ),
      ),
    );

    final inputConfirmPassword = Padding(
      padding: EdgeInsets.all(5),
      child: TextField(
        keyboardType: TextInputType.text,
        obscureText: true,
        controller: confirmPController,
        decoration: InputDecoration(
            hintText: 'Confirm Password',
            contentPadding: EdgeInsets.symmetric(horizontal: 25, vertical: 20),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(50.0)
            )
        ),
      ),
    );

    final inputEmail = Padding(
      padding: EdgeInsets.all(5),
      child: TextField(
        keyboardType: TextInputType.emailAddress,
        controller: emailController,
        decoration: InputDecoration(
            hintText: 'Email',
            contentPadding: EdgeInsets.symmetric(horizontal: 25, vertical: 20),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(50.0)
            )
        ),
      ),
    );

    final buttonSignUp = Padding(
      padding: EdgeInsets.all(5),
      child: ButtonTheme(
        height: 56,
        child: RaisedButton(
          child: Text('Sign-Up', style: TextStyle(color: Colors.white, fontSize: 20)),
          color: Colors.red,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50)
          ),
          onPressed: () async {
            final User user = await signUpWithEmailAndPassword(usernameController.text, passwordController.text, confirmPController.text, emailController.text);

            if (user == null) {
              //_displaySnackBar(context, createUserMessage);
              print("signup.dart->final buttonSignUp $createUserMessage");
              return;
            }

            user.sendEmailVerification();
            user.updateProfile();
            String uid = user.uid;
            UserC linkUser = new UserC(uid);

            linkUser.setUsername(usernameController.text);
            linkUser.setPassword(Sha256(passwordController.text));
            linkUser.setEmail(emailController.text);
            linkUser.setSchool(getDropDownValue());
            linkUser.setVerified(false);

            repository.addUserC(linkUser);

            _clearInputs();
            Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
          },
        ),
      ),
    );

    final buttonBack = Padding(
      padding: EdgeInsets.all(5),
      child: ButtonTheme(
        height: 56,
        child: RaisedButton(
          child: Text('Back', style: TextStyle(color: Colors.white, fontSize: 20)),
          color: Colors.red,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50)
          ),
          onPressed: () async {
            _clearInputs();
            _displaySnackBar(context, "hey");
            Navigator.pop(context);
          },
        ),
      ),
    );

    List<String> list = new List();
    Map dropDownItemsMap = new Map();

    final school = new DropdownButtonHideUnderline(
      child: new FutureBuilder(
        future: getSchools(),
        builder: (context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          } else {
            snapshot.data.forEach((branchItem) {
              //listItemNames.add(branchItem.itemName);
              int index = snapshot.data.indexOf(branchItem);
              dropDownItemsMap[index] = branchItem;

              list.add(snapshot.data[index].toString());
            });

            return DropdownButton(
                value: dropdownValue,
                icon: Icon(Icons.arrow_downward),
                iconSize: 24,
                elevation: 16,
                underline: Container(
                  height: 2,
                ),
              onChanged: (String newValue) {
                  setState(() {
                    dropdownValue = newValue;
                  });
              },
              items: list.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value)
                  );
                }).toList(),
            );
          }
        },
      ),
    );

    final key = new GlobalKey<ScaffoldState>();
    return new Scaffold(
      key: key,
          body: new Builder(
              builder: (BuildContext cont) {
                 return Center(
                  child: ListView(
                    shrinkWrap: true,
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    children: <Widget>[
                      logo,
                      inputUsername,
                      inputPassword,
                      inputConfirmPassword,
                      inputEmail,
                      school,
                      new ButtonBar(
                          alignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          buttonMinWidth: 1000,
                          children: <Widget>[
                            buttonSignUp,
                            buttonBack,
                          ]
                      ),
                    ],
                  ),
                );
              }
          ),
    );
  }
}