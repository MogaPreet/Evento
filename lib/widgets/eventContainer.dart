import 'package:email_password_login/admin/eventDetail.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/rendering.dart';

class eventContainer extends StatefulWidget {
  const eventContainer({Key? key}) : super(key: key);

  @override
  State<eventContainer> createState() => _eventContainerState();
}

class _eventContainerState extends State<eventContainer> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("events")
            .orderBy("eventCreatedAt", descending: true)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          } else if (snapshot.hasData || snapshot.data != null) {
            return ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (BuildContext context, int index) {
                  final DocumentSnapshot documentSnapshot =
                      snapshot.data!.docs[index];
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(right: 15),
                        child: Stack(
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => detailPage(
                                        documentSnapshot: documentSnapshot)));
                              },
                              child: Container(
                                height: 210,
                                width: 320,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image:
                                        NetworkImage(documentSnapshot['url']),
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
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      documentSnapshot["eventFees"],
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                      ),
                                    ),
                                    Text(
                                      documentSnapshot["eventCategory"],
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 18),
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
                              decoration: TextDecoration.underline,
                              fontSize: 11,
                            ),
                          ),
                          SizedBox(width: 20),
                          Text(
                            '112 available',
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey,
                            ),
                          )
                        ],
                      )
                    ],
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
        });
  }
}
