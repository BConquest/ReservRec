import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:reservrec/models/user.dart';
import 'package:reservrec/src/post.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'feed_functions.dart';
import 'package:reservrec/src/post_functions.dart';
import 'package:reservrec/src/profileview.dart';
import 'package:reservrec/src/messenger.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class PostPage extends StatefulWidget {
  final PostModel postData;
  final bool manager;
  const PostPage({Key key, this.postData, this.manager}): super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _PostPage();
  }
}

BoxDecoration Decoration() {
  return BoxDecoration(
    border: Border.all(
      width: 1,
      color: Colors.black12
    ),
  );
}

confirmationPopup(BuildContext dialogContext, int toDelete) async{
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
      title: "Confirm Delete",
      desc: "Do you really want to delete this post?",
      buttons: [
        DialogButton(
          child: Text(
            "Cancel",
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          onPressed: () {
            Navigator.pop(dialogContext);
          },
          color: Colors.blue,
        ),
        DialogButton(
          child: Text(
            "Delete",
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          onPressed: () {
            deletePost(toDelete);
            Navigator.pop(dialogContext);
          },
          color: Colors.blue,
        )
      ]).show();
}

class _PostPage extends State<PostPage>{
  final PostModel postData;
  final bool manager;
  _PostPage({Key key, this.postData, this.manager});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.postData.sport)),
      body: InheritedPostModel(
        postData: widget.postData,
        manager: widget.manager,
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
  final bool manager;
  const _Body({Key key, this.postData, this.manager}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final PostModel postData = InheritedPostModel.of(context).postData;
    final TextStyle bodyTheme = DefaultTextStyle.of(context).style.apply(fontSizeFactor: 1.25, fontSizeDelta: 1.5, fontWeightDelta: 1);

    final bodyText = postData.desc;
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(left: 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(left: 8),
              child: Text(bodyText, overflow: TextOverflow.visible, style: bodyTheme),
            ),
            SizedBox(height: 5.0),
            Container(
              padding: EdgeInsets.only(left: 8),
              child: DeleteButton(),
            ),
            //SizedBox(height: 5),
            Divider(color: Colors.grey),
            //SizedBox(height: 5),
            TeamSelection(),
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
  final PostModel postData;
  const ChatButton({Key key, this.postData}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final PostModel postData = InheritedPostModel.of(context).postData;
    return FlatButton(
        child: Icon(Icons.message_outlined),
        onPressed: () async {
          String s;
          s = await getDocumentID(postData.id);
          await Navigator.push(context, MaterialPageRoute(builder: (context) => MessengerView(gameID: s)));
        }
    );
  }
}

class DeleteButton extends StatelessWidget {
  final PostModel postData;
  final bool manager;
  const DeleteButton({Key key, this.postData, this.manager}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final PostModel postData = InheritedPostModel.of(context).postData;
    final bool manager = InheritedPostModel.of(context).manager;
    if (postData.author == FirebaseAuth.instance.currentUser.uid || manager) {
      return Container(
          width: 75,
          decoration: Decoration(),
          child: FlatButton(
              minWidth: 75,
              child: Text("Delete"),
              onPressed: () async {
                await confirmationPopup(context, postData.id);
                Navigator.pop(context);
              }
          )
      );
    } else {
      return Container();
    }
  }
}

class TeamSelection extends StatefulWidget {
  final PostModel postData;
  const TeamSelection({Key key, this.postData}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _TeamSelectionState();
  }}

class _TeamSelectionState extends State<TeamSelection> {
  @override
  Widget build(BuildContext context) {
    final PostModel postData = InheritedPostModel.of(context).postData;
    return FutureBuilder(
        future: getCurUsers2(postData.id),
        builder: (BuildContext context, AsyncSnapshot<List<UserC>> snapshot) {
          print('above if');
          if(!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError){
            print('snap error ${snapshot.error}');
            return Center(child: CircularProgressIndicator());
          } else {
            print('postData.id: ${postData.id}');
            var users = snapshot.data;
            String c1 = "Team 1: \n";
            String c2 = "Team 2: \n";
            int i = 0;
            print('len: ${users.length}');
            for (int j = 0; j < users.length; j++){
              if(i % 2 == 0) {
                c1 = c1 + '\n' + users[j].userUsername;
                print('c1: $c1');
              } else {
                c2 = c2 + '\n' + users[j].userUsername;
                print('c2: $c2');
              }
              i++;
            }
            if (c1.length > c2.length) {
              c2 = c2 + '\n';
            }
            var ret = Container(
                  //decoration: Decoration(),
                  padding: EdgeInsets.only(left: 5, top: 5, right: 5, bottom: 5),
                  child: Row(
                    children: [
                      Expanded(child: Text(c1)),
                      Expanded(child: Text(c2)),
                ],
              ),
            );
            return ret;
          }
        });
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

