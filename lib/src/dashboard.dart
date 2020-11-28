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
              appBar: AppBar(
                title: Text("Home"),

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
              bottomNavigationBar: BottomNavigationBar(
                items: const <BottomNavigationBarItem>[
                  BottomNavigationBarItem(
                    icon: Icon(Icons.add),
                    label: 'New Post',
                    backgroundColor: Colors.red,
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.sort_rounded),
                    label: 'Sort',
                    backgroundColor: Colors.red,
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.person_add),
                    label: 'Friend',
                    backgroundColor: Colors.red,
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.account_circle),
                    label: 'Profile',
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
                  await Navigator.push(context, MaterialPageRoute(builder: (context) => NewPost()));
                  } else if (index == 1) {
                  await grabFeed(cycleFunction());
                  setState(() {});
                  } else if (index == 2) {
                    mode = mode ? false : true;
                    print(mode);
                    await grabFeed(sortIndex);
                    setState(() {});
                  } else if (index == 3) {
                    final auth = FirebaseAuth.instance;
                    final uid = auth.currentUser.uid;
                    await Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileView(uid: uid)));
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