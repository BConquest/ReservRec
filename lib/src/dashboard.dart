import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:reservrec/src/feed_functions.dart';
import 'package:reservrec/src/post.dart';
import 'package:reservrec/src/new_post.dart';
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
    await grabFeed();
    setState(() {
      grabFeed();
    });
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }

  void _onLoading() async{
    // monitor network fetch
    await grabFeed();
    // if failed,use loadFailed(),if no data return,use LoadNodata()
    _refreshController.loadComplete();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: grabFeed(),
        builder: (context, AsyncSnapshot snapshot) {
          print(snapshot.hasData);
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
                          itemCount: snapshot.data.length,
                          itemBuilder: (BuildContext context, int index) {
                            return PostCard(postData: snapshot.data[index]);
                          },
                )
              ),
              bottomNavigationBar: BottomNavigationBar(
                items: const <BottomNavigationBarItem>[
                  BottomNavigationBarItem(
                    icon: Icon(Icons.add),
                    label: 'newpost',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.logout),
                    label: 'logout',
                  ),
                ],
                onTap: (int index) async {
                  if (index == 0) {
                    Navigator.push(context, MaterialPageRoute(builder: (context) =>  NewPost()));
                  } else {
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