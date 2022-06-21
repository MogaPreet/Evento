import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_password_login/admin/eventDetail.dart';
import 'package:email_password_login/admin/event_form.dart';

import 'package:email_password_login/models/event_models.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Users extends StatefulWidget {
  const Users({Key? key}) : super(key: key);

  @override
  State<Users> createState() => _UsersState();
}

class _UsersState extends State<Users> {
  EventModel displayEvents = EventModel();

  deleteUser(user) async {
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection("users").doc(user);
    documentReference.delete().whenComplete(
        () => Fluttertoast.showToast(msg: 'Delted User SuccessFully'));
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
          "Users",
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
            stream: FirebaseFirestore.instance.collection("users").snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return Text('Something went wrong');
              } else if (snapshot.hasData || snapshot.data != null) {
                return ListView.builder(
                    shrinkWrap: true,
                    itemCount: snapshot.data?.docs.length,
                    itemBuilder: (BuildContext context, int index) {
                      QueryDocumentSnapshot<Object?>? documentSnapshot =
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
                            child: ListTile(
                              title: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 6),
                                child: Text(
                                  (documentSnapshot != null)
                                      ? ((documentSnapshot["firstName"]))
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
                                        ? ((documentSnapshot["email"] != null)
                                            ? documentSnapshot["email"]
                                            : "")
                                        : ""),
                                    Text((documentSnapshot != null)
                                        ? ((documentSnapshot["lastName"] !=
                                                null)
                                            ? documentSnapshot["lastName"]
                                            : "")
                                        : ""),
                                  ],
                                ),
                              ),
                              trailing: IconButton(
                                icon: Icon(Icons.person_off_rounded),
                                color: Colors.red,
                                onPressed: () {
                                  setState(() {
                                    deleteUser((documentSnapshot != null)
                                        ? (documentSnapshot['uid'])
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
    );
  }
}
