import 'dart:convert';
import 'dart:io' as io;
import 'package:email_password_login/admin/dummy.dart';
import 'package:email_password_login/models/event_models.dart';
import 'package:email_password_login/notification_service.dart';
import 'package:file/file.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;

class createEvent extends StatefulWidget {
  const createEvent({Key? key}) : super(key: key);

  @override
  State<createEvent> createState() => _createEventState();
}

class _createEventState extends State<createEvent> {
  String _selectedDate = '';

  String _dateCount = "";
  String _range = '';
  String _rangeCount = '';
  String _endEvent = '';

  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    setState(() {
      if (args.value is PickerDateRange) {
        _range = '${DateFormat('dd/MM/yyyy').format(args.value.startDate)}'
            '- ${DateFormat('dd/MM/yyyy').format(args.value.endDate)}';
        _endEvent = '${DateFormat('dd/MM/yyyy').format(args.value.endDate)}';
        if (args.value.startDate == args.value.endDate) {
          _range = '${DateFormat('dd/MM/yyyy').format(args.value.endDate)}';
          _endEvent = '${DateFormat('dd/MM/yyyy').format(args.value.endDate)}';
        }
      } else if (args.value is DateTime) {
        _selectedDate = args.value.toString();
      } else if (args.value is List<DateTime>) {
        int _dateCount = args.value.toString().length;
      } else {
        _rangeCount = args.value.length.toString();
      }
    });
  }

  XFile? _pickedImage;

  final _formKey = GlobalKey<FormState>();

  var _eventCategory = "";

  bool _isLoading = false;
  String? url;
  var uuid = Uuid();

  final eventNameController = TextEditingController();
  final eventFeesController = TextEditingController();
  final eventDescController = TextEditingController();
  final eventVenueController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  String dropdownvalue = 'SBMP';

  var college = [
    'SBMP',
    'Mithibai',
    'NMIMS',
    'DJSCV',
    'NM',
  ];

  String dropdownvaluecate = 'Dance and Music';
  var category = [
    'Dance and Music',
    'Technical Event',
    'Compitition',
    'Live Shows',
    'Movie Promotion',
  ];

  @override
  Widget build(BuildContext context) {
    //all the fields
    final eventName = TextFormField(
      controller: eventNameController,
      validator: (value) {
        if (value!.isEmpty) {
          return "Event Name is Required";
        } else {
          return null;
        }
      },
      onSaved: (value) {
        eventNameController.text = value!;
      },
      decoration: InputDecoration(
        border: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.black,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(width: 2, color: Colors.black),
          borderRadius: BorderRadius.circular(5.0),
        ),
        prefixIcon: const Icon(
          Icons.event_available_outlined,
          color: Colors.black,
        ),
        hintText: "Event Name",
      ),
    );

    final eventFees = TextFormField(
      controller: eventFeesController,
      validator: (value) {
        if (value!.isEmpty) {
          return "if it is free enter 0";
        } else {
          return null;
        }
      },
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
          border: const OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.black,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(width: 2, color: Colors.black),
            borderRadius: BorderRadius.circular(5.0),
          ),
          prefixIcon: const Icon(
            Icons.currency_rupee_outlined,
            color: Colors.green,
          ),
          hintText: "Event Fees",
          labelText: 'if any'),
    );

    final eventVenue = TextFormField(
      controller: eventVenueController,
      validator: (value) {
        if (value!.isEmpty) {
          return "Event Location is Required";
        } else {
          return null;
        }
      },
      minLines: 1,
      maxLines: 10,
      keyboardType: TextInputType.streetAddress,
      decoration: InputDecoration(
        border: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.black,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(width: 2, color: Colors.black),
          borderRadius: BorderRadius.circular(5.0),
        ),
        prefixIcon: const Icon(
          Icons.place_outlined,
          color: Colors.black,
        ),
        hintText: "Event Venue",
      ),
    );

    final eventDesc = TextFormField(
      controller: eventDescController,
      minLines: 1,
      maxLines: 10,
      validator: (value) {
        if (value!.isEmpty) {
          return "Event Details is Required";
        } else {
          return null;
        }
      },
      onSaved: (value) {
        eventDescController.text = value!;
      },
      keyboardType: TextInputType.multiline,
      decoration: InputDecoration(
        border: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.black,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(width: 2, color: Colors.black),
          borderRadius: BorderRadius.circular(5.0),
        ),
        prefixIcon: const Icon(
          Icons.description_outlined,
          color: Colors.black,
        ),
        hintText: "Event Description",
      ),
    );

    Widget collegeSelect() {
      return Column(
        children: [
          const Text("Choose College"),
          const SizedBox(
            height: 10,
          ),
          DecoratedBox(
            decoration: BoxDecoration(
                color: Colors.black, borderRadius: BorderRadius.circular(8)),
            child: Padding(
              padding: const EdgeInsets.only(left: 15, right: 15),
              child: DropdownButton(
                // Initial Value
                value: dropdownvalue,
                disabledHint: Text("Choose Collge"),
                style: const TextStyle(color: Colors.white),
                underline: Container(),
                borderRadius: BorderRadius.circular(2),
                isExpanded: true,
                dropdownColor: Colors.black,
                // Down Arrow Icon

                icon: const Icon(
                  Icons.keyboard_arrow_down,
                  color: Colors.white,
                ),

                // Array list of items
                items: college.map((String college) {
                  return DropdownMenuItem(
                    value: college,
                    child: Text(college),
                  );
                }).toList(),
                // After selecting the desired option,it will
                // change button value to selected value

                onChanged: (String? newValue) {
                  setState(() {
                    dropdownvalue = newValue!;
                  });
                },
                hint: const Text("Select College"),
              ),
            ),
          ),
        ],
      );
    }

    void _addEvent() async {
      final isValid = _formKey.currentState!.validate();
      var date = DateTime.now().toString();

      var dateparse = DateTime.parse(date);

      if (isValid) {
        _formKey.currentState!.save();
        try {
          if (_pickedImage == null) {
            Fluttertoast.showToast(msg: 'Please Select an image to contiue');
          } else {
            setState(() {
              _isLoading = true;
            });
            final ref = FirebaseStorage.instance
                .ref()
                .child('EventImages')
                .child(eventNameController.text + '.jpeg');

            await ref.putFile(io.File(_pickedImage!.path));
            url = await ref.getDownloadURL();
            final id = uuid.v4();

            EventModel eventModel = EventModel();
            eventModel.id = id;
            eventModel.url = url;
            eventModel.eventName = eventNameController.text;
            eventModel.eventDescription = eventDescController.text;
            eventModel.eventCollege = dropdownvalue;
            eventModel.eventCategory = dropdownvaluecate;
            eventModel.eventDate = _range;
            eventModel.eventEndDate = _endEvent;
            eventModel.eventFees = eventFeesController.text;
            eventModel.eventLocation = eventVenueController.text;
            eventModel.eventCreatedAt = Timestamp.now().toDate().toString();
            await FirebaseFirestore.instance
                .collection('events')
                .doc(id)
                .set(eventModel.toMap());

            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const Dummy()),
                (route) => false);
          }
        } catch (error) {
          print('error occured ${error}');
        } finally {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }

    Widget DateTimeEvent() {
      return Container(
        decoration: BoxDecoration(border: Border.all(color: Colors.black)),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Choose Event Date"),
            ),
            SfDateRangePicker(
              onSelectionChanged: _onSelectionChanged,
              selectionMode: DateRangePickerSelectionMode.range,
              enablePastDates: false,
              initialSelectedRange: PickerDateRange(
                  DateTime.now().subtract(const Duration(days: 4)),
                  DateTime.now().add(const Duration(days: 3))),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text('$_range'),
            ),
          ],
        ),
      );
    }

    Widget CreateEventButton() {
      return Padding(
        padding: const EdgeInsets.only(bottom: 10.0),
        child: Material(
          elevation: 4,
          borderRadius: BorderRadius.circular(8),
          color: Colors.black,
          child: MaterialButton(
            padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
            minWidth: MediaQuery.of(context).size.width,
            onPressed: () {
              _addEvent();
            },
            child: _isLoading
                ? SizedBox(
                    width: 20.0,
                    height: 20.0,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                : Text(
                    "Add Event",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
          ),
        ),
      );
    }

    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
          child: NotificationListener<OverscrollIndicatorNotification>(
            onNotification: ((overscroll) {
              overscroll.disallowIndicator();
              return true;
            }),
            child: Form(
              key: _formKey,
              child: ListView(
                children: <Widget>[
                  const SizedBox(
                    height: 15,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: const <Widget>[
                      Text(
                        "Add Event",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  EventImage(),
                  const SizedBox(
                    height: 25,
                  ),
                  eventName,
                  const SizedBox(
                    height: 15,
                  ),
                  eventDesc,
                  const SizedBox(
                    height: 15,
                  ),
                  collegeSelect(),
                  const SizedBox(
                    height: 15,
                  ),
                  selectCategory(),
                  const SizedBox(
                    height: 15,
                  ),
                  DateTimeEvent(),
                  SizedBox(
                    height: 15,
                  ),
                  eventFees,
                  const SizedBox(
                    height: 15,
                  ),
                  eventVenue,
                  const SizedBox(
                    height: 20,
                  ),
                  CreateEventButton(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<XFile?> imagePicker() async {
    return await ImagePicker().pickImage(source: ImageSource.gallery);
  }

  Widget EventImage() {
    return Center(
      child: Stack(
        children: <Widget>[
          InkWell(
            onTap: () async {
              _pickedImage = await imagePicker();
              if (_pickedImage != null && _pickedImage!.path.isNotEmpty) {
                setState(() {});
              }
            },
            child: Container(
              width: double.infinity,
              height: 150.0,
              decoration:
                  BoxDecoration(border: Border.all(color: Colors.black)),
              child: _pickedImage != null && _pickedImage!.path.isNotEmpty
                  ? Image.file(
                      io.File(_pickedImage!.path),
                      fit: BoxFit.cover,
                    )
                  : Icon(Icons.add_a_photo_outlined),
            ),
          ),
        ],
      ),
    );
  }

  Widget bottomSheet() {
    return Container(
      height: 100.0,
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 20,
      ),
      child: Column(
        children: <Widget>[
          const Text(
            "Choose Event photo",
            style: TextStyle(
              fontSize: 20.0,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
            FlatButton.icon(
              icon: const Icon(Icons.image),
              onPressed: () async {
                _pickedImage = await imagePicker();
                if (_pickedImage != null && _pickedImage!.path.isNotEmpty) {
                  setState(() {});
                }
              },
              label: const Text("Gallery"),
            ),
          ])
        ],
      ),
    );
  }

  Widget selectCategory() {
    return Column(
      children: [
        const Text("Choose Category"),
        const SizedBox(
          height: 10,
        ),
        DecoratedBox(
          decoration: BoxDecoration(
              color: Colors.black, borderRadius: BorderRadius.circular(8)),
          child: Padding(
            padding: const EdgeInsets.only(left: 15, right: 15),
            child: DropdownButton(
              // Initial Value
              value: dropdownvaluecate,
              style: const TextStyle(color: Colors.white),
              underline: Container(),
              borderRadius: BorderRadius.circular(2),
              isExpanded: true,
              dropdownColor: Colors.black,
              // Down Arrow Icon

              icon: const Icon(
                Icons.keyboard_arrow_down,
                color: Colors.white,
              ),

              // Array list of items
              items: category.map((String category) {
                return DropdownMenuItem(
                  value: category,
                  child: Text(category),
                );
              }).toList(),
              // After selecting the desired option,it will
              // change button value to selected value
              onChanged: (String? newcateValue) {
                setState(() {
                  dropdownvaluecate = newcateValue!;
                });
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget eventVenue() {
    return TextFormField(
      controller: eventVenueController,
      minLines: 1,
      maxLines: 10,
      keyboardType: TextInputType.multiline,
      decoration: InputDecoration(
        border: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.black,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(width: 2, color: Colors.black),
          borderRadius: BorderRadius.circular(5.0),
        ),
        prefixIcon: const Icon(
          Icons.place_outlined,
          color: Colors.black,
        ),
        hintText: "Event Venue",
      ),
    );
  }
}
