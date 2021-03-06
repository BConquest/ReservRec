import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:reservrec/src/addValidEmail.dart';
import 'package:reservrec/src/feed_functions.dart';
import 'package:reservrec/src/post.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:reservrec/src/addLocation.dart';
import 'package:reservrec/src/reservations.dart';
import 'package:reservrec/src/map.dart';

class Manager extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    seeUserPosts = true;
    return _FeedState();
  }
}

class _FeedState extends State<Manager> {
  //@override
  //_FeedState({Key key}) : super(key: key);

  RefreshController _refreshController = RefreshController(initialRefresh: true);

  void _onRefresh() async{
    seeUserPosts = true;
    await grabFeed(-2);
    setState(() {
      grabFeed(-2);
    });
    _refreshController.refreshCompleted();
  }

  void _onLoading() async{
    // monitor network fetch
    seeUserPosts = true;
    await grabFeed(-2);
    // if failed,use loadFailed(),if no data return,use LoadNodata()
    _refreshController.loadComplete();
  }

  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder(
            future: grabFeed(-2),
            builder: (context, AsyncSnapshot snapshot) {
              if(!snapshot.hasData) {
                return Center(child: CircularProgressIndicator());
              } else {
                return Scaffold(
                  appBar: AppBar(
                    title: Text("Manager View"),

                  ),
                  body: SmartRefresher(
                      enablePullDown: true,
                      enablePullUp: true,
                      controller: _refreshController,
                      onRefresh: _onRefresh,
                      onLoading: _onLoading,
                      child: ListView.builder(
                        itemCount: snapshot.data.length as int,
                        itemBuilder: (BuildContext context, int index) {
                          return PostCard(postData: snapshot.data[index] as PostModel, manager: true);
                        },
                      )
                  ),
                  bottomNavigationBar: BottomNavigationBar(
                    //otherwise labels do not show up
                    type: BottomNavigationBarType.fixed,
                    items: const <BottomNavigationBarItem>[
                      BottomNavigationBarItem(
                        icon: Icon(Icons.settings),
                        label: 'Reservations',
                        backgroundColor: Colors.red,
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.mail),
                        label: 'Add Valid Email',
                        backgroundColor: Colors.red,
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.add_location),
                        label: 'Add Locations',
                        backgroundColor: Colors.red,
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.logout),
                        label: 'Log Out',
                        backgroundColor: Colors.red,
                      ),
                    ],
                    onTap: (int index) async {
                      if (index == 0) {
                        await Navigator.push(context, MaterialPageRoute(builder: (context) =>  Reservations()));
                      } else if (index == 1) {
                        await Navigator.push(context, MaterialPageRoute(builder: (context) => addValidEmail()));
                      } else if (index == 2) {
                        await Navigator.push(context, MaterialPageRoute(builder: (context) => PickerDemo()));
                      }else {
                        final FirebaseAuth auth = FirebaseAuth.instance;
                        await auth.signOut();
                        Navigator.pop(context);
                      }
                    },
                  ),
                );
              }
            }
        )
    );
  }
}