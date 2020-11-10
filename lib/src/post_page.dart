import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:reservrec/src/post.dart';

import 'feed_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:reservrec/src/post_functions.dart';

class PostPage extends StatelessWidget{
  final PostModel postData;

  const PostPage({Key key, this.postData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(postData.sport)),
      body: InheritedPostModel(
        postData: postData,
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
                        ],
                    ),
                )
            ),
            Divider(color: Colors.grey),
            _PostAuthorInfo(),
          ],
        ),
      ),
    );
  }
}
/*
                          Divider(color: Colors.grey),
                          _PostAuthorInfo(),
 */

class _Summary extends StatelessWidget {
  final PostModel postData;
  const _Summary({Key key, this.postData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final PostModel postData = InheritedPostModel.of(context).postData;
    final TextStyle titleTheme = DefaultTextStyle.of(context).style.apply(fontSizeFactor: 2.5, fontSizeDelta: 1.5, fontWeightDelta: 6);
    final TextStyle locationTheme = DefaultTextStyle.of(context).style.apply(fontSizeFactor: .9, fontSizeDelta: 1, fontWeightDelta: -1);
    final TextStyle timeTheme = DefaultTextStyle.of(context).style.apply(fontSizeFactor: 1, fontSizeDelta: 1, fontWeightDelta: 2, color: Colors.red);

    final String title = postData.sport;
    final String location = postData.loc;

    final DateFormat formatter = DateFormat('h:mm a on EEEE, LLLL d, y');
    final String formatted = formatter.format(postData.gameTime);

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
            Text('at $location', overflow: TextOverflow.ellipsis, style: locationTheme),
            SizedBox(height: 8.0),
            Text(formatted, overflow: TextOverflow.ellipsis,style: timeTheme),
          ],
        ),
      ),
    );
  }
}

class _Body extends StatelessWidget {
  final PostModel postData;

  const _Body({Key key, this.postData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final PostModel postData = InheritedPostModel.of(context).postData;
    final TextStyle bodyTheme = DefaultTextStyle.of(context).style.apply(fontSizeFactor: 1.25, fontSizeDelta: 1.5, fontWeightDelta: 1);

    final bodyText = postData.desc;
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

class _PostAuthorInfo extends StatelessWidget {
  const _PostAuthorInfo({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: Row(
            children: <Widget>[
                UserImage(),
                UserNameAndEmail(),
                JoinButton(),
            ],
        )
    );
  }
}

class UserImage extends StatelessWidget {
  const UserImage({Key key}) : super(key: key);

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

class UserNameAndEmail extends StatelessWidget {
  const UserNameAndEmail({Key key}) : super(key: key);

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

class JoinButton extends StatelessWidget {
  const JoinButton({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final PostModel postData = InheritedPostModel.of(context).postData;
    return Expanded(
      flex: 1,
      child: ToggleButtons(
        children: <Widget>[Icon(Icons.library_add_check)],
        onPressed: (int index) {
          changeJoinedStatus(postData.id);
        },
        isSelected: [false],
      ),
    );
    /*return FutureBuilder(
          future: isInPost(postData.id),
          builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
            if(snapshot.hasData) { print(snapshot.data); }
              return Expanded(
                flex: 1,
                  child: ToggleButtons(
                    children: <Widget>[Icon(Icons.library_add_check)],
                    onPressed: (int index) {
                      changeJoinedStatus(postData.id);
                    },
                    isSelected: [snapshot.data],
                  ),
              );
          });*/
  }
}

class TeamSelection extends StatelessWidget {
  const TeamSelection({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final PostModel postData = InheritedPostModel.of(context).postData;
    return Expanded(
      flex: 6,
      child: Row(
        children: <Widget>[
          Column(),
          Column(),
        ],
      ),
    );
  }
}