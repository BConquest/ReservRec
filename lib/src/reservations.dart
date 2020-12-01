import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:reservrec/models/user.dart';
import 'package:reservrec/src/post.dart';

import 'feed_functions.dart';
import 'package:reservrec/src/post_functions.dart';
import 'package:reservrec/src/profileview.dart';
import 'package:reservrec/src/messenger.dart';

class Reservations extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _FeedState();
  }
}

class _FeedState extends State<Reservations>{

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Reservations")),
      body: InheritedPostModel(
        child: Column(
          children: <Widget>[
            Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      _Summary(),
                      Divider(color: Colors.grey),
                      SizedBox(height: 10),
                      _Body(),
                      //TeamSelection(),
                    ],
                  ),
                )
            ),
            Divider(color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
class _Summary extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final TextStyle titleTheme = DefaultTextStyle.of(context).style.apply(fontSizeFactor: 2.5, fontSizeDelta: 1.5, fontWeightDelta: 6);
    final TextStyle locationTheme = DefaultTextStyle.of(context).style.apply(fontSizeFactor: .9, fontSizeDelta: 1, fontWeightDelta: -1);
    final TextStyle timeTheme = DefaultTextStyle.of(context).style.apply(fontSizeFactor: 1, fontSizeDelta: 1, fontWeightDelta: 2, color: Colors.red);

    final String title = "REC CENTER 1";
    final String location = "University of Alabama";
    final String formatted = "Showing Times:";

    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(left: 8.0, top: 3.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text(title, overflow: TextOverflow.ellipsis, style: titleTheme),
            SizedBox(height: 2.0),
            Text(location, overflow: TextOverflow.ellipsis, style: locationTheme),
            SizedBox(height: 8.0),
            Text(formatted, overflow: TextOverflow.ellipsis,style: timeTheme),
          ],
        ),
      ),
    );
  }
}

class _Body extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final TextStyle bodyTheme = DefaultTextStyle.of(context).style.apply(fontSizeFactor: 1.25, fontSizeDelta: 1.5, fontWeightDelta: 1);

    final bodyText = "10:00AM - 2:00PM";
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text(bodyText, overflow: TextOverflow.visible, style: bodyTheme),
            SizedBox(height: 2.0),
          ],
        ),
      ),
    );
  }
}