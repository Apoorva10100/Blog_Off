import 'package:flutter/material.dart';
import 'loginpage.dart';
import 'homepage.dart';
import 'auth.dart';

class Mapping extends StatefulWidget {
  final BaseAuth auth;

  Mapping({this.auth});

  @override
  _MappingState createState() => _MappingState();
}

enum AuthStatus { notSignedIn, signedIn }

class _MappingState extends State<Mapping> {
  AuthStatus auth = AuthStatus.notSignedIn;

  @override
  void initState() {
    super.initState();
    widget.auth.getUser().then((value) {
      setState(() {
        if (value == null) {
          auth = AuthStatus.notSignedIn;
        } else {
          auth = AuthStatus.signedIn;
        }
      });
    });
  }

  void _signedIn() {
    setState(() {
      auth = AuthStatus.signedIn;
    });
  }

  void _signedOut() {
    setState(() {
      auth = AuthStatus.signedIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    switch (auth) {
      case AuthStatus.notSignedIn:
        return LoginPage(
          auth: widget.auth,
          onSignedIn: _signedIn,
        );
        break;
      case AuthStatus.signedIn:
        return HomePage(
          auth: widget.auth,
          onSignedOut: _signedOut,
        );
        break;
    }
    return Container();
  }
}
