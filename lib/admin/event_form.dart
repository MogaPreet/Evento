import 'dart:io';
import 'package:email_password_login/admin/dummy.dart';
import 'package:email_password_login/admin/event_Date.dart';
import 'package:email_password_login/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class createEvent extends StatefulWidget {
  const createEvent({Key? key}) : super(key: key);

  @override
  State<createEvent> createState() => _createEventState();
}

class _createEventState extends State<createEvent> {
  String level = "Compitition";
  PickedFile? _imagefile;
  final ImagePicker _picker = ImagePicker();

  final TextEditingController eventNameController = TextEditingController();
  final TextEditingController eventFeesController = TextEditingController();
  final TextEditingController eventDescController = TextEditingController();
  final TextEditingController eventVenueController = TextEditingController();

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
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
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
              eventName(),
              const SizedBox(
                height: 15,
              ),
              eventDesc(),
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
              selectDate(),
              SizedBox(
                height: 15,
              ),
              eventFees(),
              const SizedBox(
                height: 15,
              ),
              eventVenue(),
              const SizedBox(
                height: 20,
              ),
              CreateProfileButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget EventImage() {
    return Center(
      child: Stack(
        children: <Widget>[
          CircleAvatar(
            radius: 70.0,
            backgroundImage:
                _imagefile == null ? null : FileImage(File(_imagefile!.path)),
          ),
          Positioned(
            bottom: 20.0,
            right: 20.0,
            child: InkWell(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  builder: ((builder) => bottomSheet()),
                );
              },
              child: const Icon(
                Icons.add_a_photo_rounded,
                color: Colors.black,
                size: 28,
              ),
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
              icon: const Icon(Icons.camera),
              onPressed: () {
                takePhoto(ImageSource.camera);
              },
              label: const Text("Camera"),
            ),
            FlatButton.icon(
              icon: const Icon(Icons.image),
              onPressed: () {
                takePhoto(ImageSource.gallery);
              },
              label: const Text("Gallery"),
            ),
          ])
        ],
      ),
    );
  }

  void takePhoto(ImageSource source) async {
    final pickedFile = await _picker.getImage(
      source: source,
    );
    setState(() {
      _imagefile = pickedFile!;
    });
  }

  Widget eventName() {
    return TextFormField(
      controller: eventNameController,
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
  }

  Widget eventDesc() {
    return TextFormField(
      controller: eventDescController,
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
          Icons.description_outlined,
          color: Colors.black,
        ),
        hintText: "Event Description",
      ),
    );
  }

  Widget collegeSelect() {
    return Column(
      children: [
        const Text("Choose College"),
        const SizedBox(
          height: 10,
        ),
        DecoratedBox(
          decoration: BoxDecoration(
              color: Colors.black, borderRadius: BorderRadius.circular(50)),
          child: Padding(
            padding: const EdgeInsets.only(left: 30, right: 30),
            child: DropdownButton(
              // Initial Value
              value: dropdownvalue,

              style: const TextStyle(color: Colors.white),
              underline: Container(),
              borderRadius: BorderRadius.circular(5),
              isExpanded: true,
              dropdownColor: Colors.black,
              // Down Arrow Icon

              icon: const Icon(Icons.keyboard_arrow_down),

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

  Widget eventFees() {
    return TextFormField(
      controller: eventFeesController,
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
              color: Colors.black, borderRadius: BorderRadius.circular(50)),
          child: Padding(
            padding: const EdgeInsets.only(left: 30, right: 30),
            child: DropdownButton(
              // Initial Value
              value: dropdownvaluecate,
              style: const TextStyle(color: Colors.white),
              underline: Container(),
              borderRadius: BorderRadius.circular(5),
              isExpanded: true,
              dropdownColor: Colors.black,
              // Down Arrow Icon

              icon: const Icon(Icons.keyboard_arrow_down),

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

  Widget selectDate() {
    return ElevatedButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const DateTimeEvent()));
        },
        child: Text("choose event date"));
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

  Widget CreateProfileButton() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Material(
        elevation: 4,
        borderRadius: BorderRadius.circular(25),
        color: Colors.black,
        child: MaterialButton(
          padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          minWidth: MediaQuery.of(context).size.width,
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const Dummy()));
          },
          child: const Text(
            "Add Event",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
