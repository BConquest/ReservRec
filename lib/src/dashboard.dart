import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:reservrec/src/feed_functions.dart';
import 'package:reservrec/src/post.dart';
import 'package:reservrec/src/new_post.dart';
import 'package:reservrec/src/profileview.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Feed extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _FeedState();
  }
}

class _FeedState extends State<Feed> {
  //@override
  //_FeedState({Key key}) : super(key: key);

  RefreshController _refreshController = RefreshController(initialRefresh: false);

  void _onRefresh() async{
    // monitor network fetch
    await grabFeed(getSortIndex());
    setState(() {
      grabFeed(getSortIndex());
    });
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }

  void _onLoading() async{
    // monitor network fetch
    await grabFeed(getSortIndex());
    // if failed,use loadFailed(),if no data return,use LoadNodata()
    _refreshController.loadComplete();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: grabFeed(getSortIndex()),
        builder: (context, AsyncSnapshot snapshot) {
          if(!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          } else {
            return Scaffold(
              appBar: AppBar(title: Text("Home")),
              drawer: Drawer(
                child: ListView(
                  // Important: Remove any padding from the ListView.
                  padding: EdgeInsets.zero,
                  children: <Widget>[
                    DrawerHeader(
                      child: Image.asset('assets/logo.png'),
                    ),
                    ListTile(
                      title: Text('View Profile'),
                      onTap: () async {
                        final uid = FirebaseAuth.instance.currentUser.uid;
                        await Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileView(uid: uid)));
                      },
                    ),
                    ListTile(
                      title: mode ? Text('Show All') : Text('Show Following'),
                      onTap: () {
                        mode = mode ? false : true;
                        print(mode);
                        Navigator.pop(context);
                        setState(() {grabFeed(sortIndex);});
                      },
                    ),
                    ListTile(
                      title: Text("Time"),
                      onTap: () {
                        setSortIndex(0);
                        Navigator.pop(context);
                        setState(() {grabFeed(sortIndex);});
                      },
                    ),
                    ListTile(
                      title: Text("Max Amount of People Allowed"),
                      onTap: () {
                        setSortIndex(1);
                        Navigator.pop(context);
                        setState(() {grabFeed(sortIndex);});
                      },
                    ),
                    ListTile(
                      title: Text("Most Amount of People Going"),
                      onTap: () {
                        setSortIndex(2);
                        Navigator.pop(context);
                        setState(() {grabFeed(sortIndex);});
                      },
                    ),
                    ListTile(
                      title: Text("Least Amount of People Going"),
                      onTap: () {
                        setSortIndex(3);
                        Navigator.pop(context);
                        setState(() {grabFeed(sortIndex);});
                      },
                    ),
                    ListTile(
                      title: Text('Log Out'),
                      onTap: () async {
                        final FirebaseAuth auth = FirebaseAuth.instance;
                        await auth.signOut();
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: () async {
                  await Navigator.push(context, MaterialPageRoute(builder: (context) => NewPost()));
                },
                child: Icon(Icons.add),
                backgroundColor: Colors.red,
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
                            return PostCard(postData: snapshot.data[index] as PostModel);
                          },
                )
              ),
            );
          }
        }
      ),
    );
  }
}