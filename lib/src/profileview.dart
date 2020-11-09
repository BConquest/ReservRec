import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:reservrec/src/user_functions.dart';

import 'user_functions.dart';
import 'user_functions.dart';

class ProfileView extends StatefulWidget {
  @override
  _ProfileViewPage createState() => _ProfileViewPage();
}

class _ProfileViewPage extends State<ProfileView> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPController = TextEditingController();
  final emailController = TextEditingController();
  List userPicture = ['https://i.imgur.com/DfGZewB.png',
    'https://i.imgur.com/TwDP9Af.png',
    'https://i.imgur.com/PkUksZr.png',
    'https://i.imgur.com/V8V8yB8.png'];
  var userPictureIndex = -1;

  @override
  Widget build(BuildContext context) {
    // TODO Change To be custom profile picture
    final logo = Padding(
      padding: EdgeInsets.all(20),
      child: Hero(
          tag: 'hero',
          child: SizedBox(
            height: 160,
            child: new FutureBuilder(
              future: getCurrentProfilePicture(),
                builder: (context, AsyncSnapshot snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  } else {
                    String photoURL = snapshot.data;
                    if (userPictureIndex == -1) {
                      return Center(child: Image.network(photoURL));
                    } else {
                      return Center(child: Image.network(userPicture[userPictureIndex]));
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
            setCurrentProfilePicture(userPicture[userPictureIndex]);
            setState(() {

            });
          },
        ),
      ),
    );

    final inputUsername = Padding(
      padding: EdgeInsets.all(5),
      child: new FutureBuilder(
          future: getCurrentUsername(),
          builder: (context, AsyncSnapshot snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            } else {
              String username = snapshot.data;
              return  Center(child: TextField(enabled: false,
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

    final inputEmail = Padding(
        padding: EdgeInsets.all(5),
        child: new FutureBuilder(
            future: getCurrentEmail(),
            builder: (context, AsyncSnapshot snapshot) {
              if (!snapshot.hasData) {
                return Center(child: CircularProgressIndicator());
              } else {
                String email = snapshot.data;
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

    return SafeArea(
        child: Scaffold(
          body: Center(

            child: ListView(
              shrinkWrap: true,
              padding: EdgeInsets.symmetric(horizontal: 20),
              children: <Widget>[
                logo,
                new ButtonBar(
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
                inputEmail
              ],
            ),

          ),
        )
    );
  }
}