import 'package:flutter/material.dart';

class MessengerView extends StatefulWidget {
  @override
  _MessengerViewPage createState() => _MessengerViewPage();
}

class _MessengerViewPage extends State<MessengerView> {
  @override
  Widget build(BuildContext context) {
    var chatController = TextEditingController();

    final inputMessage = Padding(
      padding: EdgeInsets.only(bottom: 20),
      child: TextField(
        keyboardType: TextInputType.text,
        controller: chatController,
        decoration: InputDecoration(
            hintText: 'Message',
            contentPadding: EdgeInsets.symmetric(horizontal: 25, vertical: 20),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(50.0)
            )
        ),
      ),
    );

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
              print("TODO");
            },
          ),
          body: Builder(
            builder: (context) =>
                Center(
                  child: ListView(
                    children: [
                      inputMessage,
                    ],
                  )
                )
          )
        )
    );
  }
}
