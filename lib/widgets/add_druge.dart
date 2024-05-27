
import 'package:flutter/material.dart';




void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: PrescriptionPage(),
    theme: ThemeData(
      primaryColor: Color(0xff2C8C6B),
    ),
  ));
}

class PrescriptionPage extends StatefulWidget {
  @override
  _PrescriptionPageState createState() => _PrescriptionPageState();
}

class _PrescriptionPageState extends State<PrescriptionPage> {
  List<String> drugs = [];
  TextEditingController drugController = TextEditingController();
  String selectedTime = 'Before Breakfast';
  String patientName = '';
  String doctorNote = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        toolbarHeight: 50,
        backgroundColor: Colors.white,
        title: Container(  margin: const EdgeInsets.symmetric(horizontal: 20),child: Text('Prescription',style: TextStyle(fontSize: 30, fontWeight:FontWeight.bold , color: Colors.black),)),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 100),
          child: Container(
            width: 1000,
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        TextField(
                          onChanged: (value) {
                            setState(() {
                              patientName = value;
                            });
                          },
                          decoration: InputDecoration(
                            labelText: 'Patient Name',
                          ),
                        ),
                        SizedBox(height: 20.0),
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: drugController,
                                decoration: InputDecoration(
                                  labelText: 'Enter Drug Name',
                                ),
                              ),
                            ),
                            SizedBox(width: 10.0),
                            DropdownButton<String>(
                              value: selectedTime,
                              onChanged: (value) {
                                setState(() {
                                  selectedTime = value!;
                                });
                              },
                              items: <String>[
                                'Before Breakfast',
                                'After Breakfast',
                                'Before Lunch',
                                'After Lunch',
                                'Before Dinner',
                                'After Dinner',
                              ].map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                        SizedBox(height: 20.0),
                        TextField(
                          onChanged: (value) {
                            setState(() {
                              doctorNote = value;
                            });
                          },
                          maxLines: 3,
                          decoration: InputDecoration(
                            labelText: 'Doctor Note',
                          ),
                        ),
                        SizedBox(height: 40.0),
                        SizedBox(
                          width: 200,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                drugs.add('${drugController.text} - $selectedTime');
                                drugController.clear();
                              });
                            },
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(Colors.blue), // Change the color here
                            ),
                            child: Text('Add Drug',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20, color: Colors.white),),
                          ),
                        ),
                        SizedBox(height: 20.0),
                        Expanded(
                          child: ListView.builder(
                            itemCount: drugs.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                title: Text(drugs[index]),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: Icon(Icons.delete),
                                      onPressed: () {
                                        setState(() {
                                          drugs.removeAt(index);
                                        });
                                      },
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.edit),
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: Text('Doctor Note'),
                                              content: Text(doctorNote),
                                              actions: [
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: Text('Close'),
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // You can implement saving prescription logic here
          print("Patient Name: $patientName");
          print("Doctor Note: $doctorNote");
          print("Prescription Saved: $drugs");
        },
        child: Icon(Icons.add, color: Colors.white), // Blue icon color
        backgroundColor: Colors.blue, // Button background color
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat, // Align button to the bottom right
    );
  }
}