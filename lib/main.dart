import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:permission_handler/permission_handler.dart';

String _C(String s) {
  if(s == null) return "";
  return s[0].toUpperCase() + s.substring(1);
}

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Welcome to Flutter',
      home: ContactListWidget());
  }
}


class ContactPhone{
  final Item phone;
  final Contact contact;
  ContactPhone({this.phone, this.contact});
}

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
  @override
  _ContactListWidgetState createState() => new _ContactListWidgetState();
}

class _ContactListWidgetState extends State<ContactListWidget> {
  List<ContactPhone> _contacts;
  List<int> selected = new List();

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
              callback: _callback
          );
        });
  }

  void _callback(int index){
    if (selected.contains(index)) {
      selected.remove(index);
    } else {
      selected.add(index);
    }
  }

}

class ContactWidget extends StatefulWidget {
  final int index;
  final ContactPhone phone;
  final void Function(int) callback;

  const ContactWidget({Key key, this.index, this.phone, this.callback}) : super(key: key);

  @override
  _ContactWidgetState createState() => new _ContactWidgetState();
}

class _ContactWidgetState extends State<ContactWidget> {
  bool selected = false;
  final _nameStyle = const TextStyle(fontSize: 18.0,
      fontWeight: FontWeight.bold,
      color: Colors.black
  );

  @override
  Widget build(BuildContext context) {
    return  Container(
        child: _mainWidget(),
        decoration: selected
            ? new BoxDecoration(color: Colors.blue[50])
            : new BoxDecoration(),
      );
  }

  Widget _mainWidget(){
    return ListTile(
      leading: selected ? Icon(Icons.check_circle_outline): Icon(Icons.phone),
      title: Text(
        _C(widget.phone.contact.givenName)+' '+_C(widget.phone.contact.familyName),
        style: _nameStyle,
      ),
      subtitle: Text.rich(
        TextSpan(
          text: _C(widget.phone.phone.label)+' ', // default text style
          children: <TextSpan>[
            TextSpan(text: widget.phone.phone.value, style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
      trailing: Icon(Icons.more_vert),
      onLongPress: () {
        setState(() {
          selected = !selected;
        });
        widget.callback(widget.index);
      },
      onTap: () {
        setState(() {
          selected = !selected;
        });
        widget.callback(widget.index);
      },
    );
  }
}