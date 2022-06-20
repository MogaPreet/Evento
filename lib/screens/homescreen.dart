import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_password_login/admin/dummy.dart';
import 'package:email_password_login/admin/eventDetail.dart';

import 'package:email_password_login/models/user_model.dart';
import 'package:email_password_login/screens/allEvent.dart';
import 'package:email_password_login/screens/chat/charMain.dart';
import 'package:email_password_login/screens/chat/login.dart';
import 'package:email_password_login/screens/home.dart';
import 'package:email_password_login/screens/pastEvent.dart';
import 'package:email_password_login/widgets/eventContainer.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'login_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();

  int pageIndex = 0;

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

  final pages = [
    const HomeScreen(),
    const AllEvent(),
    const PastAllEvent(),
    const chatpage(),
  ];

  @override
  Widget build(BuildContext context) {
    var now = new DateTime.now();
    var thisweek = now.add(Duration(days: now.weekday));

    var formatter = new DateFormat('dd/MM/yyyy');
    String formattedDate = formatter.format(now);
    String thisWeek = formatter.format(thisweek);
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

    Container buildMyNavBar(BuildContext context) {
      return Container(
        height: 60,
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              enableFeedback: false,
              onPressed: () {
                setState(() {
                  pageIndex = 0;
                });
              },
              icon: pageIndex == 0
                  ? const Icon(
                      Icons.home_filled,
                      color: Colors.black,
                      size: 35,
                    )
                  : const Icon(
                      Icons.home_outlined,
                      color: Colors.black,
                      size: 35,
                    ),
            ),
            IconButton(
              enableFeedback: false,
              onPressed: () {
                setState(() {
                  pageIndex = 1;
                });
              },
              icon: pageIndex == 1
                  ? const Icon(
                      Icons.event,
                      color: Colors.black,
                      size: 35,
                    )
                  : const Icon(
                      Icons.event_outlined,
                      color: Colors.black,
                      size: 35,
                    ),
            ),
            IconButton(
              enableFeedback: false,
              onPressed: () {
                setState(() {
                  pageIndex = 2;
                });
              },
              icon: pageIndex == 2
                  ? const Icon(
                      Icons.book,
                      color: Colors.black,
                      size: 35,
                    )
                  : const Icon(
                      Icons.book_outlined,
                      color: Colors.black,
                      size: 35,
                    ),
            ),
            IconButton(
              enableFeedback: false,
              onPressed: () {
                setState(() {
                  pageIndex = 3;
                });
              },
              icon: pageIndex == 3
                  ? const Icon(
                      Icons.chat_bubble_outline,
                      color: Colors.black,
                      size: 35,
                    )
                  : const Icon(
                      Icons.chat_bubble_outline,
                      color: Colors.black,
                      size: 35,
                    ),
            ),
          ],
        ),
      );
    }

    return NotificationListener<OverscrollIndicatorNotification>(
      onNotification: ((overscroll) {
        overscroll.disallowIndicator();
        return true;
      }),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: pages[pageIndex],
        bottomNavigationBar: buildMyNavBar(context),
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
