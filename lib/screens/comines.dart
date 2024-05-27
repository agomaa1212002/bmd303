import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/snackbar/snackbar.dart';
import 'package:intl/intl.dart';

import '../widgets/input_field.dart';


class AddTaskPagec extends StatefulWidget {
  const AddTaskPagec({Key? key}) : super(key: key);

  @override
  State<AddTaskPagec> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPagec> {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  final TextEditingController _startTimeController = TextEditingController();
  final TextEditingController _endTimeController = TextEditingController();

  DateTime _selectedDate = DateTime.now();
  String _startTime = DateFormat("hh:mm a").format(DateTime.now()).toString();
  String _endTime = "9:30 PM";
  int _selectedColor = 0;

  List<String> _emails = [];
  String? _selectedEmail;

  @override
  void initState() {
    super.initState();
    _fetchEmails();
    _startTimeController.text = _startTime;
    _endTimeController.text = _endTime;
  }

  _fetchEmails() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('patients').get();
      List<String> emails = querySnapshot.docs.map((doc) => doc['email'].toString()).toList();
      setState(() {
        _emails = emails;
      });
    } catch (e) {
      print('Error fetching emails: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: Container(
        padding: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Add Appointment", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              MyInputField(title: "Search Patient", hint: "Enter patient's email", controller: _searchController),
              ElevatedButton(
                onPressed: () {
                  _searchPatient();
                },
                child: Text("Search"),
              ),
              SizedBox(height: 20),
              Text("Select Patient Email", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              DropdownButton<String>(
                hint: Text("Select email"),
                value: _selectedEmail,
                items: _emails.map((email) {
                  return DropdownMenuItem<String>(
                    value: email,
                    child: Text(email),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedEmail = value;
                  });
                },
              ),
              SizedBox(height: 20),
              Text("Appointment Details", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              MyInputField(title: "Title", hint: "Enter title", controller: _titleController),
              MyInputField(title: "Note", hint: "Enter note", controller: _noteController),
              MyInputField(title: "Start Time", hint: "Enter start time", controller: _startTimeController),
              MyInputField(title: "End Time", hint: "Enter end time", controller: _endTimeController),
              ElevatedButton(
                onPressed: () {
                  _addAppointment();
                },
                child: Text("Add Appointment"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _searchPatient() async {
    String generatedId = _searchController.text.trim();

    if (generatedId.isNotEmpty) {
      try {
        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection('patients')
            .where('generatedId', isEqualTo: generatedId)
            .get();

        if (querySnapshot.docs.isNotEmpty) {
          DocumentSnapshot patientDoc = querySnapshot.docs.first;
          String email = patientDoc['email'];
          String phone = patientDoc['phone'];

          print('Email: $email');
          print('Phone: $phone');
        } else {
          Get.snackbar(
            "Error",
            "Patient not found",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
            duration: Duration(seconds: 3),
          );
        }
      } catch (e) {
        print("Error searching patient: $e");
      }
    } else {
      Get.snackbar(
        "Error",
        "Please enter a valid generatedId to search",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: Duration(seconds: 3),
      );
    }
  }

  _addAppointment() async {
    String? patientEmail = _selectedEmail;
    String title = _titleController.text.trim();
    String note = _noteController.text.trim();
    String startTime = _startTimeController.text.trim();
    String endTime = _endTimeController.text.trim();

    if (patientEmail != null && title.isNotEmpty && note.isNotEmpty && startTime.isNotEmpty && endTime.isNotEmpty) {
      try {
        await FirebaseFirestore.instance.collection('patients').doc(patientEmail).collection('Appointments').add({
          'title': title,
          'note': note,
          'date': DateFormat('yyyy-MM-dd').format(_selectedDate),
          'start_time': startTime,
          'end_time': endTime,
          'color': _selectedColor,
          'created_at': Timestamp.now(),
        });

        Get.snackbar(
          "Success",
          "Appointment added successfully",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: Duration(seconds: 3),
        );
      } catch (e) {
        print('Error adding appointment: $e');
      }
    } else {
      Get.snackbar(
        "Error",
        "Please fill in all fields",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: Duration(seconds: 3),
      );
    }
  }

  _appBar() {
    return AppBar(
      leading: IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () {
          Get.back();
        },
      ),
      title: Text("Add Appointment"),
    );
  }
}
