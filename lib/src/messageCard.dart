import 'package:flutter/material.dart';

import 'package:reservrec/src/messengerFunctions.dart';

class MessageCard extends StatelessWidget {
  final MessageModel messageData;

  const MessageCard({Key key, this.messageData}) : super(key: key);

  @override
  Widget build(BuildContext context) {



    return GestureDetector(
        child: AspectRatio(
          aspectRatio: 6 / 3,
          child: Card(
            elevation: 2,
            child: Container(
              margin: const EdgeInsets.all(4.0),
              padding: const EdgeInsets.all(4.0),
                child: Column(
                    children: <Widget>[
                      Text(messageData.message, overflow: TextOverflow.ellipsis),
                    ],
                  )
            ),
          ),
        )
    );
  }
}