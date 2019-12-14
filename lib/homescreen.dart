import 'package:flutter/material.dart';
import 'utils.dart';
import 'timwidget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    List<Widget> items = new List();
    allTim.forEach((t){
      items.add(TimCard(t));
    });
    return ListView(
        children: items
    );
  }
}
