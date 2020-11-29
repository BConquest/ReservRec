import 'package:flutter/material.dart';

import 'package:reservrec/src/messengerFunctions.dart';
import 'package:reservrec/src/user_functions.dart';

class MessageCard extends StatelessWidget {
  final MessageModel messageData;

  const MessageCard({Key key, this.messageData}) : super(key: key);

  Widget _userImage() {
    return FutureBuilder (
      future: getCurrentProfilePicture(messageData.id),
      builder: (context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        } else {
          final String photoUrl = snapshot.data.toString();
          return  CircleAvatar(
              child: Image.network(photoUrl),
          );
        }
      }
    );
  }

  Widget projectWidget() {
    return FutureBuilder(
        future: getChatInfo(messageData.id),
        builder: (context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          } else {
            String email = snapshot.data.toString();
            return Align(
              alignment: Alignment.centerLeft,
              child: ListTile(
                leading: _userImage(),
                title: Text(email),
                subtitle: Text(
                  messageData.timeSent.toString(),
                ),
              ),
            );
          }
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
          child: Card(
            clipBehavior: Clip.antiAlias,
            child: Column(
              children: [
                /*ListTile(
                  //leading: Image.asset("https://i.imgur.com/TwDP9Af.png"),
                  title: Text(messageData.id),
                  subtitle: Text(
                    messageData.timeSent.toString(),
                  ),
                ),*/
                projectWidget(),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    messageData.message.toString(),
                    style: TextStyle(color: Colors.black.withOpacity(0.6)),
                  ),
                ),
              ],
            ),
          ),
    );
  }
}