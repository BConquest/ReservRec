import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:reservrec/dashboard.dart';
import 'package:reservrec/user_functions.dart';
import 'package:reservrec/main.dart';

import 'file_functions.dart';

class NewPost extends StatefulWidget {
  @override
  _NewPost createState() => _NewPost();
}

class _NewPost extends State<NewPost> {
  final sportController = TextEditingController();
  final descriptionController = TextEditingController();
  final minController = TextEditingController();
  final maxController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    var message;

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

    final inputSport = Padding(
      padding: EdgeInsets.all(5),
      child: TextField(
        keyboardType: TextInputType.text,
        controller: sportController,
        decoration: InputDecoration(
            hintText: 'Sport',
            contentPadding: EdgeInsets.symmetric(horizontal: 25, vertical: 20),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(50.0)
            )
        ),
      ),
    );

    final inputDescription = Padding(
      padding: EdgeInsets.all(5),
      child: TextField(
        keyboardType: TextInputType.text,
        controller: descriptionController,
        decoration: InputDecoration(
            hintText: 'About',
            contentPadding: EdgeInsets.symmetric(horizontal: 25, vertical: 20),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(50.0)
            )
        ),
      ),
    );

    final minPlayers = Padding(
      padding: EdgeInsets.all(5),
      child: TextField(
        keyboardType: TextInputType.text,
        controller: minController,
        decoration: InputDecoration(
            hintText: 'Minimum Amount of Players',
            contentPadding: EdgeInsets.symmetric(horizontal: 25, vertical: 20),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(50.0)
            )
        ),
      ),
    );

    final maxPlayers = Padding(
      padding: EdgeInsets.all(5),
      child: TextField(
        keyboardType: TextInputType.text,
        controller: maxController,
        decoration: InputDecoration(
            hintText: 'Maximum Amount of Players',
            contentPadding: EdgeInsets.symmetric(horizontal: 25, vertical: 20),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(50.0)
            )
        ),
      ),
    );

    final buttonAddPost = Padding(
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
            if (await isInitialRead("/feed.csv") == false) {
              await writeInitialCSV("feed.csv");
            }
            message = 'Frank';
            //String message = await newUser(sportController.text, descriptionController.text, maxPlayers.text, minPlayers.text);
            if(message == "true") {
              print("newPost");
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Feed()));
            } else {
              print(message);
            }
          },
        ),
      ),
    );

    final buttonBack = Padding(
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
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Feed()));
          },
        ),
      ),
    );

    return SafeArea(
        child: Scaffold(
          body: Center(
            child: ListView(
              shrinkWrap: true,
              padding: EdgeInsets.symmetric(horizontal: 20),
              children: <Widget>[
                logo,
                inputSport,
                inputDescription,
                maxPlayers,
                minPlayers,
                buttonAddPost,
                buttonBack,
              ],
            ),

          ),
        )
    );
  }
}