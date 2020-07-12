import 'package:blog_off/auth.dart';
import 'package:blog_off/mapping.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Mapping(auth: Auth()),
    );
  }
}
