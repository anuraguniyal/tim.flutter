import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:permission_handler/permission_handler.dart';

String _C(String s) => s[0].toUpperCase() + s.substring(1);

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Welcome to Flutter',
      home: ContactListWidget());
  }
}

class RandomWordsState extends State<RandomWords> {
  final _suggestions = <WordPair>[];
  final _biggerFont = const TextStyle(fontSize: 18.0);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Startup Name Generator'),
      ),
      body: _buildSuggestions(),
    );
  }

  Widget _buildSuggestions() {
    return ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemBuilder: /*1*/ (context, i) {
          if (i.isOdd) return Divider(); /*2*/

          final index = i ~/ 2; /*3*/
          if (index >= _suggestions.length) {
            _suggestions.addAll(generateWordPairs().take(10)); /*4*/
          }
          return _buildRow(_suggestions[index]);
        });
  }

  Widget _buildRow(WordPair pair) {
    return ListTile(
      title: Text(
        pair.asPascalCase,
        style: _biggerFont,
      ),
    );
  }
}

class RandomWords extends StatefulWidget {
  @override
  RandomWordsState createState() => RandomWordsState();
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
    contacts = await ContactsService.getContacts();
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

class ContactListWidget extends StatelessWidget {

  List<ContactPhone> _contacts;
  final _nameStyle = const TextStyle(fontSize: 18.0,
          fontWeight: FontWeight.bold,
          color: Colors.black
      );

  @override
  Widget build(BuildContext context) {
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
    return ListView.separated(
        //padding: const EdgeInsets.all(16.0),
        itemCount: _contacts.length,
        separatorBuilder: (context, index) => Divider(
          color: Colors.black,
        ),
        itemBuilder: (context, i) {
          return _buildRow(_contacts.elementAt(i));
        });
  }

  Widget _buildRow(ContactPhone phone) {
    return ListTile(
      leading: Icon(Icons.phone),
      title: Text(
        _C(phone.contact.givenName)+' '+_C(phone.contact.familyName),
        style: _nameStyle,
      ),
      subtitle: Text.rich(
        TextSpan(
          text: _C(phone.phone.label)+' ', // default text style
          children: <TextSpan>[
            TextSpan(text: phone.phone.value, style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
      trailing: Icon(Icons.more_vert),

    );
  }
}