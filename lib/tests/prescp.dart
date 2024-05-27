import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class PrescriptionApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Prescription App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
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
      String token = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJodHRwOi8vc2NoZW1hcy54bWxzb2FwLm9yZy93cy8yMDA1LzA1L2lkZW50aXR5L2NsYWltcy9uYW1lIjoiamFuYWFtZXJtb2hhbWVkIiwiaHR0cDovL3NjaGVtYXMueG1sc29hcC5vcmcvd3MvMjAwNS8wNS9pZGVudGl0eS9jbGFpbXMvbmFtZWlkZW50aWZpZXIiOiJkODM4ZTQyZC0zZjdkLTQ2OTEtYWUxNy01ODUwNDM4NGRhZjMiLCJqdGkiOiIxNGE0OTkxZC0zYmZhLTQzMGItOWU4Zi1jMzBmZjRjNjU4YjciLCJleHAiOjE3MTY2Nzk1MTUsImlzcyI6ImFwaS5zaW1wbGlmaWVyLm5ldCIsImF1ZCI6ImFwaS5zaW1wbGlmaWVyLm5ldCJ9.CEJDQ0aVFqKatKlSi94gxiRz2Bly0bwkKciTIjsmMtY'; // Shortened for brevity

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
      ),
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
                child: Text('Add Medication'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _savePrescription,
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.blue), // Change the color here
                ),
                child: Text('Save Prescription', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
