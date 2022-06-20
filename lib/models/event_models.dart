import 'package:cloud_firestore/cloud_firestore.dart';

class EventModel {
  String? id;
  String? url;
  String? eventName;
  String? eventDescription;
  String? eventCollege;
  String? eventCategory;
  String? eventDate;
  String? eventEndDate;
  String? eventFees;
  String? eventLocation;
  String? eventCreatedAt;

  EventModel(
      {this.id,
      this.url,
      this.eventName,
      this.eventDescription,
      this.eventCollege,
      this.eventCategory,
      this.eventDate,
      this.eventEndDate,
      this.eventFees,
      this.eventLocation,
      this.eventCreatedAt});

  factory EventModel.fromMap(map) {
    return EventModel(
        id: map['id'],
        url: map['url'],
        eventName: map['eventName'],
        eventDescription: map['eventDescription'],
        eventCollege: map['eventCollege'],
        eventCategory: map['eventCategory'],
        eventDate: map['eventDate'],
        eventEndDate: map['eventEndDate'],
        eventFees: map['eventFees'],
        eventLocation: map['eventLocation'],
        eventCreatedAt: map['eventCreatedAt']);
  }
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'url': url,
      'eventName': eventName,
      'eventDescription': eventDescription,
      'eventCollege': eventCollege,
      'eventCategory': eventCategory,
      'eventDate': eventDate,
      'eventEndDate': eventEndDate,
      'eventFees': eventFees,
      'eventLocation': eventLocation,
      'eventCreatedAt': eventCreatedAt
    };
  }
}
