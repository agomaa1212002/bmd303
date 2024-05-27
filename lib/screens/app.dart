//  import 'package:flutter/material.dart';
//  import 'package:get/get.dart';
//  import 'package:intl/intl.dart';
//  import 'package:neutrition_sqlite/mydatabase/sqldb.dart';
//
//  import '../controllers/Task_controller.dart';
//  import '../model/Task.dart';
//  import '../screens/theme.dart';
//  import '../widgets/botton.dart';
// import '../widgets/input_field.dart';
//
//  import 'package:cloud_firestore/cloud_firestore.dart';
//
//  // Function to fetch emails
//  Future<List<String>> fetchPatientEmails() async {
//    List<String> emails = [];
//    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('patients').get();
//    for (var doc in querySnapshot.docs) {
//      emails.add(doc['email']);
//    }
//    return emails;
//  }
//  class AddTaskPaged extends StatefulWidget {
//    const AddTaskPaged({Key? key}): super(key: key);
//
//    @override
//    State<AddTaskPaged> createState() => _AddTaskPageState();
//  }
//
//  class _AddTaskPageState extends State<AddTaskPaged> {
//    final TextEditingController _Endtime = TextEditingController();
//    final TextEditingController _Starttime = TextEditingController();
//    final TextEditingController _titleController = TextEditingController();
//    final TextEditingController _noteController = TextEditingController();
//    DateTime _selectedDate = DateTime.now();
//    String _endTime = "9:30 PM";
//    String _startTime = DateFormat("hh:mm a").format(DateTime.now()).toString();
//    int _selectedRemind = 5;
//    List<int> remindlist = [5, 10, 15, 20];
//    int _selectedColor = 0;
//
//    String? _selectedEmail;
//    List<String> _emails = [];
//
//    @override
//    void initState() {
//      super.initState();
//      _loadEmails();
//    }
//
//    void _loadEmails() async {
//      List<String> emails = await fetchPatientEmails();
//      setState(() {
//        _emails = emails;
//      });
//    }
//
//    @override
//    Widget build(BuildContext context) {
//      return Scaffold(
//        appBar: _appBar(),
//        body: Container(
//          padding: EdgeInsets.only(left: 20, right: 20),
//          child: SingleChildScrollView(
//            child: Column(
//              crossAxisAlignment: CrossAxisAlignment.start,
//              children: [
//                Text("Add", style: headingStyle),
//                MyInputField(title: "Name", hint: "Enter your Name", controller: _titleController),
//                MyInputField(title: "Note", hint: "Enter your Note", controller: _noteController),
//                MyInputField(
//                  title: "Date",
//                  hint: DateFormat.yMd().format(_selectedDate),
//                  widget: IconButton(
//                    icon: Icon(Icons.calendar_today_outlined, color: Colors.grey),
//                    onPressed: () {
//                      print("hi");
//                      _getDateFromUser();
//                    },
//                  ),
//                ),
//                // Dropdown for selecting email
//                DropdownButtonFormField<String>(
//                  value: _selectedEmail,
//                  hint: Text('Select Email'),
//                  onChanged: (value) {
//                    setState(() {
//                      _selectedEmail = value!;
//                    });
//                  },
//                  items: _emails.map((email) {
//                    return DropdownMenuItem<String>(
//                      value: email,
//                      child: Text(email),
//                    );
//                  }).toList(),
//                ),
//                Row(
//                  children: [
//                    Expanded(
//                      child: MyInputField(
//                        title: "Start Date",
//                        hint: _startTime,
//                        widget: IconButton(
//                          onPressed: () {
//                            _getTimeFromUser(isStartTime: true);
//                          },
//                          icon: Icon(
//                            Icons.access_time_rounded,
//                            color: Colors.grey,
//                          ),
//                        ),
//                      ),
//                    ),
//                    SizedBox(width: 12),
//                    Expanded(
//                      child: MyInputField(
//                        title: "End Date",
//                        hint: _endTime,
//                        widget: IconButton(
//                          onPressed: () {
//                            _getTimeFromUser(isStartTime: false);
//                          },
//                          icon: Icon(
//                            Icons.access_time_rounded,
//                            color: Colors.grey,
//                          ),
//                        ),
//                      ),
//                    ),
//                  ],
//                ),
//                SizedBox(height: 18.0),
//                Row(
//                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                  crossAxisAlignment: CrossAxisAlignment.center,
//                  children: [
//                    Column(
//                      crossAxisAlignment: CrossAxisAlignment.start,
//                      children: [
//                        Text(
//                          "color",
//                          style: titleStyle,
//                        ),
//                        SizedBox(height: 8.0),
//                        Wrap(
//                            children: List<Widget>.generate(3, (int index) {
//                              return GestureDetector(
//                                onTap: () {
//                                  setState(() {
//                                    _selectedColor = index;
//                                  });
//                                },
//                                child: Padding(
//                                  padding: const EdgeInsets.only(right: 8.0),
//                                  child: CircleAvatar(
//                                    radius: 14,
//                                    backgroundColor: index == 0 ? primaryClr : index == 1 ? pinkClr : Colors.yellow,
//                                    child: _selectedColor == index ? Icon(
//                                      Icons.done,
//                                      color: Colors.white,
//                                      size: 16,
//                                    ) : Container(),
//                                  ),
//                                ),
//                              );
//                            })),
//                      ],
//                    ),
//                    Mybutton(label: "Create Task", onTap: () => _validateData())
//                  ],
//                ),
//              ],
//            ),
//          ),
//        ),
//      );
//    }
//
//    _validateData() async {
//      if (_selectedEmail != null) {
//        // Add appointment to the selected patient's collection
//        await _addAppointmentToPatient(_selectedEmail!);
//      }
//    }
//
//    Future<void> _addAppointmentToPatient(String email) async {
//      final doc = await FirebaseFirestore.instance.collection('patients').where('email', isEqualTo: email).get();
//      if (doc.docs.isNotEmpty) {
//        final patientDoc = doc.docs.first.reference;
//        final appointmentRef = patientDoc.collection('appointments').doc();
//        await appointmentRef.set({
//          'title': _titleController.text,
//          'note': _noteController.text,
//          'date': _selectedDate,
//          'startTime': _startTime,
//          'endTime': _endTime,
//          'remind': _selectedRemind,
//          'color': _selectedColor,
//        });
//        print('Appointment added');
//      }
//    }
//
//    _appBar() {
//      return AppBar(
//        leading: GestureDetector(
//          onTap: () {
//            Get.back();
//          },
//          child: Icon(Icons.arrow_back, size: 20),
//        ),
//        actions: [
//          Icon(Icons.person, size: 20),
//          SizedBox(width: 20),
//        ],
//      );
//    }
//
//    _getDateFromUser() async {
//      DateTime? _pickerDate = await showDatePicker(
//          context: context,
//          initialDate: DateTime.now(),
//          firstDate: DateTime(2020),
//          lastDate: DateTime(2125));
//      if (_pickerDate != null) {
//        setState(() {
//          _selectedDate = _pickerDate;
//          print(_selectedDate);
//        });
//      } else {
//        print("something wrong with the date");
//      }
//    }
//
//    _getTimeFromUser({required bool isStartTime}) async {
//      var pickedTime = await _showTimePicker();
//      String _formatedTime = pickedTime.format(context);
//      if (pickedTime == null) {
//        print("Time !!!!");
//      } else if (isStartTime == true) {
//        setState(() {
//          _startTime = _formatedTime;
//        });
//      } else if (isStartTime == false) {
//        setState(() {
//          _endTime = _formatedTime;
//        });
//      }
//    }
//
//    _showTimePicker() {
//      return showTimePicker(
//          initialEntryMode: TimePickerEntryMode.input,
//          context: context,
//          initialTime: TimeOfDay(
//              hour: int.parse(_startTime.split(":")[0]),
//              minute: int.parse(_startTime.split(":")[1].split(" ")[0])));
//    }
//  }
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:neutrition_sqlite/mydatabase/sqldb.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../controllers/Task_controller.dart';
import '../model/Task.dart';
import '../screens/theme.dart';
import '../widgets/botton.dart';
import '../widgets/input_field.dart';

