import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_password_login/models/event_models.dart';
import 'package:email_password_login/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class detailPage extends StatefulWidget {
  final DocumentSnapshot documentSnapshot;

  const detailPage({Key? key, required this.documentSnapshot})
      : super(key: key);

  @override
  State<detailPage> createState() => _detailPageState();
}

class _detailPageState extends State<detailPage> {
  UserModel allUser = UserModel();
  @override
  void initState() {
    User? user = FirebaseAuth.instance.currentUser;
    super.initState();
    FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .get()
        .then((value) {
      allUser = UserModel.fromMap(value.data());
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: NotificationListener<OverscrollIndicatorNotification>(
          onNotification: ((overscroll) {
            overscroll.disallowIndicator();
            return true;
          }),
          child: ListView(
            children: [
              Container(
                transform: Matrix4.translationValues(0, -20, 0),
                child: Stack(
                  children: [
                    ShaderMask(
                      shaderCallback: (rectangle) {
                        return LinearGradient(
                                colors: [
                              Colors.black,
                              Colors.transparent,
                            ],
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter)
                            .createShader(Rect.fromLTRB(
                                0, 0, rectangle.width, rectangle.height));
                      },
                      blendMode: BlendMode.darken,
                      child: Container(
                        height: MediaQuery.of(context).size.height / 2,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage(widget.documentSnapshot["url"]),
                        )),
                      ),
                    ),
                    Positioned(
                      right: 10,
                      left: 10,
                      top: 30,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          IconButton(
                            icon: Icon(
                              Icons.keyboard_backspace,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                          CircleAvatar(
                            radius: 32,
                            backgroundColor: Colors.black,
                            child: Text(
                              widget.documentSnapshot["eventCollege"],
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            ),
                          ),
                          Text("HI, ${allUser.firstName}",
                              style: const TextStyle(
                                color: Colors.black54,
                                fontWeight: FontWeight.w500,
                              )),
                        ],
                      ),
                    ),
                    Positioned(
                      left: 10,
                      right: 10,
                      bottom: 20,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.documentSnapshot["eventName"],
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 35,
                            ),
                          ),
                          SizedBox(height: 10),
                          Row(
                            children: [
                              Icon(
                                Icons.category_rounded,
                                color: Colors.white,
                              ),
                              SizedBox(
                                width: 7,
                              ),
                              Text(
                                widget.documentSnapshot["eventCategory"],
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.location_on_outlined,
                              size: 15,
                            ),
                            Text(
                              widget.documentSnapshot["eventLocation"],
                              style: TextStyle(
                                decoration: TextDecoration.underline,
                                fontSize: 15,
                              ),
                            )
                          ],
                        ),
                        Text(
                          widget.documentSnapshot["eventDate"],
                          style: TextStyle(
                            fontSize: 15,
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 20),
                    SizedBox(height: 20),
                    Container(
                      height: 50,
                      width: MediaQuery.of(context).size.width,
                      child: Material(
                        color: Colors.black,
                        child: MaterialButton(
                          child: Text(
                            'Woww',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                            ),
                          ),
                          onPressed: () {},
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      'About',
                      style: TextStyle(
                        fontSize: 30,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      widget.documentSnapshot["eventDescription"],
                      style: TextStyle(
                        fontSize: 15,
                      ),
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
