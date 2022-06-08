import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_password_login/models/event_models.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Dummy extends StatefulWidget {
  const Dummy({Key? key}) : super(key: key);

  @override
  State<Dummy> createState() => _DummyState();
}

class _DummyState extends State<Dummy> {
  EventModel displayEvents = EventModel();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My events"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection("events").snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          } else if (snapshot.hasData || snapshot.data != null) {
            return ListView.builder(
                shrinkWrap: true,
                itemCount: snapshot.data?.docs.length,
                itemBuilder: (BuildContext context, int index) {
                  QueryDocumentSnapshot<Object?>? documentSnapshot =
                      snapshot.data?.docs[index];
                  return Dismissible(
                      key: Key(index.toString()),
                      child: Card(
                        elevation: 4,
                        child: ListTile(
                            title: Text((documentSnapshot != null)
                                ? (documentSnapshot["eventName"])
                                : ""),
                            subtitle: Text((documentSnapshot != null)
                                ? ((documentSnapshot["eventDescription"] !=
                                        null)
                                    ? documentSnapshot["eventDescription"]
                                    : "")
                                : ""),
                            trailing: Image.network((documentSnapshot != null)
                                ? (documentSnapshot['url'])
                                : "")),
                      ));
                });
          }
          return const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                Colors.red,
              ),
            ),
          );
        },
      ),
      floatingActionButton: const Icon(
        Icons.add,
        color: Colors.white,
      ),
    );
  }
}
