import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

import 'feed_functions.dart';

class PostPage extends StatelessWidget {
  final PostModel postData;

  const PostPage({Key key, @required this.postData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(postData.sport)),
      body: Center(child: Text(postData.desc)),
    );
  }
}