import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:reservrec/src/post_page.dart';

import 'feed_functions.dart';

BoxDecoration Decoration() {
  return BoxDecoration(
    borderRadius: BorderRadius.circular(7),
    border: Border.all(
      color: Colors.black26,
      width: 2,
    ),
  );
}

class PostCard extends StatelessWidget {
  final PostModel postData;
  final bool manager;
  const PostCard({Key key, this.postData, this.manager}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(
          builder: (BuildContext context) {
            return PostPage(postData: postData, manager: manager);
          }
        ));
      },
      child: AspectRatio(
        aspectRatio: 6 / 3,
        child: Card(
          elevation: 2,
          child: Container(
            margin: const EdgeInsets.all(4.0),
            padding: const EdgeInsets.all(4.0),
            decoration: Decoration(),
            child: InheritedPostModel(
              postData: postData,
                manager: manager,
                child: Column(
                  children: <Widget>[
                    _Post(),
                    _PostTimeStamp(),
                    Divider(color: Colors.grey),
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

class _Post extends StatelessWidget {
  final PostModel postData;
  final bool manager;
  const _Post({Key key, this.postData, this.manager}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 3,
      child: Row(
          children: <Widget>[_PostImage(), _PostTitleAndSummary()]
      )
    );
  }
}

class _PostTitleAndSummary extends StatelessWidget {
  const _PostTitleAndSummary({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final PostModel postData = InheritedPostModel.of(context).postData;
    final TextStyle titleTheme = DefaultTextStyle.of(context).style.apply(fontSizeFactor: 1.6, fontSizeDelta: 1.5, fontWeightDelta: 1);
    final TextStyle summaryTheme = DefaultTextStyle.of(context).style.apply(fontSizeFactor: 1.1, fontSizeDelta: 1, fontWeightDelta: 0);
    final TextStyle locationTheme = DefaultTextStyle.of(context).style.apply(fontSizeFactor: .9, fontSizeDelta: 1, fontWeightDelta: -1);
    final String title = postData.sport;
    final String summary = postData.desc;
    final String location = postData.loc;

    return Flexible(
      child: Padding(
        padding: const EdgeInsets.only(left: 4.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text(title, overflow: TextOverflow.ellipsis, style: titleTheme),
            SizedBox(height: 2.0),
            Text(summary, overflow: TextOverflow.ellipsis, style: summaryTheme),
            SizedBox(height: 2.0),
            Text('at $location', overflow: TextOverflow.ellipsis, style: locationTheme),
          ],
        ),
      ),
    );
  }
}

class _PostImage extends StatelessWidget {
  const _PostImage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(alignment: Alignment.centerLeft, child: Image.asset("assets/logo.png"));
  }
}

class _PostDetails extends StatelessWidget {
  const _PostDetails({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        _UserImage(),
        _UserNameAndEmail(),
        _PostAttendance(),
      ],
    );
  }
}

class _UserNameAndEmail extends StatelessWidget {
  const _UserNameAndEmail({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final PostModel postData = InheritedPostModel.of(context).postData;
    final TextStyle nameTheme = DefaultTextStyle.of(context).style.apply(fontSizeFactor: 1, fontSizeDelta: 1, fontWeightDelta: 1);
    final TextStyle emailTheme = DefaultTextStyle.of(context).style.apply(fontSizeFactor: .9, fontSizeDelta: 1, fontWeightDelta: 0);


    return Expanded(
      flex: 5,
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(postData.auth_name, style: nameTheme),
            SizedBox(height: 2.0),
            Text(postData.auth_email, style: emailTheme),
          ],
        ),
      ),
    );
  }
}

class _UserImage extends StatelessWidget {
  const _UserImage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final PostModel postData = InheritedPostModel.of(context).postData;
    return Expanded(
      flex: 1,
      child: CircleAvatar(
        child: Image.network(postData.auth_pic),
      ),
    );
  }
}

class _PostTimeStamp extends StatelessWidget {
  const _PostTimeStamp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final PostModel postData = InheritedPostModel.of(context).postData;
    final DateFormat formatter = DateFormat('h:mm a on MM-dd-yyyy');
    final String formatted = formatter.format(postData.gameTime);
    return Align(
        alignment: Alignment.bottomRight,
        child: Text(formatted)
    );
  }
}

class _PostAttendance extends StatelessWidget {
  const _PostAttendance({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final PostModel postData = InheritedPostModel.of(context).postData;
    final int max = postData.maxPlayers;
    final int cur = postData.curPlayers;
    final String formatted = "$cur / $max players";
    return Expanded(
      flex: 2,
        child: Text(formatted)
    );
  }
}

// https://medium.com/@shakleenishfar/leaf-flutter-social-media-app-part-6-models-and-inherited-widgets-to-pass-data-a19c3699a56e

class InheritedPostModel extends InheritedWidget {
  final PostModel postData;
  final bool manager;
  final Widget child;

  InheritedPostModel({
    Key key,
    @required this.postData,
    @required this.manager,
    this.child,
  }) : super(key: key, child: child);

  static InheritedPostModel of(BuildContext context) {
    // ignore: deprecated_member_use
    return (context.inheritFromWidgetOfExactType(InheritedPostModel)
    as InheritedPostModel);
  }

  @override
  bool updateShouldNotify(InheritedPostModel oldWidget) {
    return true;
  }
}