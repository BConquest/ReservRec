import 'package:place_picker/place_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:reservrec/src/feed_functions.dart';
import 'package:reservrec/src/user_functions.dart';

LocationResult result;

class PickerDemo extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => PickerDemoState();
}

final locationController = TextEditingController();

class PickerDemoState extends State<PickerDemo> {
  @override
  Widget build(BuildContext context) {
    final logo = Padding(
      padding: EdgeInsets.all(20),
      child: Hero(
          tag: 'hero',
          child: SizedBox(
            height: 160,
            child: Image.asset('assets/logo.png'),
          )),
    );

    final locationName = Padding(
      padding: EdgeInsets.all(5),
      child: TextField(
        keyboardType: TextInputType.text,
        controller: locationController,
        decoration: InputDecoration(
            hintText: 'Name of Location',
            contentPadding: EdgeInsets.symmetric(horizontal: 25, vertical: 20),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(50.0))),
      ),
    );

    final buttonBack = Padding(
      padding: EdgeInsets.all(5),
      child: ButtonTheme(
        height: 56,
        child: RaisedButton(
          child:
              Text('Back', style: TextStyle(color: Colors.white, fontSize: 20)),
          color: Colors.red,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
          onPressed: () async {
            Navigator.pop(context);
          },
        ),
      ),
    );

    void showPlacePicker() async {
      result = await Navigator.of(context).push(
          MaterialPageRoute(
              builder: (context) =>
                  PlacePicker("AIzaSyB1k0Z1HxtF9Z1yN6Q9UBygU3EhbqaoZCU")));
      // Handle the result in your way
      print("result: $result");
      print(result.latLng);
    }

    final buttonLocation = Padding(
      padding: EdgeInsets.all(5),
      child: ButtonTheme(
        height: 56,
        child: RaisedButton(
          child:
          Text('Pick Delivery location', style: TextStyle(color: Colors.white, fontSize: 20)),
          color: Colors.red,
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
          onPressed: () {
            showPlacePicker();
          },
        ),
      ),
    );

    final buttonAddLocation = Padding(
      padding: EdgeInsets.all(5),
      child: ButtonTheme(
        height: 56,
        child: RaisedButton(
            child: Text('Add Location', style: TextStyle(
                color: Colors.white, fontSize: 20)),
            color: Colors.red,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50)
            ),
            onPressed: () async {
              String s = await getCurrentSchool();
              newLocation(
                    locationController.text, result.latLng.latitude,
                    result.latLng.longitude, s);
              Navigator.pop(context);
            }
        ),
      ),
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Picker Example')),
      body: Center(
          child: ListView(
              shrinkWrap: true,
              padding: EdgeInsets.symmetric(horizontal: 20),
              children: <Widget>[
                logo,
                locationName,
                buttonLocation,
                buttonAddLocation,
                buttonBack,
              ],
          ),
      ),
    );
  }
}
