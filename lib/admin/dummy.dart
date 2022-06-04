import 'package:flutter/material.dart';

class Dummy extends StatefulWidget {
  const Dummy({Key? key}) : super(key: key);

  @override
  State<Dummy> createState() => _DummyState();
}

class _DummyState extends State<Dummy> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Only dummy"),
      ),
      body: Container(
        child: Column(
          children: [
            SizedBox(
              height: 20.0,
            ),
            Text("Hi ")
          ],
        ),
      ),
    );
  }
}
