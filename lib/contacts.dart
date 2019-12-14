import 'package:flutter/material.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:permission_handler/permission_handler.dart';

import 'utils.dart';


Future<List<ContactPhone>> fetchContacts() async {

  Map<PermissionGroup, PermissionStatus> permissions = await PermissionHandler().requestPermissions([PermissionGroup.contacts]);
  Iterable<Contact> contacts;
  List<ContactPhone> phones = new List();
  try {
    contacts = await ContactsService.getContacts(withThumbnails: false);
    contacts.forEach((contact) =>
        contact.phones.forEach((phone) => phones.add(ContactPhone(phone: phone, contact: contact)))
    );
  }catch(exception, stackTrace) {
    // app crashes doesn't reach here
    print(exception);
    print(stackTrace);
  }
  return phones;
}

class ContactListWidget extends StatefulWidget {
  String nextName;
  Function nextFunc;
  @override
  ContactListWidget(this.nextName, this.nextFunc);
  _contactListWidgetState createState() => new _contactListWidgetState(nextName, nextFunc);
}

class _contactListWidgetState extends State<ContactListWidget> {
  List<ContactPhone> _contacts;
  List<int> selected = new List();
  String nextName;
  Function nextFunc;

  _contactListWidgetState(this.nextName, this.nextFunc);

  @override
  Widget build(BuildContext context) {
    return _mainWidget();
  }

  Widget _mainWidget(){
    return Scaffold(
      appBar:  AppBar(
        title:  Text.rich(
          TextSpan(
            text: 'Select Contacts', // default text style
            children: <TextSpan>[
              TextSpan(text: '\n5 contacts', style: TextStyle(fontSize: 15)),
            ],
          ),
        ),
        actions: [
          FlatButton.icon(
            color: Colors.green,
            onPressed: (){
                //get selected contacts
                List<ContactPhone> contacts = new List();
                selected.forEach((i)=>contacts.add(_contacts[i]));
                this.nextFunc(contacts);
              },
            padding: EdgeInsets.all(8.0),
            splashColor: Colors.greenAccent,
            icon: Icon(Icons.add_alert),
            label: Text(this.nextName))
      ]
      ),
      body: Center(
        child: FutureBuilder<List<ContactPhone>>(
          future: fetchContacts(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              _contacts = snapshot.data;
              return _buildList();
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }

            // By default, show a loading spinner
            return CircularProgressIndicator();
          },
        ),
      ),
    );

  }

  Widget _buildList() {
    return ListView.builder(
      //padding: const EdgeInsets.all(16.0),
        itemCount: _contacts.length,
        /*separatorBuilder: (context, index) => Divider(
          color: Colors.black,
        ),*/
        itemBuilder: (context, i) {
          return ContactWidget(
              index: i,
              phone: _contacts.elementAt(i),
              selected: _selected,
              isSelected: _isSelected
          );
        });
  }

  void _selected(int index){
    setState(() {
      if (selected.contains(index)) {
        selected.remove(index);
      } else {
        selected.add(index);
      }
    });

  }
  bool _isSelected(int index) => selected.contains(index);

}

class ContactWidget extends StatefulWidget {
  final int index;
  final ContactPhone phone;
  final void Function(int) selected;
  final bool Function(int) isSelected;

  const ContactWidget({Key key, this.index, this.phone, this.selected, this.isSelected}) : super(key: key);

  @override
  _ContactWidgetState createState() => new _ContactWidgetState();
}

class _ContactWidgetState extends State<ContactWidget> {

  final _nameStyle = const TextStyle(fontSize: 18.0,
      fontWeight: FontWeight.bold,
      color: Colors.black
  );

  @override
  Widget build(BuildContext context) {
    return  Container(
      child: _mainWidget(),
      decoration: widget.isSelected(widget.index)
          ? new BoxDecoration(color: Colors.blue[50])
          : new BoxDecoration(),
    );
  }

  Widget _mainWidget(){
    return ListTile(
      leading: widget.isSelected(widget.index) ? Icon(Icons.check_circle_outline): Icon(Icons.phone),
      title: Text(
        cap(widget.phone.contact.givenName)+' '+cap(widget.phone.contact.familyName),
        style: _nameStyle,
      ),
      subtitle: Text.rich(
        TextSpan(
          text: cap(widget.phone.phone.label)+' ', // default text style
          children: <TextSpan>[
            TextSpan(text: widget.phone.phone.value, style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
      trailing: Icon(Icons.more_vert),
      onLongPress: () {
        widget.selected(widget.index);
        //empty set state to update ui
        // but it doesn't work so setting state in parent
        setState(() {});
      },
      onTap: () {
        widget.selected(widget.index);
      },
    );
  }
}