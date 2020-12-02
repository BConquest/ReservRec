import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:reservrec/src/feed_functions.dart';
import 'package:reservrec/src/post.dart';
import 'package:reservrec/src/new_post.dart';
import 'package:reservrec/src/profileview.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:reservrec/src/reservationCard.dart';

RefreshController _refreshController = RefreshController(initialRefresh: true);

class Reservations extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    seeUserPosts = true;
    return _FeedState();
  }
}

class _FeedState extends State<Reservations> {
  @override
  void _onRefresh() async {
    // monitor network fetch
    await grabFeed(-1);
    setState(() {
      grabFeed(-1);
    });
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    // monitor network fetch
    seeUserPosts = true;
    await grabFeed(-1);
    // if failed,use loadFailed(),if no data return,use LoadNodata()
    _refreshController.loadComplete();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: grabFeed(-1),
          builder: (context, AsyncSnapshot snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            } else {
              print(snapshot.data.length);
              return Scaffold(
                appBar: AppBar(title: Text("Current Reservations")),
                body: SmartRefresher(
                    enablePullDown: true,
                    enablePullUp: true,
                    controller: _refreshController,
                    onRefresh: _onRefresh,
                    onLoading: _onLoading,
                    child: ListView.builder(
                      itemCount: snapshot.data.length as int,
                      itemBuilder: (BuildContext context, int index) {
                        return ReservationCard(postData: snapshot.data[index] as PostModel);
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