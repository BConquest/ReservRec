import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:reservrec/src/dashboard.dart';
import 'package:reservrec/src/feed_functions.dart';
import 'package:reservrec/src/user_functions.dart';
import 'package:reservrec/src/main.dart';

import 'file_functions.dart';

class NewPost extends StatefulWidget {
  @override
  _NewPost createState() => _NewPost();
}

class _NewPost extends State<NewPost> {
  final sportController = TextEditingController();
  final descriptionController = TextEditingController();
  final locationController = TextEditingController();
  final timeController = TextEditingController();
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

    final location = Padding(
      padding: EdgeInsets.all(5),
      child: TextField(
        keyboardType: TextInputType.text,
        controller: locationController,
        decoration: InputDecoration(
            hintText: 'Location of Sport Activity',
            contentPadding: EdgeInsets.symmetric(horizontal: 25, vertical: 20),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(50.0)
            )
        ),
      ),
    );

    final gameTime = Padding(
      padding: EdgeInsets.all(5),
      child: TextField(
        keyboardType: TextInputType.datetime,
        controller: timeController,
        decoration: InputDecoration(
            hintText: 'Time of Sport Activity',
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
          child: Text('Create Post', style: TextStyle(color: Colors.white, fontSize: 20)),
          color: Colors.red,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50)
          ),
          onPressed: () async {
            String message = await newPost(sportController.text, descriptionController.text, locationController.text, timeController.text, int.parse(maxController.text), int.parse(minController.text));
            if(message == "true") {
              print("newPost");
              Navigator.push(context, MaterialPageRoute(builder: (context) => Feed()));
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
                location,
                gameTime,
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