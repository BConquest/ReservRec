import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'package:reservrec/src/messengerFunctions.dart';
import 'package:reservrec/src/messageCard.dart';

class MessengerView extends StatefulWidget {
  final String gameID;

  const MessengerView({Key key, this.gameID}) : super(key: key);

  @override
  _MessengerViewPage createState() => _MessengerViewPage();
}

class _MessengerViewPage extends State<MessengerView> {
  RefreshController _refreshController = RefreshController(initialRefresh: false);

  void _onRefresh() async{
    await loadMessages(widget.gameID);
    setState(() {});
  }

  void _onLoading() async{
    await loadMessages(widget.gameID);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var chatController = TextEditingController();

    final inputMessage = Padding(
      padding: EdgeInsets.only(top: 5, bottom: 12, left: 2, right: 2),
      child: TextField(
        keyboardType: TextInputType.text,
        controller: chatController,
        decoration: InputDecoration(
            hintText: 'Message',
            contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 7),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(50.0)
            )
        ),
      ),
    );

    final buttonLoad = Padding(
        padding: EdgeInsets.only(bottom: 20),
        child: FlatButton(
          child: Text("Load"),
          onPressed: () async {
            await loadMessages(widget.gameID);
            setState(() {});
          },
        )
    );

    return Scaffold(
      body: FutureBuilder(
          future: loadMessages(widget.gameID),
          builder: (context, AsyncSnapshot snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            } else {
              return SafeArea(
                  child: Scaffold(
                      appBar: AppBar(
                        title: Text("Messenger"),
                        backgroundColor: Colors.red,
                      ),
                      floatingActionButton: FloatingActionButton(
                        child: Icon(Icons.message_outlined),
                        backgroundColor: Colors.red,
                        onPressed: () async {
                          sendMessage(chatController, widget.gameID);
                        },
                      ),
                      body: Container (
                      child: ListView(
                        children: <Widget>[
                          Container (
                            //child: SmartRefresher(
                              //enablePullDown: true,
                             // enablePullUp: true,
                             // controller: _refreshController,
                             // onRefresh: _onRefresh,
                            //  onLoading: _onLoading,
                              child: ListView.builder(
                                physics: ScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: snapshot.data.length as int,
                                itemBuilder: (BuildContext context, int index) {
                                  return MessageCard(messageData: snapshot.data[index] as MessageModel);
                                },
                            //  ),
                            )
                          ),
                          Container (
                              height: 50,
                              alignment: AlignmentDirectional.center,
                              child: inputMessage
                          )
                        ]
                      )
            )
                  )
                  );
            }
          }
      ),
    );
  }
}
