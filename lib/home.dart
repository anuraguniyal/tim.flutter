import 'package:flutter/material.dart';
import 'homescreen.dart';
import 'contacts.dart';
import 'timwidget.dart';
import 'utils.dart';

class HomeWidget extends StatefulWidget {
  HomeWidget({Key key}) : super(key: key);

  @override
  _HomeWidgetState createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
  TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const List<Widget> _widgetOptions = <Widget>[
    const HomeScreen(),
    Text(
      'Profile',
      style: optionStyle,
    ),
    Text(
      'About',
      style: optionStyle,
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Time is Money'),
      ),
      body:  _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text('Home'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business),
            title: Text('Profile'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            title: Text('About'),
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
      //floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: _onAddTim,
        tooltip: 'Add Tim',
        child: const Icon(Icons.add_alert),
      )
    );
  }

  void _onAddTim(){
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return Contacts
        return ContactListWidget("Create Tim", _onCreateTim);
      },
    );
  }

  void _onCreateTim(List<ContactPhone> contacts){
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return TimWidget(contacts);
      },
    );
  }
}