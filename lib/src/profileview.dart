import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:reservrec/src/user_functions.dart';

import 'user_functions.dart';

final reference = FirebaseFirestore.instance;


class ProfileView extends StatefulWidget {
  final String uid;

  const ProfileView ({Key key, this.uid }): super(key: key);

  @override
  _ProfileViewPage createState() => _ProfileViewPage();
}

class _ProfileViewPage extends State<ProfileView> {
  final usernameController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  List userPicture = ['https://i.imgur.com/DfGZewB.png',
    'https://i.imgur.com/TwDP9Af.png',
    'https://i.imgur.com/PkUksZr.png',
    'https://i.imgur.com/V8V8yB8.png'];
  var userPictureIndex = -1;
  String dropdownValue = "Punctuality";
  bool _isButtonDisabled;

  @override
  void initState() {
    // TODO: Check if following or not.
    _isButtonDisabled = false;
  }

  void follow() async {
    await reference.collection('users').doc(await getDocumentID(_auth.currentUser.uid)).collection('following').doc(widget.uid).set({});
    _isButtonDisabled = true;
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    final logo = Padding(
      padding: EdgeInsets.all(20),
      child: Hero(
          tag: 'hero',
          child: SizedBox(
            height: 160,
            child: FutureBuilder(
              future: getCurrentProfilePicture(widget.uid),
                builder: (context, AsyncSnapshot snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  } else {
                    String photoURL = snapshot.data.toString();
                    if (userPictureIndex == -1) {
                      return Center(child: Image.network(photoURL));
                    } else {
                      return Center(child: Image.network(userPicture[userPictureIndex].toString()));
                    }
                  }
                }
            )
          )
      ),
    );

    final buttonPrev = Padding(
      padding: EdgeInsets.all(5),
      child: ButtonTheme(
        height: 56,
        child: RaisedButton(
          child: Text('Previous', style: TextStyle(color: Colors.white, fontSize: 20)),
          color: Colors.red,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50)
          ),
          onPressed: () async {
            if (userPictureIndex <= 0) {
              userPictureIndex = userPicture.length - 1;
            } else {
              userPictureIndex -= 1;
            }
            setState(() {

            });
          },
        ),
      ),
    );

    final buttonNext = Padding(
      padding: EdgeInsets.all(5),
      child: ButtonTheme(
        height: 56,
        child: RaisedButton(
          child: Text('Next', style: TextStyle(color: Colors.white, fontSize: 20)),
          color: Colors.red,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50)
          ),
          onPressed: () async {
            if (userPictureIndex >= userPicture.length - 1) {
              userPictureIndex = 0;
            } else {
              userPictureIndex += 1;
            }
            setState(() {
            });
          },
        ),
      ),
    );

    final buttonChange = Padding(
      padding: EdgeInsets.all(5),
      child: ButtonTheme(
        height: 56,
        child: RaisedButton(
          child: Text('Change Picture', style: TextStyle(color: Colors.white, fontSize: 20)),
          color: Colors.red,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50)
          ),
          onPressed: () async {
            if (userPictureIndex == -1) { return; }
            await setCurrentProfilePicture(userPicture[userPictureIndex].toString());
            setState(() { });
          },
        ),
      ),
    );

    final inputUsername = Padding(
      padding: EdgeInsets.all(5),
      child: FutureBuilder(
          future: getCurrentUsername(widget.uid),
          builder: (context, AsyncSnapshot snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            } else {
              String username = snapshot.data.toString();
              return  Center(child: TextField(
                    enabled: true,
                    keyboardType: TextInputType.name,
                    controller: usernameController,
                    decoration: InputDecoration(
                      hintText: username,
                      contentPadding: EdgeInsets.symmetric(horizontal: 25, vertical: 20),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50.0)
                      )
                    ),
                  ),
              );
            }
          }
      )
    );

    final buttonUpdateEmail = Padding(
      padding: EdgeInsets.all(5),
      child: ButtonTheme(
        height: 56,
        child: RaisedButton(
          child: Text('Change Username', style: TextStyle(color: Colors.white, fontSize: 20)),
          color: Colors.red,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50)
          ),
          onPressed: () async {
            if(verifyUsername(usernameController.text)) {
              await setCurrentUsername(usernameController.text);
            } else {
              print("(II) profileview->156: username not valid");
            }
          },
        ),
      ),
    );

    final inputEmail = Padding(
        padding: EdgeInsets.all(5),
        child: FutureBuilder(
            future: getCurrentEmail(widget.uid),
            builder: (context, AsyncSnapshot snapshot) {
              if (!snapshot.hasData) {
                return Center(child: CircularProgressIndicator());
              } else {
                String email = snapshot.data.toString();
                return  Center(child: TextField(enabled: false,
                  decoration: InputDecoration(
                      hintText: email,
                      contentPadding: EdgeInsets.symmetric(horizontal: 25, vertical: 20),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50.0)
                      )
                  ),
                ),
                );
              }
            }
        )

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
           Navigator.pop(context);
          },
        ),
      ),
    );

    final buttonReport = Padding(
      padding: EdgeInsets.all(5),
      child: ButtonTheme(
        height: 56,
        child: RaisedButton(
          child: Text('Report', style: TextStyle(color: Colors.white, fontSize: 20)),
          color: Colors.red,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50)
          ),
          onPressed: () async {
            if (_auth.currentUser.uid != widget.uid) {
              reportPlayer(widget.uid.toString(), dropdownValue);
            }
          },
        ),
      ),
    );

    final report = DropdownButton<String>(
      value: dropdownValue,
      icon: Icon(Icons.arrow_downward),
      iconSize: 24,
      elevation: 16,
      style: TextStyle(color: Colors.deepPurple),
      underline: Container(
        height: 2,
        color: Colors.deepPurpleAccent,
      ),
      onChanged: (String newValue) {
        setState(() {
          dropdownValue = newValue;
        });
      },
      items: <String>['Punctuality', 'Sportsmanship']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );

    final followButton = Padding(
      padding: EdgeInsets.all(5),
      child: ButtonTheme(
        height: 56,
        child: RaisedButton(
          child: Text(_isButtonDisabled ? "Following" : "Follow", style: TextStyle(color: Colors.white, fontSize: 20)),
          color: Colors.red,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50)
          ),
          onPressed: _isButtonDisabled ? null : follow,
        ),
      ),
    );

    if (_auth.currentUser.uid != widget.uid) {
      return SafeArea(
          child: Scaffold(
            body: Center(
              child: ListView(
                shrinkWrap: true,
                padding: EdgeInsets.symmetric(horizontal: 20),
                children: <Widget>[
                  logo,
                  inputUsername,
                  inputEmail,
                  followButton,
                  report,
                  buttonReport,
                  buttonBack,
                ],
              ),

            ),
          )
      );
    } else {
      return SafeArea(
          child: Scaffold(
            body: Center(

              child: ListView(
                shrinkWrap: true,
                padding: EdgeInsets.symmetric(horizontal: 20),
                children: <Widget>[
                  logo,
                  ButtonBar(
                    alignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    buttonMinWidth: 1000,
                    children: <Widget>[
                      buttonPrev,
                      buttonNext,
                    ],
                  ),
                  buttonChange,
                  inputUsername,
                  buttonUpdateEmail,
                  inputEmail,
                  buttonBack,
                ],
              ),

            ),
          )
      );
    }
  }
}