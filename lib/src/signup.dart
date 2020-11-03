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
            child: Image.asset('assets/defaultuser.png'),
          )
      ),
    );

    final inputUsername = Padding(
      padding: EdgeInsets.all(5),

      child: TextField(
        keyboardType: TextInputType.name,
        controller: usernameController,
        onChanged: (String username) {
          if (!verifyUsername(username)) {
            print("Username invalid");
          } else {
            print("Username Valid");
          }
        },
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
            String uid = user.uid;
            UserC linkUser = new UserC(uid);

            linkUser.setUsername(usernameController.text);
            linkUser.setPassword(Sha256(passwordController.text));
            linkUser.setEmail(emailController.text);
            linkUser.setSchool("University of Alabama");
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


    /*DropdownButton(
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

        items: list
          );
        }).toList(),
      ); */

    final school = new DropdownButtonHideUnderline(
      child: new FutureBuilder<List<String>>(
        future: getSchools(),
        builder: (context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasData) {
            List<DropdownMenuItem> list;
            //listItemNames.clear();
            Map dropDownItemsMap = new Map();

            snapshot.data.forEach((branchItem) {
              //listItemNames.add(branchItem.itemName);
              int index = snapshot.data.indexOf(branchItem);
              dropDownItemsMap[index] = branchItem;

              list.add(new DropdownMenuItem(
                  child: snapshot.data[index],
                  value: index));
            });

            return DropdownButton(
                value: dropdownValue,
                icon: Icon(Icons.arrow_downward),
                iconSize: 24,
                elevation: 16,
                underline: Container(
                  height: 2,
                ),
              items: list
            );
          } else {
            return CircularProgressIndicator();
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