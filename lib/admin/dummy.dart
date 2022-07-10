import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_password_login/admin/eventDetail.dart';
import 'package:email_password_login/admin/event_form.dart';
import 'package:email_password_login/admin/users.dart';

import 'package:email_password_login/models/event_models.dart';
import 'package:email_password_login/widgets/eventContainer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class Dummy extends StatefulWidget {
  const Dummy({Key? key}) : super(key: key);

  @override
  State<Dummy> createState() => _DummyState();
}

class _DummyState extends State<Dummy> {
  EventModel displayEvents = EventModel();

  delteEvent(event) {
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection("events").doc(event);
    documentReference.delete().whenComplete(
        () => Fluttertoast.showToast(msg: 'Delted event SuccessFully'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.people_sharp),
            tooltip: 'Show Users',
            onPressed: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => Users()));
            },
          ),
          IconButton(
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => eventContainer()));
              },
              icon: Icon(Icons.view_agenda_rounded))
        ],
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
          child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection("events")
                .orderBy("eventCreatedAt", descending: true)
                .snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return Text('Something went wrong');
              } else if (snapshot.hasData || snapshot.data != null) {
                return ListView.builder(
                    shrinkWrap: true,
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (BuildContext context, int index) {
                      final DocumentSnapshot documentSnapshot =
                          snapshot.data!.docs[index];

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
                            child: GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => detailPage(
                                        documentSnapshot: documentSnapshot)));
                              },
                              child: ListTile(
                                leading: Container(
                                  width: 100,
                                  height: 100,
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image: NetworkImage(
                                              (documentSnapshot != null)
                                                  ? (documentSnapshot['url'])
                                                  : CircularProgressIndicator(
                                                      color: Colors.black,
                                                    )),
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
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                                subtitle: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 2),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text((documentSnapshot != null)
                                          ? ((documentSnapshot[
                                                      "eventCollege"] !=
                                                  null)
                                              ? documentSnapshot["eventCollege"]
                                              : "")
                                          : ""),
                                      Text((documentSnapshot != null)
                                          ? ((documentSnapshot[
                                                      "eventCategory"] !=
                                                  null)
                                              ? documentSnapshot[
                                                  "eventCategory"]
                                              : "")
                                          : ""),
                                    ],
                                  ),
                                ),
                                trailing: Column(
                                  children: [
                                    IconButton(
                                      icon: Icon(Icons.notification_add),
                                      color: Colors.blue,
                                      onPressed: () {
                                        setState(() {});
                                        setState(() {});
                                      },
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.delete),
                                      color: Colors.red,
                                      onPressed: () {
                                        setState(() {
                                          delteEvent((documentSnapshot != null)
                                              ? (documentSnapshot['id'])
                                              : "");
                                        });
                                        setState(() {});
                                      },
                                    ),
                                  ],
                                ),
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
