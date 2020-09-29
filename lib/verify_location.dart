import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:location/location.dart';

class LocationPage extends StatefulWidget {
  @override
  _LocationPageState createState() => _LocationPageState();

}

class _LocationPageState extends State<LocationPage> {
  LocationData currentLocation;
  // ignore: cancel_subscriptions
  StreamSubscription<LocationData> locationSubscription;
  Location location = new Location();
  String error;

  @override
  void initState() {
    super.initState();

    initPlatformState();
    locationSubscription = location.onLocationChanged.listen((LocationData result) {
      setState(() {
        currentLocation = result;
      });
    });
  }
  Widget build(BuildContext context) {
    /*final buttonGetLocation = Padding(
      padding: EdgeInsets.only(bottom: 5),
      child: ButtonTheme(
        height: 56,
        child: RaisedButton(
          child: Text('Verify Location', style: TextStyle(color: Colors.white, fontSize: 20)),
          color: Colors.red,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50)
          ),
          onPressed: () {
            final snackBar = SnackBar(content: Text('Yay! A SnackBar!'));
            Scaffold.of(context).showSnackBar(snackBar);
         }
        )
      )
    );*/
    final displayLocation = Padding(
        padding: EdgeInsets.all(10),
        child: RichText(
          textAlign: TextAlign.justify,
          text: TextSpan(
              text: 'Lat/Lon:${currentLocation.latitude}/${currentLocation.longitude}',
              style: TextStyle(color: Colors.black, fontSize: 20)
          ),
        )
    );

    return SafeArea(
        child: Scaffold(
          body: Center(

            child: ListView(
              shrinkWrap: true,
              padding: EdgeInsets.symmetric(horizontal: 20),
              children: <Widget>[
                displayLocation
              ],
            ),

          ),
        )
    );
  }
  void initPlatformState() async {
    LocationData myLocation;
    try {
      myLocation = await location.getLocation();
      error = "";
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED')
        error = 'Permission denied';
      else if (e.code == 'PERMISSION_DENIED_NEVER_ASK')
        error = 'Permission denied = ask user to enable in settings';
      myLocation = null;
    }
    setState(() {
      currentLocation = myLocation;
    });
  }
}
