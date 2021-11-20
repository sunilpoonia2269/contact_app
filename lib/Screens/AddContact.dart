import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:io';
import '../model/ContactModel.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';

class AddContact extends StatefulWidget {
  @override
  _AddContactState createState() => _AddContactState();
}

class _AddContactState extends State<AddContact> {
  DatabaseReference _databaseReference = FirebaseDatabase.instance.reference();

  String _firstName = "";
  String _lastName = "";
  String _phone = "";
  String _email = "";
  String _address = "";
  String _photoUrl = "empty";

  saveContact(BuildContext context) async {
    if (_firstName.isNotEmpty &&
        _lastName.isNotEmpty &&
        _phone.isNotEmpty &&
        _email.isNotEmpty &&
        _address.isNotEmpty &&
        _photoUrl.isNotEmpty) {
      Contact contact = Contact(this._firstName, this._lastName, this._phone,
          this._email, this._address, this._photoUrl);

      await _databaseReference.push().set(contact.toJson());

      navigateToLastScreen(context);
    } else {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Field Required"),
              content: Text("All Fields are required"),
              actions: <Widget>[
                FlatButton(
                  child: Text("Close"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            );
          });
    }
  }

  navigateToLastScreen(BuildContext context) {
    Navigator.of(context).pop();
  }

  Future pickImage() async {
    PickedFile pickedFile = await ImagePicker().getImage(
        source: ImageSource.gallery, maxHeight: 200.0, maxWidth: 200.0);
    print(pickedFile);
    File file = File(pickedFile.path);

    String fileName = basename(file.path);
    uploadImage(file, fileName);
  }

  uploadImage(File file, String fileName) async {
    StorageReference _storageReference =
        FirebaseStorage.instance.ref().child(fileName);
    _storageReference.putFile(file).onComplete.then((firebaseFile) async {
      var downloadUrl = await firebaseFile.ref.getDownloadURL();

      setState(() {
        _photoUrl = downloadUrl;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Contact"),
      ),
      body: Container(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: ListView(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: 20.0),
                child: GestureDetector(
                  onTap: () {
                    this.pickImage();
                  },
                  child: Center(
                    child: Container(
                      width: 100.0,
                      height: 100.0,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: _photoUrl == "empty"
                              ? AssetImage("assets/logo.png")
                              : NetworkImage(_photoUrl),
                          fit: BoxFit.cover,
                        ),
                        border: Border.all(
                          color: Colors.grey,
                          width: 2.0,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // First Name TextField
              Container(
                margin: EdgeInsets.only(top: 20.0),
                child: TextField(
                  style: TextStyle(fontSize: 17.0),
                  onChanged: (value) {
                    setState(() {
                      _firstName = value;
                    });
                  },
                  decoration: InputDecoration(
                    labelText: "First Name",
                    labelStyle: TextStyle(
                      fontSize: 15.0,
                    ),
                    hintText: "Enter First Name",
                    contentPadding: EdgeInsets.all(15.0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
              ),
              // Last Name TextField
              Container(
                margin: EdgeInsets.only(top: 20.0),
                child: TextField(
                  style: TextStyle(fontSize: 17.0),
                  onChanged: (value) {
                    setState(() {
                      _lastName = value;
                    });
                  },
                  decoration: InputDecoration(
                    labelText: "Last Name",
                    labelStyle: TextStyle(
                      fontSize: 15.0,
                    ),
                    hintText: "Enter Last Name",
                    contentPadding: EdgeInsets.all(15.0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
              ),

              // Phone

              Container(
                margin: EdgeInsets.only(top: 20.0),
                child: TextField(
                  style: TextStyle(fontSize: 17.0),
                  onChanged: (value) {
                    setState(() {
                      _phone = value;
                    });
                  },
                  decoration: InputDecoration(
                    labelText: "Mobile No.",
                    labelStyle: TextStyle(
                      fontSize: 15.0,
                    ),
                    hintText: "Enter Mobile No.",
                    contentPadding: EdgeInsets.all(5.0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
              ),

              // Email Address

              Container(
                margin: EdgeInsets.only(top: 20.0),
                child: TextField(
                  style: TextStyle(fontSize: 17.0),
                  onChanged: (value) {
                    setState(() {
                      _email = value;
                    });
                  },
                  decoration: InputDecoration(
                    labelText: "Email",
                    labelStyle: TextStyle(
                      fontSize: 15.0,
                    ),
                    hintText: "Enter Email",
                    contentPadding: EdgeInsets.all(5.0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
              ),

              // Address
              Container(
                margin: EdgeInsets.only(top: 20.0),
                child: TextField(
                  style: TextStyle(fontSize: 20.0),
                  onChanged: (value) {
                    setState(() {
                      _address = value;
                    });
                  },
                  decoration: InputDecoration(
                    labelText: "Address",
                    labelStyle: TextStyle(
                      fontSize: 15.0,
                    ),
                    hintText: "Enter Address",
                    contentPadding: EdgeInsets.all(5.0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
              ),
              // Save Button
              Container(
                padding: EdgeInsets.only(top: 30.0),
                child: RaisedButton(
                  padding: EdgeInsets.fromLTRB(100, 20, 100, 20),
                  onPressed: () {
                    saveContact(context);
                  },
                  color: Colors.lightGreen,
                  child: Text(
                    "Save",
                    style: TextStyle(fontSize: 20.0, color: Colors.white),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
