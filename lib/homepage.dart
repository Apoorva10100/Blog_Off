import 'package:blog_off/auth.dart';
import 'package:blog_off/posts.dart';
import 'package:blog_off/upload.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class HomePage extends StatefulWidget {
  final BaseAuth auth;
  final VoidCallback onSignedOut;
  HomePage({this.auth, this.onSignedOut});
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Posts> postList = [];

  @override
  void initState() {
    super.initState();
    DatabaseReference postRef =
        FirebaseDatabase.instance.reference().child("Posts");
    postRef.once().then((DataSnapshot snap) {
      var key = snap.value.keys;
      var data = snap.value;

      postList.clear();

      for (var indKey in key) {
        Posts posts = Posts(data[indKey]['image']);

        postList.add(posts);
      }

      setState(() {
        print('Length:' + '$postList.length');
      });
    });
  }

  void _logOut() async {
    try {
      await widget.auth.signOut();
      widget.onSignedOut();
    } catch (e) {
      print('Error signing out');
    }
  }

  Widget postsUI(String image) {
    return Card(
      margin: EdgeInsets.all(20.0),
      child: SafeArea(
        child: Container(
          child: Image.network(image),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flogger'),
        backgroundColor: Colors.pink,
        centerTitle: true,
      ),
      body: Container(
        child: postList.length == 0
            ? Text('No posts')
            : ListView.builder(
                itemCount: postList.length,
                itemBuilder: (_, index) => postsUI(postList[index].image)),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.pink,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            IconButton(
              icon: Icon(
                Icons.person,
                color: Colors.white,
              ),
              tooltip: 'Sign Out',
              onPressed: _logOut,
            ),
            IconButton(
                icon: Icon(
                  Icons.add_a_photo,
                  color: Colors.white,
                ),
                tooltip: 'Add a photo',
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return UploadPic();
                  }));
                }),
          ],
        ),
      ),
    );
  }
}
