
import 'package:flutter/material.dart';
import 'package:reservrec/login_page.dart';
import 'package:reservrec/post.dart';

class Dashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final avatar = Padding(
      padding: EdgeInsets.all(20),
      child: Hero(
          tag: 'hero',
          child: SizedBox(
            height: 160,
            child: Image.asset('assets/defaultuser.png'),
          )
      ),
    );

    final description = Padding(
      padding: EdgeInsets.all(10),
      child: RichText(
        textAlign: TextAlign.justify,
        text: TextSpan(
            text: 'Anim ad ex officia nulla anim ipsum ut elit minim id non ad enim aute. Amet enim adipisicing excepteur ea fugiat excepteur enim veniam veniam do quis magna. Cupidatat quis exercitation ut ipsum dolor ipsum. Qui commodo nostrud magna consectetur. Nostrud culpa laboris Lorem aliqua non ut veniam culpa deserunt laborum occaecat officia.',
            style: TextStyle(color: Colors.black, fontSize: 20)
        ),
      ),
    );
    final buttonLogout = FlatButton(
        child: Text('Logout', style: TextStyle(color: Colors.black87, fontSize: 16),),
        onPressed: () {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage()));
        }
    );

    return SafeArea(
        child: Scaffold(
          body: Center(
            child: ListView(
              shrinkWrap: true,
              padding: EdgeInsets.symmetric(horizontal: 20),
              children: <Widget>[
                avatar,
                description,
                buttonLogout
              ],
            ),
          ),
        )
    );
  }
}

class Feed extends StatelessWidget {
  const Feed({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
      ),
      body: ListView.builder(
        itemCount: 500,
        itemBuilder: (BuildContext context, int index) {
          return PostCard();
        },
      ),
    );
  }
}
