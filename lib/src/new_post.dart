import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:reservrec/src/dashboard.dart';
import 'package:reservrec/src/feed_functions.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:reservrec/src/user_functions.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

Future<String> getTimeDispString(DateTime time) async{
  print('Func: ${time.toString()}');
  assert(time.year >= 0);
  if (time.hour == 12) {
    return "${time.month}/${time.day}/${time.year} - ${(time.hour).toString()
        .padLeft(2, ('0'))}:${time.minute.toString().padLeft(2, ('0'))} PM";
  } else if(time.hour == 0) {
    return "${time.month}/${time.day}/${time.year} - ${(time.hour % 12).toString()
        .padLeft(2, ('0'))}:${time.minute.toString().padLeft(2, ('0'))} AM";
  } else if(time.hour > 12) {
    return "${time.month}/${time.day}/${time.year} - ${(time.hour % 12).toString()
        .padLeft(2, ('0'))}:${time.minute.toString().padLeft(2, ('0'))} PM";
  } else if (time.hour < 12){
    return "${time.month}/${time.day}/${time.year} - ${time.hour.toString()
        .padLeft(2, ('0'))}:${time.minute.toString().padLeft(2, ('0'))} AM";
  }
  return "ERROR: Bad Time";
}

confirmationPopup1(BuildContext dialogContext) async{
  var alertStyle = AlertStyle(
    animationType: AnimationType.grow,
    overlayColor: Colors.black87,
    isCloseButton: true,
    isOverlayTapDismiss: true,
    titleStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
    descStyle: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
    animationDuration: Duration(milliseconds: 400),
  );

  await Alert(
      context: dialogContext,
      style: alertStyle,
      title: "Error",
      desc: "Please Select a Value",
      buttons: [
        DialogButton(
          child: Text(
            "OK",
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          onPressed: () {
            Navigator.pop(dialogContext);
          },
          color: Colors.blue,
        )
      ]).show();
}

confirmationPopup2(BuildContext dialogContext) async{
  var alertStyle = AlertStyle(
    animationType: AnimationType.grow,
    overlayColor: Colors.black87,
    isCloseButton: true,
    isOverlayTapDismiss: true,
    titleStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
    descStyle: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
    animationDuration: Duration(milliseconds: 400),
  );

  await Alert(
      context: dialogContext,
      style: alertStyle,
      title: "Error",
      desc: "The minimum amount of players cannot exceed the maximum.",
      buttons: [
        DialogButton(
          child: Text(
            "OK",
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          onPressed: () {
            Navigator.pop(dialogContext);
          },
          color: Colors.blue,
        )
      ]).show();
}

class NewPost extends StatefulWidget {
  @override
  _NewPostState createState() => _NewPostState();
}

class _NewPostState extends State<NewPost> {
  final sportController = TextEditingController();
  final descriptionController = TextEditingController();
  final locationController = TextEditingController();
  final minController = TextEditingController();
  final maxController = TextEditingController();
  DateTime gameTimeSet = DateTime.now();
  DateTime gameTimeTemp = DateTime.now();
  DateTime gameDayTemp = DateTime.now();
  String timeDispString = "Select Date and Time Below";

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

    List<String> list = List();
    Map dropDownItemsMap = Map();

    final school = DropdownButtonHideUnderline(
      child:  FutureBuilder(
        future: getSchoolLocations(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasError) {
            print(snapshot.error);
            return Container();
          } else if (snapshot.hasData) {
            list.clear();
            snapshot.data.forEach((branchItem) {
              //listItemNames.add(branchItem.itemName);
              int index = snapshot.data.indexOf(branchItem) as int;
              dropDownItemsMap[index] = branchItem;
              list.add(snapshot.data[index].toString());
            });
            return DropdownButton(
                value: dropdownLocationValue,
                icon: Icon(Icons.arrow_downward),
                iconSize: 24,
                elevation: 16,
                underline: Container(
                  height: 2,
                ),
                onChanged: (String newValue) {
                  setState(() {
                    dropdownLocationValue = newValue;
                  });
                },
                items: list.map<DropdownMenuItem<String>>((String v) {
                  return DropdownMenuItem<String>(
                      value: v,
                      child: Text(v)
                  );
                }).toList(growable: true)
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );

    final timeDisp = Padding(
        padding: EdgeInsets.all(5),
        child: FutureBuilder(
        future: getTimeDispString(gameTimeSet),
        builder: (context, AsyncSnapshot snapshot) {
          if(!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          } else {
            return Padding(
              padding: EdgeInsets.all(5),
              child: TextField(
              enabled: false,
              decoration: InputDecoration(
                hintText: '$timeDispString',
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 25, vertical: 20),
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
              DatePicker.showDatePicker(
                  context, showTitleActions: true,
                  onChanged: (date) {
                    print('change $date in time zone ' +
                        date.timeZoneOffset.inHours.toString());
                  },
                  onConfirm: (date) async{
                    print('confirm $date');
                    gameDayTemp = date;
                    gameTimeSet = DateTime(
                        gameDayTemp.year, gameDayTemp.month,
                        gameDayTemp.day, gameTimeTemp.hour,
                        gameTimeTemp.minute);
                    timeDispString = await getTimeDispString(gameTimeSet);
                    setState(() {});
                  },
                  currentTime: DateTime.now());
            },
            child: Text(
                'Select Date',
                style: TextStyle(
                    color: Colors.white, fontSize: 20)),
          ),
        ),
      );

      final gameDate = Padding(
        padding: EdgeInsets.all(5),
        child: ButtonTheme(
          height: 56,
          child: RaisedButton(
            color: Colors.red,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50)
            ),
            onPressed: () {
              DatePicker.showTime12hPicker(
                  context, showTitleActions: true,
                  onChanged: (date) {
                    print('change $date in time zone ' +
                        date.timeZoneOffset.inHours.toString());
                  },
                  onConfirm: (date) async{
                    print('confirm $date');
                    gameTimeTemp = date;
                    gameTimeSet = DateTime(
                        gameDayTemp.year, gameDayTemp.month,
                        gameDayTemp.day, gameTimeTemp.hour,
                        gameTimeTemp.minute);
                    timeDispString = await getTimeDispString(gameTimeSet);
                    setState(() {});
                  },
                  currentTime: DateTime.now());
            },
            child: Text(
                'Select Time',
                style: TextStyle(
                    color: Colors.white, fontSize: 20)),
          ),
        ),
      );

      final buttonAddPost = Padding(
        padding: EdgeInsets.all(5),
        child: ButtonTheme(
          height: 56,
          child: RaisedButton(
            child: Text('Create Post', style: TextStyle(
                color: Colors.white, fontSize: 20)),
            color: Colors.red,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50)
            ),
            onPressed: () async {
              if(dropdownLocationValue == "Please Select a Value"){
                confirmationPopup1(context);
              }
              else if(int.parse(minController.text) > int.parse(maxController.text)){
                confirmationPopup2(context);
              }
              else {
                String message = await newPost(sportController
                    .text,
                    descriptionController.text,
                    dropdownLocationValue, gameTimeSet,
                    int.parse(
                        maxController.text),
                    int.parse(minController
                        .text));
                if (message == "true") {
                  print("newPost");
                  //await Navigator.push(context, MaterialPageRoute(
                  //   builder: (context) => Feed()));
                  Navigator.pop(context);
                } else {
                  print(message);
                }
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
            child: Text('Back', style: TextStyle(
                color: Colors.white, fontSize: 20)),
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
                maxPlayers,
                minPlayers,
                school,
                timeDisp,
                gameTime,
                gameDate,
                buttonAddPost,
                buttonBack,
              ],
            ),

          ),
        )
    );
  }
}