import 'package:firebase_database/firebase_database.dart';

class Contact {
  String _id;
  String _firstName;
  String _lastName;
  String _phone;
  String _email;
  String _address;
  String _photoUrl;

  // Constructure for add contact
  Contact(this._firstName, this._lastName, this._phone, this._email,
      this._address, this._photoUrl);

  // Constructure for edit contact
  Contact.withId(this._id, this._firstName, this._lastName, this._phone,
      this._email, this._address, this._photoUrl);

  // getters

  String get id => _id;
  String get firstName => _firstName;
  String get lastName => _lastName;
  String get phone => _phone;
  String get email => _email;
  String get address => _address;
  String get photoUrl => _photoUrl;

  // setters

  set firstName(String firstName) {
    this._firstName = firstName;
  }

  set lastName(String lastName) {
    this._lastName = lastName;
  }

  set phone(String phone) {
    this._phone = phone;
  }

  set email(String email) {
    this._email = email;
  }

  set address(String address) {
    this._address = address;
  }

  set photoUrl(String photoUrl) {
    this._photoUrl = photoUrl;
  }

  Contact.fromSnapshot(DataSnapshot snapshot) {
    this._id = snapshot.key;
    this._firstName = snapshot.value["firstName"];
    this._lastName = snapshot.value["lastName"];
    this._phone = snapshot.value["phone"];
    this._email = snapshot.value["email"];
    this._address = snapshot.value["address"];
    this._photoUrl = snapshot.value["photoUrl"];
  }

  Map<String, dynamic> toJson() {
    return {
      "firstName": _firstName,
      "lastName": _lastName,
      "phone": _phone,
      "email": _email,
      "address": _address,
      "photoUrl": _photoUrl,
    };
  }
}
