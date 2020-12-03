import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:location/location.dart';
import 'dart:math';

double calcDistance(double lat0, double lat1, double lon0, double lon1) {

  assert(lat0 > -90 && lat0 < 90);
  assert(lat1 > -90 && lat1 < 90);
  assert(lat0 > -180 && lat0 < 180);
  assert(lat0 > -180 && lat0 < 180);

  double distLat;
  double distLon;
  double lat0R = lat0 * (pi/180);
  double lat1R = lat1 * (pi/180);
  double a;
  double c;
  int rEarthMiles = 3956;

  //degrees lat and lon to radians
  distLat = (lat1 - lat0) * (pi/180);
  distLon = (lon1 - lon0) * (pi/180);

  //Haversine formula
  a = pow(sin(distLat / 2.0), 2) + cos(lat0R) * cos(lat1R) * pow(sin(distLon / 2.0), 2) as double;
  c = 2 * asin(sqrt(a));

  return (c * rEarthMiles);
}

class LocationPage extends StatefulWidget {
  @override
  _LocationPageState createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  LocationData currentLocation;
  // ignore: cancel_subscriptions
  StreamSubscription<LocationData> locationSubscription;
  Location location = Location();
  String error;

  //from https://www.geeksforgeeks.org/program-distance-two-points-earth/#:~:text=For%20this%20divide%20the%20values,is%20the%20radius%20of%20Earth.

  /* Commented out by the man ryan on 12/03/2020
  @override
  void initState() {
    super.initState();

    initPlatformState();
    locationSubscription = location.onLocationChanged.listen((LocationData result) {
      setState(() {
        currentLocation = result;
      });
    });
  }*/

  // Button to Calc Distance between points
  Widget build(BuildContext context) {
    /*final buttonGetLocation = Padding(
      padding: EdgeInsets.only(bottom: 5),
      child: ButtonTheme(
        height: 56,
        child: RaisedButton(
          child: Text('Get Distance', style: TextStyle(color: Colors.white, fontSize: 20)),
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
              text: 'Lat/Lon: ${currentLocation.latitude}/${currentLocation.longitude}\nDist = ${calcDistance(currentLocation.latitude, 30.22100, currentLocation.longitude, -90.02273)}',
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
