import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_password_login/admin/event_form.dart';

import 'package:email_password_login/models/event_models.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Dummy extends StatefulWidget {
  const Dummy({Key? key}) : super(key: key);

  @override
  State<Dummy> createState() => _DummyState();
}

class _DummyState extends State<Dummy> {
  EventModel displayEvents = EventModel();

  delteEvent(item) {
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection("events").doc(item);
    documentReference.delete().whenComplete(
        () => Fluttertoast.showToast(msg: 'Delted event SuccessFully'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.0,
        centerTitle: true,
        foregroundColor: Colors.black,
        backgroundColor: Colors.white,
        title: Text(
          "My events",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        child: NotificationListener<OverscrollIndicatorNotification>(
          onNotification: ((overscroll) {
            overscroll.disallowIndicator();
            return true;
          }),
          child: StreamBuilder<QuerySnapshot>(
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

                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.black,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(0),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black,
                                  offset: Offset(
                                    0.0,
                                    0.0,
                                  ),
                                  blurRadius: 0.0,
                                  spreadRadius: 0.0,
                                ),
                                BoxShadow(
                                  color: Colors.white,
                                  offset: const Offset(0.0, 0.0),
                                  blurRadius: 0.0,
                                  spreadRadius: 0.0,
                                ),
                              ]),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: ListTile(
                              leading: Container(
                                width: 100,
                                height: 100,
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: NetworkImage(
                                            (documentSnapshot != null)
                                                ? (documentSnapshot['url'])
                                                : Icon(Icons.event)),
                                        fit: BoxFit.cover),
                                    border: Border.all(
                                      color: Colors.black,
                                      width: 1,
                                    ),
                                    borderRadius: BorderRadius.circular(2),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black,
                                        offset: Offset(
                                          0.0,
                                          0.0,
                                        ),
                                        blurRadius: 0.0,
                                        spreadRadius: 0.0,
                                      ),
                                      BoxShadow(
                                        color: Colors.white,
                                        offset: const Offset(0.0, 0.0),
                                        blurRadius: 0.0,
                                        spreadRadius: 0.0,
                                      ),
                                    ]),
                              ),
                              title: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 6),
                                child: Text(
                                  (documentSnapshot != null)
                                      ? ((documentSnapshot["eventName"]))
                                      : "",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              subtitle: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 2),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text((documentSnapshot != null)
                                        ? ((documentSnapshot["eventCollege"] !=
                                                null)
                                            ? documentSnapshot["eventCollege"]
                                            : "")
                                        : ""),
                                    Text((documentSnapshot != null)
                                        ? ((documentSnapshot["eventCategory"] !=
                                                null)
                                            ? documentSnapshot["eventCategory"]
                                            : "")
                                        : ""),
                                  ],
                                ),
                              ),
                              trailing: IconButton(
                                icon: Icon(Icons.delete),
                                color: Colors.red,
                                onPressed: () {
                                  setState(() {
                                    delteEvent((documentSnapshot != null)
                                        ? (documentSnapshot['eventName'])
                                        : "");
                                  });
                                  setState(() {});
                                },
                              ),
                            ),
                          ),
                        ),
                      );
                    });
              }
              return const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Colors.black,
                  ),
                ),
              );
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        elevation: 0,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const createEvent()),
          );
        },
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        label:
            Text("Create event", style: TextStyle(fontWeight: FontWeight.bold)),
        icon: Icon(Icons.add),
      ),
    );
  }
}
