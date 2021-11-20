import 'package:flutter/material.dart';
import 'AddContact.dart';
import 'ViewContact.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DatabaseReference _databaseReference = FirebaseDatabase.instance.reference();

  navigateToAddContact() {
    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
      print("Going to add contact");
      return AddContact();
    }));
  }

  navigateToViewContact(String id) {
    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
      // Todo : pass id to ViewContact
      return ViewContact(id);
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home Page"),
      ),
      body: Container(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: FirebaseAnimatedList(
            query: _databaseReference,
            itemBuilder: (BuildContext context, DataSnapshot snapshot,
                Animation<double> animation, int index) {
              return GestureDetector(
                onTap: () {
                  navigateToViewContact(snapshot.key);
                },
                child: Card(
                  color: Colors.white,
                  child: Container(
                    margin: EdgeInsets.all(10.0),
                    child: Row(
                      children: <Widget>[
                        Container(
                          width: 50.0,
                          height: 50.0,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            // border: Border.all(
                            //   width: 0.5,
                            //   color: Colors.grey,
                            // ),
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: snapshot.value["photoUrl"] == "empty"
                                  ? AssetImage("assets/logo.png")
                                  : NetworkImage(
                                      snapshot.value["photoUrl"],
                                    ),
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.all(10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                "${snapshot.value['firstName']} ${snapshot.value['lastName']}",
                                style: TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                "${snapshot.value['phone']}",
                                style: TextStyle(
                                  fontSize: 15.0,
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: navigateToAddContact,
      ),
    );
  }
}
