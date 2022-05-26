import 'dart:io';
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

  final TextEditingController eventNameController = new TextEditingController();
  final TextEditingController eventDescController = new TextEditingController();

  String dropdownvalue = 'SBMP';
  var college = [
    'SBMP',
    'Mithibai',
    'NMIMS',
    'DJSCV',
    'NM',
    'Ritu'
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
          child: ListView(
            children: <Widget>[
              SizedBox(
                height: 15,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "Add Event",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFfa8919),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 25,
              ),
              EventImage(),
              SizedBox(
                height: 25,
              ),
              eventName(),
              SizedBox(
                height: 15,
              ),
              eventDesc(),
              SizedBox(
                height: 15,
              ),
              collegeSelect(),
              SizedBox(
                height: 15,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Event Category: ",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  SizedBox(
                    height: 2,
                  ),
                  Row(
                    children: [
                      Text("Compition"),
                      Radio(
                          value: "comp",
                          groupValue: level,
                          onChanged: (value) {
                            setState(() {
                              level = value.toString();
                            });
                          }),
                      SizedBox(
                        width: 5.0,
                      ),
                      Text("Hackathon"),
                      Radio(
                          value: "hack",
                          groupValue: level,
                          onChanged: (value) {
                            setState(() {
                              level = value.toString();
                            });
                          }),
                      SizedBox(
                        width: 5.0,
                      ),
                      Text("Food & Music"),
                      Radio(
                          value: "dj",
                          groupValue: level,
                          onChanged: (value) {
                            setState(() {
                              level = value.toString();
                            });
                          }),
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: 15,
              ),
              TypesofoutfitsTextField(),
              SizedBox(
                height: 15,
              ),
              SpecialistInTextField(),
              SizedBox(
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
              child: Icon(
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
      margin: EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 20,
      ),
      child: Column(
        children: <Widget>[
          Text(
            "Choose Event photo",
            style: TextStyle(
              fontSize: 20.0,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
            FlatButton.icon(
              icon: Icon(Icons.camera),
              onPressed: () {
                takePhoto(ImageSource.camera);
              },
              label: Text("Camera"),
            ),
            FlatButton.icon(
              icon: Icon(Icons.image),
              onPressed: () {
                takePhoto(ImageSource.gallery);
              },
              label: Text("Gallery"),
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
        border: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.black,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(width: 2, color: Colors.black),
          borderRadius: BorderRadius.circular(5.0),
        ),
        prefixIcon: Icon(
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
      onChanged: (val) {
        final trimVal = val.trim();
        if (val != trimVal)
          setState(() {
            eventDescController.text = trimVal;
            eventDescController.selection = TextSelection.fromPosition(
                TextPosition(offset: trimVal.length));
          });
      },
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.black,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(width: 2, color: Colors.black),
          borderRadius: BorderRadius.circular(5.0),
        ),
        prefixIcon: Icon(
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
        Text("Choose College"),
        SizedBox(
          height: 10,
        ),
        DecoratedBox(
          decoration: BoxDecoration(
              color: Colors.black, borderRadius: BorderRadius.circular(50)),
          child: Padding(
            padding: EdgeInsets.only(left: 30, right: 30),
            child: DropdownButton(
              // Initial Value
              value: dropdownvalue,
              style: TextStyle(color: Colors.white),
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
            ),
          ),
        ),
      ],
    );
  }

  Widget TypesofoutfitsTextField() {
    return TextFormField(
      keyboardType: TextInputType.multiline,
      minLines: 1,
      maxLines: 3,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.black,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(width: 2, color: Color(0xFFfa8919)),
          borderRadius: BorderRadius.circular(15.0),
        ),
        prefixIcon: Icon(
          Icons.checkroom,
          color: Colors.black,
        ),
        labelText: "Type of Clothes",
        hintText: "Types of Clothes stich",
      ),
    );
  }

  Widget SpecialistInTextField() {
    return TextFormField(
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderSide: BorderSide(
            color: Color(0xFFfa8919),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(width: 2, color: Color(0xFFfa8919)),
          borderRadius: BorderRadius.circular(15.0),
        ),
        prefixIcon: Icon(
          Icons.favorite,
          color: Colors.black,
        ),
        labelText: "SpecialistIn",
        helperText: "SpecialistIn can't be empty",
        hintText: "SpecialistIn",
      ),
    );
  }

  Widget CreateProfileButton() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Material(
        elevation: 4,
        borderRadius: BorderRadius.circular(25),
        color: Color(0xFFfa8919),
        child: MaterialButton(
          padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          minWidth: MediaQuery.of(context).size.width,
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => HomeScreen()));
          },
          child: Text(
            "Add Event",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
