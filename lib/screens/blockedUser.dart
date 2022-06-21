import 'package:flutter/material.dart';

class blockedUser extends StatefulWidget {
  const blockedUser({Key? key}) : super(key: key);

  @override
  State<blockedUser> createState() => _blockedUserState();
}

class _blockedUserState extends State<blockedUser> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Message from Evento"),
      ),
      body: Container(
        child: Center(
          child: Text("Blocked !!!"),
        ),
      ),
    );
  }
}
