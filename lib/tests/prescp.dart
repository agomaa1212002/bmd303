import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../screens/app.dart';
import '../screens/login.dart';
import '../screens/profilepage.dart';
import 'geminipage.dart';

void main() {
  runApp(PrescriptionApp());
}

class PrescriptionApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Prescription App',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: PrescriptionScreen(),
    );
  }
}

class PrescriptionScreen extends StatefulWidget {
  @override
  _PrescriptionScreenState createState() => _PrescriptionScreenState();
}

class _PrescriptionScreenState extends State<PrescriptionScreen> {
  final _formKey = GlobalKey<FormState>();
  String _patientName = '';
  String _instructions = '';
  List<String> _medications = [''];
  List<String> _dosages = [''];

  Future<void> _savePrescription() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // Create the prescription data
      List<Map<String, dynamic>> dosageInstructions = [];
      for (int i = 0; i < _medications.length; i++) {
        dosageInstructions.add({
          'text': _dosages[i],
          'additionalInstruction': [
            {'text': _instructions}
          ]
        });
      }

      Map<String, dynamic> prescription = {
        'resourceType': 'MedicationRequest',
        'status': 'active',
        'intent': 'order',
        'subject': {
          'reference': 'Patient/123', // Adjust the patient reference as needed
          'display': _patientName
        },
        'medicationCodeableConcept': {
          'text': _medications.join(', ')
        },
        'dosageInstruction': dosageInstructions,
      };

      // Convert to JSON
      String jsonPrescription = jsonEncode(prescription);

      // Your authentication token (should be stored securely)
      String token = 'your_auth_token_here'; // Replace with your actual token

      // Send the JSON to the FHIR Simplifier server
      var response = await http.post(
        Uri.parse('https://fhir.simplifier.net/JHA-Agmed-team/MedicationRequest'),
        headers: {
          'Content-Type': 'application/fhir+json',
          'Accept': 'application/fhir+json',
          'Authorization': 'Bearer $token',
        },
        body: jsonPrescription,
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Prescription saved successfully!')),
        );
      } else {
        String errorMsg = 'Failed to save prescription: ${response.statusCode}';
        if (response.body.isNotEmpty) {
          errorMsg += '\nDetails: ${response.body}';
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMsg)),
        );
      }
    }
  }

  void _addMedicationField() {
    setState(() {
      _medications.add('');
      _dosages.add('');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Prescription', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.teal,
      ),
      drawer: _buildDrawer(context),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Patient Name'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter the patient name';
                  }
                  return null;
                },
                onSaved: (value) {
                  _patientName = value!;
                },
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: _medications.length,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        TextFormField(
                          decoration: InputDecoration(labelText: 'Medication ${index + 1}'),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter the medication';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _medications[index] = value!;
                          },
                        ),
                        TextFormField(
                          decoration: InputDecoration(labelText: 'Dosage ${index + 1}'),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter the dosage';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _dosages[index] = value!;
                          },
                        ),
                      ],
                    );
                  },
                ),
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Instructions'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter the instructions';
                  }
                  return null;
                },
                onSaved: (value) {
                  _instructions = value!;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _addMedicationField,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                ),
                child: Text('Add Medication'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _savePrescription,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  textStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                child: Text('Save Prescription', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.teal,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage: NetworkImage('https://example.com/profile_picture.png'),
                ),
                SizedBox(height: 10),
                Text(
                  'Dr. Ahmed Gomaa',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
                Text(
                  'neutrition',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: Icon(Icons.home, color: Colors.teal),
            title: Text('Home'),
            onTap: () {
              Navigator.pop(context); // Close the drawer
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HomePagepre()), // Navigate to HomePage
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.read_more_outlined, color: Colors.teal),
            title: Text('Make Appointment'),
            onTap: () {
              Navigator.pop(context); // Close the drawer
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddAppointmentPage()), // Navigate to AddTaskPage
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.account_circle, color: Colors.teal),
            title: Text('Profile'),
            onTap: () {
              Navigator.pop(context); // Close the drawer
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) =>  DoctorProfilePage(doctorName: '', gender: '', address: '', email: '', phone: '', qualifications: '', biography: '', avatarUrl: '',)),  // Navigate to PatientsListPage
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.stars_outlined, color: Colors.teal),
            title: Text('gemini'),
            onTap: () {
              Navigator.pop(context); // Close the drawer
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Geminipage ()), // Navigate to MainScreen
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.people, color: Colors.teal),
            title: Text('Patients'),
            onTap: () {
              Navigator.pop(context); // Close the drawer
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PatientsListPagepre()), // Navigate to PatientsListPage
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.logout, color: Colors.teal),
            title: Text('Logout'),
            onTap: () {
              Navigator.pop(context);
              // Perform logout action
            },
          ),
        ],
      ),
    );
  }
}

// Placeholder classes for navigation
class HomePagepre extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
      ),
      body: Center(
        child: Text('Home Page Content'),
      ),
    );
  }
}

class AddTaskPage extends StatelessWidget {
  final String generatedId;

  AddTaskPage({required this.generatedId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Task Page'),
      ),
      body: Center(
        child: Text('Add Task Page Content'),
      ),
    );
  }
}

class PatientsListPagepre extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Patients List Page'),
      ),
      body: Center(
        child: Text('Patients List Page Content'),
      ),
    );
  }
}
