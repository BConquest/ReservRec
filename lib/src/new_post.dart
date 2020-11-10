import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:reservrec/src/dashboard.dart';
import 'package:reservrec/src/feed_functions.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:reservrec/src/user_functions.dart';

Future<String> getTimeDispString(DateTime time) async{
  print('Func: ${time.toString()}');
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
    List<String> list = new List();
    Map dropDownItemsMap = new Map();
     return Scaffold(
        body: FutureBuilder(
            future: getTimeDispString(gameTimeSet),
            builder: (context, AsyncSnapshot snapshot) {
              if(!snapshot.hasData) {
                return Center(child: CircularProgressIndicator());
              } else {
                return ListView(
                    shrinkWrap: true,
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    children: [
                      // TODO Change To be custom profile picture
                      Padding(
                        padding: EdgeInsets.all(20),
                        child: Hero(
                            tag: 'hero',
                            child: SizedBox(
                              height: 160,
                              child: Image.asset('assets/logo.png'),
                            )
                        ),
                      ),

                      Padding(
                        padding: EdgeInsets.all(5),
                        child: TextField(
                          keyboardType: TextInputType.text,
                          controller: sportController,
                          decoration: InputDecoration(
                              hintText: 'Sport',
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 25, vertical: 20),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(50.0)
                              )
                          ),
                        ),
                      ),

                      Padding(
                        padding: EdgeInsets.all(5),
                        child: TextField(
                          keyboardType: TextInputType.text,
                          controller: descriptionController,
                          decoration: InputDecoration(
                              hintText: 'About',
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 25, vertical: 20),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(50.0)
                              )
                          ),
                        ),
                      ),

                      Padding(
                        padding: EdgeInsets.all(5),
                        child: TextField(
                          keyboardType: TextInputType.text,
                          controller: locationController,
                          decoration: InputDecoration(
                              hintText: 'Location of Sport Activity',
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 25, vertical: 20),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(50.0)
                              )
                          ),
                        ),
                      ),

                      Padding(
                        padding: EdgeInsets.all(5),
                        child: TextField(
                          keyboardType: TextInputType.text,
                          controller: minController,
                          decoration: InputDecoration(
                              hintText: 'Minimum Amount of Players',
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 25, vertical: 20),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(50.0)
                              )
                          ),
                        ),
                      ),

                      Padding(
                        padding: EdgeInsets.all(5),
                        child: TextField(
                          keyboardType: TextInputType.text,
                          controller: maxController,
                          decoration: InputDecoration(
                              hintText: 'Maximum Amount of Players',
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 25, vertical: 20),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(50.0)
                              )
                          ),
                        ),
                      ),

                      DropdownButtonHideUnderline(
                        child: new FutureBuilder(
                          future: getSchoolLocations(),
                          builder: (context, AsyncSnapshot snapshot) {
                            if (!snapshot.hasData) {
                              return Center(child: CircularProgressIndicator());
                            } else {
                              snapshot.data.forEach((branchItem) {
                                print(branchItem);
                                int index = snapshot.data.indexOf(branchItem);
                                print("1");
                                dropDownItemsMap[index] = branchItem;
                                print("2");
                                list.add(snapshot.data[index].toString());
                                print("3");
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
                                      print("set state");
                                      print("new value $newValue");
                                      dropdownLocationValue = newValue;
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
                      ),

                      Padding(
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
                      ),

                      Padding(
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
                                    gameTimeSet = new DateTime(
                                        gameDayTemp.year, gameDayTemp.month,
                                        gameDayTemp.day, gameTimeTemp.hour,
                                        gameTimeTemp.minute);
                                    print('Date_0: ${gameTimeSet.toString()}');
                                    timeDispString = await getTimeDispString(gameTimeSet);
                                    print('Date_1: $timeDispString');
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
                      ),

                      Padding(
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
                                    gameTimeSet = new DateTime(
                                        gameDayTemp.year, gameDayTemp.month,
                                        gameDayTemp.day, gameTimeTemp.hour,
                                        gameTimeTemp.minute);
                                    print('Time_0: ${gameTimeSet.toString()}');
                                    timeDispString = await getTimeDispString(gameTimeSet);
                                    print('Time_1: timeDispString');
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
                      ),


                      Padding(
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
                              String message = await newPost(sportController
                                  .text,
                                  descriptionController.text,
                                  locationController.text, gameTimeSet,
                                  int.parse(
                                      maxController.text),
                                  int.parse(minController
                                      .text));
                              if (message == "true") {
                                print("newPost");
                                Navigator.push(context, MaterialPageRoute(
                                    builder: (context) => Feed()));
                              } else {
                                print(message);
                              }
                            },
                          ),
                        ),
                      ),

                      Padding(
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
                      ),
                    ]
                );
              }
            }
          )
        );
  }
}