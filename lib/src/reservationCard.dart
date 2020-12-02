import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:reservrec/src/post_page.dart';
import 'post.dart';

import 'feed_functions.dart';

class ReservationCard extends StatelessWidget {
  final PostModel postData;
  const ReservationCard({Key key, this.postData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        child: AspectRatio(
          aspectRatio: 10/3,
          child: Card(
            elevation: 3,
            child: Container(
              margin: const EdgeInsets.all(3.0),
              padding: const EdgeInsets.all(3.0),
                decoration: Decoration(),
              child: InheritedPostModel(
                  postData: postData,
                  child: Column(
                    children: <Widget>[
                      TimeReserved(),
                      Divider(color: Colors.blue),
                      _PostDetails(),
                    ],
                  )
              ),
            ),
          ),
        )
    );
  }
}

class _PostDetails extends StatelessWidget {
  const _PostDetails({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        UserWhoReserved(),
      ],
    );
  }
}

class UserWhoReserved extends StatelessWidget {
  const UserWhoReserved({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final PostModel postData = InheritedPostModel.of(context).postData;
    final TextStyle nameTheme = DefaultTextStyle.of(context).style.apply(fontSizeFactor: 1, fontSizeDelta: 1, fontWeightDelta: 1);

    return Expanded(
      flex: 5,
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text("Reserved by " + postData.auth_name, style: nameTheme),
          ],
        ),
      ),
    );
  }
}

class TimeReserved extends StatelessWidget {
  const TimeReserved({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final PostModel postData = InheritedPostModel.of(context).postData;
    final DateFormat formatter = DateFormat('h:mm a on MM-dd-yyyy');
    final String formatted = postData.loc + "\n" + postData.sport + "\n" + formatter.format(postData.gameTime);
    return Align(
        alignment: Alignment.topLeft,
        child: Text(formatted)
    );
  }
}

BoxDecoration Decoration() {
  return BoxDecoration(
    border: Border.all(
      width: 1,
    ),
  );
}