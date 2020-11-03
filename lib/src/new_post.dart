import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:reservrec/src/dashboard.dart';
import 'package:reservrec/src/feed_functions.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

class CustomPicker extends CommonPickerModel {
  String digits(int value, int length) {
    return '$value'.padLeft(length, "0");
  }

  CustomPicker({DateTime currentTime, LocaleType locale}) : super(locale: locale) {
    this.currentTime = currentTime ?? DateTime.now();
    this.setLeftIndex(this.currentTime.hour);
    this.setMiddleIndex(this.currentTime.minute);
    this.setRightIndex(this.currentTime.second);
  }

  @override
  String leftStringAtIndex(int index) {
    if (index >= 0 && index < 24) {
      return this.digits(index, 2);
    } else {
      return null;
    }
  }

  @override
  String middleStringAtIndex(int index) {
    if (index >= 0 && index < 60) {
      return this.digits(index, 2);
    } else {
      return null;
    }
  }

  @override
  String rightStringAtIndex(int index) {
    if (index >= 0 && index < 60) {
      return this.digits(index, 2);
    } else {
      return null;
    }
  }

  @override
  String leftDivider() {
    return "|";
  }

  @override
  String rightDivider() {
    return "|";
  }

  @override
  List<int> layoutProportions() {
    return [1, 2, 1];
  }

  @override
  DateTime finalTime() {
    return currentTime.isUtc
        ? DateTime.utc(currentTime.year, currentTime.month, currentTime.day,
        this.currentLeftIndex(), this.currentMiddleIndex(), this.currentRightIndex())
        : DateTime(currentTime.year, currentTime.month, currentTime.day, this.currentLeftIndex(),
        this.currentMiddleIndex(), this.currentRightIndex());
  }
}

class NewPost extends StatefulWidget {
  @override
  _NewPost createState() => _NewPost();
}

class _NewPost extends State<NewPost> {
  final sportController = TextEditingController();
  final descriptionController = TextEditingController();
  final locationController = TextEditingController();
  final minController = TextEditingController();
  final maxController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    var message;
    DateTime gameTimeSet;
    DateTime gameTimeTemp;
    DateTime gameDayTemp;

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

    final gameDay = Padding(
      padding: EdgeInsets.all(5),
      child: ButtonTheme(
        height: 56,
        child: RaisedButton(
          color: Colors.red,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50)
          ),
          onPressed: () {
            DatePicker.showDatePicker(context, showTitleActions: true, onChanged: (date) {
              print('change $date in time zone ' + date.timeZoneOffset.inHours.toString());
            }, onConfirm: (date) {
              print('confirm $date');
              gameDayTemp = date;
            }, currentTime: DateTime.now());
          },
          child: Text(
              'Show Time Picker',
              style: TextStyle(color: Colors.white, fontSize: 20)),
        ),
      ),
    );

    final gameTime = Padding(
      padding: EdgeInsets.all(5),
      child: ButtonTheme(
        height: 56,
        child: RaisedButton(
          color: Colors.red,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50)
          ),
          onPressed: () {
            DatePicker.showTime12hPicker(context, showTitleActions: true, onChanged: (date) {
              print('change $date in time zone ' + date.timeZoneOffset.inHours.toString());
            }, onConfirm: (date) {
              print('confirm $date');
              gameTimeTemp = date;
            }, currentTime: DateTime.now());
          },
          child: Text(
              'Show Time Picker',
              style: TextStyle(color: Colors.white, fontSize: 20)),
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
            gameTimeSet = new DateTime(gameDayTemp.year, gameDayTemp.month, gameDayTemp.day, gameTimeTemp.hour, gameTimeTemp.minute);
            String message = await newPost(sportController.text, descriptionController.text, locationController.text, gameTimeSet, int.parse(maxController.text), int.parse(minController.text));
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
                maxPlayers,
                minPlayers,
                gameTime,
                gameDay,
                buttonAddPost,
                buttonBack,
              ],
            ),

          ),
        )
    );
  }
}