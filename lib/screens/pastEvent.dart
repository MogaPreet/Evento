import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_password_login/admin/dummy.dart';
import 'package:email_password_login/admin/eventDetail.dart';

import 'package:email_password_login/models/user_model.dart';
import 'package:email_password_login/screens/Profile.dart';
import 'package:email_password_login/widgets/eventContainer.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';

import 'login_screen.dart';

class PastAllEvent extends StatefulWidget {
  const PastAllEvent({Key? key}) : super(key: key);

  @override
  _PastAllEventState createState() => _PastAllEventState();
}

class _PastAllEventState extends State<PastAllEvent> {
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();

  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .get()
        .then((value) {
      loggedInUser = UserModel.fromMap(value.data());
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    var now = new DateTime.now();

    var formatter = new DateFormat('dd/MM/yyyy');
    String formattedDate = formatter.format(now);

    String greeting() {
      var hour = DateTime.now().hour;
      if (hour < 12) {
        return 'Good Morning,';
      }
      if (hour < 17) {
        return 'Good Afternoon,';
      }
      return 'Good Evening,';
    }

    return SafeArea(
      child: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: ((overscroll) {
          overscroll.disallowIndicator();
          return true;
        }),
        child: Scaffold(
          backgroundColor: Colors.white,
          body: ListView(
            children: [
              Container(
                height: 200,
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/pastevent.png'),
                    fit: BoxFit.fill,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              greeting(),
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                            Text(
                              "${loggedInUser.firstName}",
                              style: TextStyle(
                                fontSize: 25,
                                color: Colors.white,
                              ),
                            )
                          ],
                        ),
                        GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ProfileScreen(
                                      FirstName: loggedInUser.firstName),
                                ),
                              );
                            },
                            child: CircleAvatar(
                              radius: 20,
                              child: Icon(Icons.person),
                            ))
                      ],
                    ),
                    Text(
                      "Past Events",
                      style: TextStyle(color: Colors.white),
                    )
                  ],
                ),
              ),
              SizedBox(height: 15),
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Column(children: [
                  SizedBox(height: 10),
                  Container(
                    child: StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection("events")
                            .where("eventEndDate", isLessThan: formattedDate)
                            .snapshots(),
                        builder:
                            (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (snapshot.hasError) {
                            return Text('Something went wrong');
                          } else if (snapshot.hasData ||
                              snapshot.data != null) {
                            return SingleChildScrollView(
                              physics: ScrollPhysics(),
                              child: ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: snapshot.data!.docs.length,
                                itemBuilder: (BuildContext context, int index) {
                                  final DocumentSnapshot documentSnapshot =
                                      snapshot.data!.docs[index];
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        margin:
                                            EdgeInsets.only(right: 15, top: 10),
                                        child: Stack(
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            detailPage(
                                                                documentSnapshot:
                                                                    documentSnapshot)));
                                              },
                                              child: ShaderMask(
                                                shaderCallback: (rectangle) {
                                                  return LinearGradient(
                                                          colors: [
                                                        Colors.grey.shade800,
                                                        Colors.transparent,
                                                      ],
                                                          begin: Alignment
                                                              .bottomCenter,
                                                          end: Alignment
                                                              .topCenter)
                                                      .createShader(
                                                          Rect.fromLTRB(
                                                              0,
                                                              0,
                                                              rectangle.width,
                                                              rectangle
                                                                  .height));
                                                },
                                                blendMode: BlendMode.darken,
                                                child: Container(
                                                  height: 210,
                                                  width: 320,
                                                  decoration: BoxDecoration(
                                                    image: DecorationImage(
                                                      fit: BoxFit.cover,
                                                      image: NetworkImage(
                                                          documentSnapshot[
                                                              'url']),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Positioned(
                                                right: 10,
                                                left: 10,
                                                bottom: 10,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      (documentSnapshot[
                                                                  "eventFees"] ==
                                                              "0")
                                                          ? "Free"
                                                          : "???" +
                                                              " " +
                                                              documentSnapshot[
                                                                  "eventFees"],
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 18,
                                                      ),
                                                    ),
                                                    Text(
                                                      documentSnapshot[
                                                          "eventCategory"],
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 18),
                                                    )
                                                  ],
                                                ))
                                          ],
                                        ),
                                      ),
                                      SizedBox(height: 10),
                                      Text(
                                        documentSnapshot["eventName"],
                                        style: TextStyle(
                                          fontSize: 23,
                                          wordSpacing: 1,
                                        ),
                                      ),
                                      SizedBox(height: 2),
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.location_on_outlined,
                                            size: 15,
                                          ),
                                          Text(
                                            documentSnapshot["eventCollege"],
                                            style: TextStyle(
                                              decoration:
                                                  TextDecoration.underline,
                                              fontSize: 11,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 40),
                                    ],
                                  );
                                },
                              ),
                            );
                          }
                          return const Center(
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.black,
                              ),
                            ),
                          );
                        }),
                  ),
                ]),
              )
            ],
          ),
        ),
      ),
    );
  }

  // the logout function
  Future<void> logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LoginScreen()));
  }
}
