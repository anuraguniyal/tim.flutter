import 'package:flutter/material.dart';
import 'utils.dart';

final _formKey = GlobalKey<FormState>();

class TimWidget extends StatefulWidget {
  List<ContactPhone> contacts;
  TimWidget(this.contacts);
  @override
  _TimWidgetState createState() => new _TimWidgetState(contacts);
}

class _TimWidgetState extends State<TimWidget> {
  List<ContactPhone> contacts;
  final _tim = Tim();
  _TimWidgetState(this.contacts);

  @override
  Widget build(BuildContext context) {
    return _mainWidget();
  }

  Widget _mainWidget() {
    List<Widget> items = new List();
    contacts.forEach((c) => items.add(Text(c.toString())));
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Tim')),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
        child:Column(
          children: items+[_getForm()]
        )
      )
    );
  }
  Form _getForm(){

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            decoration: const InputDecoration(
              hintText: 'Enter Title',
              labelText: "Title"
            ),
            validator: (value) {
              if (value.isEmpty) {
                return 'Please enter some title';
              }
              return null;
            },
            onSaved: (val) {
              setState(() {
                _tim.title = val;
              });
            },
          ),
          MyDropdownButtonFormField(
            items: [
              DropdownMenuItem(child: Text("In 10 min"), value: 10,),
              DropdownMenuItem(child: Text("In 20 min"), value: 20,),
              DropdownMenuItem(child: Text("In 30 min"), value: 30,),
              DropdownMenuItem(child: Text("In 1 hour"), value: 60,),
              DropdownMenuItem(child: Text("In 2 hour"), value: 120,),
            ],
            decoration: const InputDecoration(
              hintText: 'Enter when Tim starts',
              labelText: "When Tim starts?"
            ),
            validator: (value) {
              return null;
            },
            onSaved: (val) {
              setState(() {
                _tim.when = DateTime.now().add(new Duration(minutes: val));
              });
            },
          ),
          MyDropdownButtonFormField(
            items: [
              DropdownMenuItem(child: Text("\$1 per min"), value: 1,),
              DropdownMenuItem(child: Text("\$2 per min"), value: 2,),
              DropdownMenuItem(child: Text("\$5 per min"), value: 5,)
            ],
            decoration: const InputDecoration(
              hintText: 'Per min late fee',
              labelText: "What is the penalty?"
            ),
            validator: (value) {
              return null;
            },
            onSaved: (val) {
              setState(() {
                _tim.penalty = val;
              });
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: RaisedButton.icon(
              onPressed: () {
                // Validate will return true if the form is valid, or false if
                // the form is invalid.
                if (_formKey.currentState.validate()) {
                  _formKey.currentState.save();
                 _createTim();
                }
              },
              icon: Icon(Icons.add_alert),
              label: Text('Create'),
            ),
          ),
        ],
      ),
    );
  }

  void _createTim(){
    _tim.contacts = contacts;
    _tim.save();
    goHome();
  }
}

class TimCard extends StatefulWidget {
  Tim tim;
  TimCard(this.tim);
  @override
  _TimCardState createState() => new _TimCardState(this.tim);
}

class _TimCardState extends State<TimCard> {
  Tim tim;
  _TimCardState(this.tim);

  @override
  Widget build(BuildContext context) {
    return _mainWidget();
  }

  Widget _mainWidget() {
    List<Widget> items = new List();
    items.add(ListTile(
      leading: Icon(Icons.album),
      title: Text(this.tim.title),
      subtitle: Text(this.tim.when.toIso8601String()),
    ));
    tim.contacts.forEach((c) => items.add(Text(c.toString()+"\n")));
    items.add(ButtonBar(
      children: <Widget>[
        FlatButton(
          child: const Text('Reject'),
          onPressed: () { /* ... */ },
        ),
        FlatButton(
          child: const Text('Accept'),
          onPressed: () { /* ... */ },
        ),
      ],
    ));
    return Center(
      child: Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: items
        ),
      ),
    );
  }
}