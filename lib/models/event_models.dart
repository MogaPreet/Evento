class EventModel {
  String? uid;
  String? url;
  String? eventName;
  String? eventDescription;
  String? eventCollege;
  String? eventCategory;
  String? eventDate;
  String? eventFees;
  String? eventLocation;

  EventModel(
      {this.uid,
      this.url,
      this.eventName,
      this.eventDescription,
      this.eventCollege,
      this.eventCategory,
      this.eventDate,
      this.eventFees,
      this.eventLocation});

  factory EventModel.fromMap(map) {
    return EventModel(
      uid: map['uid'],
      url: map['url'],
      eventName: map['eventName'],
      eventDescription: map['eventDescription'],
      eventCollege: map['eventCollege'],
      eventCategory: map['eventCategory'],
      eventDate: map['eventDate'],
      eventFees: map['eventFees'],
      eventLocation: map['eventLocation'],
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'url': url,
      'eventName': eventName,
      'eventDescription': eventDescription,
      'eventCollege': eventCollege,
      'eventCategory': eventCategory,
      'eventDate': eventDate,
      'eventFees': eventFees,
      'eventLocation': eventLocation,
    };
  }
}
