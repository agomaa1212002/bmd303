import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../screens/theme.dart';
import 'botton.dart';
import 'input_field.dart';

class AddTaskPage extends StatefulWidget {
  final String generatedId;

  const AddTaskPage({Key? key, required this.generatedId}) : super(key: key);

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final TextEditingController _endTimeController = TextEditingController();
  final TextEditingController _startTimeController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  int _selectedColor = 0;

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
              MyInputField(
                title: "Name",
                hint: "Enter your Name",
                controller: _titleController,
              ),
              MyInputField(
                title: "Note",
                hint: "Enter your Note",
                controller: _noteController,
              ),
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
              Row(
                children: [
                  Expanded(
                    child: MyInputField(
                      title: "Start Date",
                      hint: _startTimeController.text,
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
                      title: "End Date",
                      hint: _endTimeController.text,
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
              // Color palate
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Color",
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
                                backgroundColor: index == 0
                                    ? primaryClr
                                    : index == 1
                                    ? pinkClr
                                    : Colors.yellow,
                                child: _selectedColor == index
                                    ? Icon(
                                  Icons.done,
                                  color: Colors.white,
                                  size: 16,
                                )
                                    : Container(),
                              ),
                            ),
                          );
                        }),
                      ),
                    ],
                  ),
                  Mybutton(
                    label: "Create Task",
                    onTap: () => _validateData(),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  _validateData() async {
    if (_titleController.text.isNotEmpty && _noteController.text.isNotEmpty) {
      // Save task data to Firestore
      final firestore = FirebaseFirestore.instance;
      await firestore.collection('patients').doc(widget.generatedId).collection('Appointments').add({
        'color': _selectedColor,
        'date': DateFormat('yyyy-MM-dd').format(_selectedDate),
        'end_date': _endTimeController.text,
        'note': _noteController.text,
        'start_date': _startTimeController.text,
        'patient_name': _titleController.text,
      });

      Get.back(); // Go back after saving

      // Optionally, you can show a success message or perform other actions
    } else {
      Get.snackbar(
        "Required",
        "All fields are required",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.white,
        colorText: pinkClr,
        icon: Icon(Icons.warning_amber_rounded),
      );
    }
  }

  _appBar() {
    return AppBar(
      leading: GestureDetector(
        onTap: () {
          Get.back();
        },
        child: Icon(
          Icons.arrow_back,
          size: 20,
        ),
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
      lastDate: DateTime(2125),
    );
    if (_pickerDate != null) {
      setState(() {
        _selectedDate = _pickerDate;
      });
    } else {
      print("Something wrong with the date");
    }
  }

  _getTimeFromUser({required bool isStartTime}) async {
    var pickedTime = await _showTimePicker();
    String? formattedTime = pickedTime?.format(context);
    if (pickedTime != null) {
      if (isStartTime) {
        setState(() {
          _startTimeController.text = formattedTime!;
        });
      } else {
        setState(() {
          _endTimeController.text = formattedTime!;
        });
      }
    }
  }

  Future<TimeOfDay?> _showTimePicker() {
    return showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
  }
}