Future<List<String>> fetchPatientEmails() async {
  List<String> emails = [];
  QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('patients').get();
  for (var doc in querySnapshot.docs) {
    emails.add(doc['email']);
  }
  return emails;
}

class AddTaskPaged extends StatefulWidget {
  const AddTaskPaged({Key? key}): super(key: key);

  @override
  State<AddTaskPaged> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPaged> {
  final TextEditingController _Endtime = TextEditingController();
  final TextEditingController _Starttime = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  String _endTime = "9:30 PM";
  String _startTime = DateFormat("hh:mm a").format(DateTime.now()).toString();
  int _selectedRemind = 5;
  List<int> remindlist = [5, 10, 15, 20];
  int _selectedColor = 0;

  String? _selectedEmail;
  List<String> _emails = [];

  @override
  void initState() {
    super.initState();
    _loadEmails();
  }

  void _loadEmails() async {
    List<String> emails = await fetchPatientEmails();
    setState(() {
      _emails = emails;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: Container(
        padding: EdgeInsets.only(left: 20, right: 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Add", style: headingStyle),
              MyInputField(title: "Name", hint: "Enter your Name", controller: _titleController),
              MyInputField(title: "Note", hint: "Enter your Note", controller: _noteController),
              MyInputField(
                title: "Date",
                hint: DateFormat.yMd().format(_selectedDate),
                widget: IconButton(
                  icon: Icon(Icons.calendar_today_outlined, color: Colors.grey),
                  onPressed: () {
                    _getDateFromUser();
                  },
                ),
              ),
              DropdownButtonFormField<String>(
                value: _selectedEmail,
                hint: Text('Select Email'),
                onChanged: (value) {
                  setState(() {
                    _selectedEmail = value!;
                  });
                },
                items: _emails.map((email) {
                  return DropdownMenuItem<String>(
                    value: email,
                    child: Text(email),
                  );
                }).toList(),
              ),
              Row(
                children: [
                  Expanded(
                    child: MyInputField(
                      title: "Start Time",
                      hint: _startTime,
                      widget: IconButton(
                        onPressed: () {
                          _getTimeFromUser(isStartTime: true);
                        },
                        icon: Icon(
                          Icons.access_time_rounded,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: MyInputField(
                      title: "End Time",
                      hint: _endTime,
                      widget: IconButton(
                        onPressed: () {
                          _getTimeFromUser(isStartTime: false);
                        },
                        icon: Icon(
                          Icons.access_time_rounded,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 18.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "color",
                        style: titleStyle,
                      ),
                      SizedBox(height: 8.0),
                      Wrap(
                          children: List<Widget>.generate(3, (int index) {
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  _selectedColor = index;
                                });
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: CircleAvatar(
                                  radius: 14,
                                  backgroundColor: index == 0 ? primaryClr : index == 1 ? pinkClr : Colors.yellow,
                                  child: _selectedColor == index ? Icon(
                                    Icons.done,
                                    color: Colors.white,
                                    size: 16,
                                  ) : Container(),
                                ),
                              ),
                            );
                          })),
                    ],
                  ),
                  Mybutton(label: "Create Task", onTap: () => _validateData())
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  _validateData() async {
    if (_selectedEmail != null) {
      if (_isValidTime() && _isValidDate() && await _isTimeSlotAvailable()) {
        await _addAppointmentToPatient(_selectedEmail!);
      }
    }
  }

  bool _isValidDate() {
    if (_selectedDate.weekday == DateTime.friday || _selectedDate.weekday == DateTime.saturday) {
      Get.snackbar('Invalid Date', 'Bookings are not allowed on Fridays and Saturdays.');
      return false;
    }
    return true;
  }

  bool _isValidTime() {
    final startTime = TimeOfDay(
      hour: int.parse(_startTime.split(":")[0]),
      minute: int.parse(_startTime.split(":")[1].split(" ")[0]),
    );
    final endTime = TimeOfDay(
      hour: int.parse(_endTime.split(":")[0]),
      minute: int.parse(_endTime.split(":")[1].split(" ")[0]),
    );

    if (startTime.hour < 9 || (startTime.hour >= 20 && startTime.minute > 0)) {
      Get.snackbar('Invalid Time', 'Start time must be between 9 AM and 8 PM.');
      return false;
    }
    if (endTime.hour < 9 || (endTime.hour >= 20 && endTime.minute > 0)) {
      Get.snackbar('Invalid Time', 'End time must be between 9 AM and 8 PM.');
      return false;
    }
    return true;
  }

  Future<bool> _isTimeSlotAvailable() async {
    final doc = await FirebaseFirestore.instance.collection('patients').where('email', isEqualTo: _selectedEmail).get();
    if (doc.docs.isNotEmpty) {
      final patientDoc = doc.docs.first.reference;
      final appointments = await patientDoc.collection('appointments').get();

      final selectedStartTime = TimeOfDay(
        hour: int.parse(_startTime.split(":")[0]),
        minute: int.parse(_startTime.split(":")[1].split(" ")[0]),
      );
      final selectedEndTime = TimeOfDay(
        hour: int.parse(_endTime.split(":")[0]),
        minute: int.parse(_endTime.split(":")[1].split(" ")[0]),
      );

      for (var appointment in appointments.docs) {
        final startTime = TimeOfDay(
          hour: int.parse(appointment['startTime'].split(":")[0]),
          minute: int.parse(appointment['startTime'].split(":")[1].split(" ")[0]),
        );
        final endTime = TimeOfDay(
          hour: int.parse(appointment['endTime'].split(":")[0]),
          minute: int.parse(appointment['endTime'].split(":")[1].split(" ")[0]),
        );

        if (_selectedDate == (appointment['date'] as Timestamp).toDate()) {
          if ((selectedStartTime.hour < endTime.hour || (selectedStartTime.hour == endTime.hour && selectedStartTime.minute < endTime.minute)) &&
              (selectedEndTime.hour > startTime.hour || (selectedEndTime.hour == startTime.hour && selectedEndTime.minute > startTime.minute))) {
            Get.snackbar('Time Slot Unavailable', 'The selected time slot is already booked.');
            return false;
          }
        }
      }
    }
    return true;
  }

  Future<void> _addAppointmentToPatient(String email) async {
    final doc = await FirebaseFirestore.instance.collection('patients').where('email', isEqualTo: email).get();
    if (doc.docs.isNotEmpty) {
      final patientDoc = doc.docs.first.reference;
      final appointmentRef = patientDoc.collection('appointments').doc();
      await appointmentRef.set({
        'title': _titleController.text,
        'note': _noteController.text,
        'date': _selectedDate,
        'startTime': _startTime,
        'endTime': _endTime,
        'remind': _selectedRemind,
        'color': _selectedColor,
      });
      print('Appointment added');
    }
  }

  _appBar() {
    return AppBar(
      leading: GestureDetector(
        onTap: () {
          Get.back();
        },
        child: Icon(Icons.arrow_back, size: 20),
      ),
      actions: [
        Icon(Icons.person, size: 20),
        SizedBox(width: 20),
      ],
    );
  }

  _getDateFromUser() async {
    DateTime? _pickerDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2020),
        lastDate: DateTime(2125));
    if (_pickerDate != null) {
      setState(() {
        _selectedDate = _pickerDate;
      });
    } else {
      print("something wrong with the date");
    }
  }

  _getTimeFromUser({required bool isStartTime}) async {
    var pickedTime = await _showTimePicker();
    String _formatedTime = pickedTime.format(context);
    if (pickedTime != null) {
      if (isStartTime) {
        setState(() {
          _startTime = _formatedTime;
        });
      } else {
        setState(() {
          _endTime = _formatedTime;
        });
      }
    } else {
      print("Time !!!!");
    }
  }

  _showTimePicker() {
    return showTimePicker(
      initialEntryMode: TimePickerEntryMode.input,
      context: context,
      initialTime: TimeOfDay(
        hour: int.parse(_startTime.split(":")[0]),
        minute: int.parse(_startTime.split(":")[1].split(" ")[0]),
      ),
    );
  }
}
