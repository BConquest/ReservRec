import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:reservrec/models/user.dart';
import 'package:reservrec/src/post.dart';

import 'feed_functions.dart';
import 'package:reservrec/src/post_functions.dart';
import 'package:reservrec/src/profileview.dart';
import 'package:reservrec/src/messenger.dart';

class PostPage extends StatefulWidget {
  final PostModel postData;
  const PostPage({Key key, this.postData}): super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _PostPage();
  }
}

class _PostPage extends State<PostPage>{
  final PostModel postData;
  _PostPage({Key key, this.postData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.postData.sport)),
      body: InheritedPostModel(
        postData: widget.postData,
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
            _PostAuthorInfo(),
          ],
        ),
      ),
    );
  }
}
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
  final PostModel postData;
  const _PostAuthorInfo({Key key, this.postData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: Row(
            children: <Widget>[
                UserImage(),
                UserNameAndEmail(),
                JoinButton(),
                ChatButton(),
            ],
        )
    );
  }
}

class UserImage extends StatelessWidget {
  final PostModel postData;
  const UserImage({Key key, this.postData}) : super(key: key);

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
  final PostModel postData;
  const UserNameAndEmail({Key key, this.postData}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final PostModel postData = InheritedPostModel.of(context).postData;
    final TextStyle nameTheme = DefaultTextStyle.of(context).style.apply(fontSizeFactor: 1, fontSizeDelta: 1, fontWeightDelta: 1);
    final TextStyle emailTheme = DefaultTextStyle.of(context).style.apply(fontSizeFactor: .9, fontSizeDelta: 1, fontWeightDelta: 0);


    return InkWell(
      onTap: () async {
        var uid = postData.author;
        await Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileView(uid: uid)));
      },
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
  final PostModel postData;
  const JoinButton({Key key, this.postData}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final PostModel postData = InheritedPostModel.of(context).postData;
    List<bool> sel;
    return FutureBuilder(
          future: isInPost(postData.id),
          builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
              if(!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
              } else {
                sel = [snapshot.data];
                return Expanded(
                  flex: 1,
                  child: ToggleButtons(
                    children: <Widget>[Icon(Icons.library_add_check)],
                    onPressed: (int index) {
                        changeJoinedStatus(postData.id);/*
                        setState(() {
                            sel[index] = !sel[index];
                        });*/
                    },
                    isSelected: sel,
                  ),
                );
              }
          });
  }
}

class ChatButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FlatButton(
        child: Icon(Icons.message_outlined),
        onPressed: () async {
          await Navigator.push(context, MaterialPageRoute(builder: (context) => MessengerView()));
        }
    );
  }
}

class TeamSelection extends StatelessWidget {
  final PostModel postData;
  const TeamSelection({Key key, this.postData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final PostModel postData = InheritedPostModel.of(context).postData;
    return FutureBuilder(
        future: getCurUsers(postData.id),
        builder: (BuildContext context, AsyncSnapshot<List<UserC>> snapshot) {
          if(!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          } else {
            return Expanded(
              flex: 6,
              child: Row(
                children: getWidgets(snapshot.data)
              ),
            );
          }
        });
  }
  List<Widget> getWidgets(List<UserC> users) {
    List<Widget> c1 = List();
    List<Widget> c2 = List();
    int i = 0;
    for (var user in users) {
      if(i % 2 == 0) {
        c1.add(Text(user.userUsername));
      } else {
        c2.add(Text(user.userUsername));
      }
      i++;
    }
    var col1 = Column(children: c1);
    var col2 = Column(children: c2);
    List<Widget> ret = List();
    ret.add(col1);
    ret.add(col2);
    print(ret.first);
    return ret;
  }
  /*
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
  }*/
}

