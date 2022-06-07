class EventModel {
  String? eid;
  String? url;
  String? eventName;
  String? eventDescription;
  String? eventCollege;
  String? eventCategory;
  String? eventDate;
  String? eventFees;
  String? eventLocation;

  EventModel(
      {this.eid,
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
      eid: map['uid'],
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
      'eid': eid,
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
