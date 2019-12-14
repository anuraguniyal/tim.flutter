import 'package:flutter/material.dart';
import 'package:contacts_service/contacts_service.dart';
import 'home.dart';

String cap(String s) {
  if(s == null) return "";
  return s[0].toUpperCase() + s.substring(1);
}

class ContactPhone{
  final Item phone;
  final Contact contact;
  ContactPhone({this.phone, this.contact});
  String toString(){
    return contact.displayName+" "+phone.value;
  }
}

/// copied from dart codebase as current DropdownButtonFormField doesn't select any value
/// A convenience widget that wraps a [DropdownButton] in a [FormField].
class MyDropdownButtonFormField<T> extends FormField<T> {
  /// Creates a [DropdownButton] widget wrapped in an [InputDecorator] and
  /// [FormField].
  ///
  /// The [DropdownButton] [items] parameters must not be null.
  MyDropdownButtonFormField({
    Key key,
    T initialValue,
    @required List<DropdownMenuItem<T>> items,
    InputDecoration decoration = const InputDecoration(),
    FormFieldSetter<T> onSaved,
    FormFieldValidator<T> validator,
    Widget hint,
  }) : assert(decoration != null),
        super(
          key: key,
          onSaved: onSaved,
          initialValue: initialValue,
          validator: validator,
          builder: (FormFieldState<T> field) {
            final InputDecoration effectiveDecoration = decoration
                .applyDefaults(Theme.of(field.context).inputDecorationTheme);
            return InputDecorator(
              decoration: effectiveDecoration.copyWith(errorText: field.errorText),
              isEmpty: field.value == null,
              child: DropdownButtonHideUnderline(
                child: DropdownButton<T>(
                  isDense: true,
                  value:field.value,
                  items: items,
                  hint: hint,
                  onChanged: field.didChange,
                ),
              ),
            );
          }
      );

  @override
  FormFieldState<T> createState() => FormFieldState<T>();
}

List<Tim> allTim = List();

class Tim {
  List<ContactPhone> contacts;
  String title;
  DateTime when;// when the tim starts
  int penalty=1;//$ per min
  void save() {
    print('saving tim $title @ \$$penalty ');
    allTim.add(this);
  }
}

void goHome(){
  MaterialPageRoute(builder: (context) => HomeWidget());
}