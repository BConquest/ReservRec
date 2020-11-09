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
                    return  Center(child: Image.network(
                      photoURL
                    ));
                  }
                }
            )
          )
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
                inputUsername,
                inputEmail
              ],
            ),

          ),
        )
    );
  }
}