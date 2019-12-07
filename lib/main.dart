import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'home.dart';
import 'contacts.dart';



void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Time is Money',
      home: HomeWidget());
  }
}


