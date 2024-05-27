import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:neutrition_sqlite/tests/dachbourd.dart';

import '../tests/combined_dashboard.dart';
import 'main_screen.dart';

// class PatientListScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Patient List'),
//       ),
//       body: StreamBuilder(
//         stream: FirebaseFirestore.instance.collection('patients').snapshots(),
//         builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
//           if (!snapshot.hasData) {
//             return Center(
//               child: CircularProgressIndicator(),
//             );
//           }
//           final patients = snapshot.data!.docs;
//
//           return ListView.builder(
//             itemCount: patients.length,
//             itemBuilder: (context, index) {
//               var patientData = patients[index].data() as Map<String, dynamic>;
//               return ListTile(
//                 leading: CircleAvatar(
//                   backgroundImage: AssetImage('assets/images/profile_placeholder.png'), // Use appropriate image here
//                 ),
//                 title: Text(patientData['username'] ?? ''),
//                 subtitle: Text(patientData['email'] ?? ''),
//                 trailing: Row(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//
//                     IconButton(
//                       icon: Icon(Icons.delete,color: Colors.red,),
//                       onPressed: () {
//                         // Show delete confirmation dialog
//                         _showDeleteConfirmationDialog(context, patientData);
//                       },
//                     ),
//                   ],
//                 ),
//                 onTap: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => PatientDetailsPage( patientData: {},),
//                     ),
//                   );
//                 },
//               );
//             },
//           );
//         },
//       ),
//     );
//   }

  // void _showDeleteConfirmationDialog(BuildContext context, Map<String, dynamic> patientData) {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: Text('Delete Patient'),
  //         content: Text('Are you sure you want to delete this patient?'),
  //         actions: [
  //           TextButton(
  //             onPressed: () {
  //               Navigator.pop(context); // Close the dialog
  //             },
  //             child: Text('Cancel', style: TextStyle(color: Colors.white)),
  //             style: TextButton.styleFrom(backgroundColor: Colors.blue),
  //           ),
  //           TextButton(
  //             onPressed: () {
  //               // Perform delete operation
  //               _deletePatient(patientData);
  //               Navigator.pop(context); // Close the dialog
  //             },
  //             child: Text('Confirm', style: TextStyle(color: Colors.white)),
  //             style: TextButton.styleFrom(backgroundColor: Colors.red),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

//   void _deletePatient(Map<String, dynamic> patientData) {
//     // Implement deletion logic here
//     // For example:
//     // FirebaseFirestore.instance.collection('patients').doc(patientData['id']).delete();
//   }
// }
//


// class PatientDetailsScreen extends StatelessWidget {
//   final Map<String, dynamic> patientData;
//
//   const PatientDetailsScreen(this.patientData);
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Patient Details'),
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Container(
//               height: 200,
//               decoration: BoxDecoration(
//                 color: Colors.grey[300],
//                 image: DecorationImage(
//                   image: AssetImage('assets/images/profile_placeholder.png'),
//                   fit: BoxFit.cover,
//                 ),
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     'Username:',
//                     style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
//                   ),
//                   SizedBox(height: 8),
//                   Text(
//                     patientData['username'] ?? '',
//                     style: TextStyle(fontSize: 16),
//                   ),
//                   SizedBox(height: 16),
//                   Text(
//                     'National ID:',
//                     style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
//                   ),
//                   SizedBox(height: 8),
//                   Text(
//                     patientData['nationalId'] ?? '',
//                     style: TextStyle(fontSize: 16),
//                   ),
//                   SizedBox(height: 16),
//                   Text(
//                     'Email:',
//                     style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
//                   ),
//                   SizedBox(height: 8),
//                   Text(
//                     patientData['email'] ?? '',
//                     style: TextStyle(fontSize: 16),
//                   ),
//                   SizedBox(height: 16),
//                   Text(
//                     'Phone:',
//                     style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
//                   ),
//                   SizedBox(height: 8),
//                   Text(
//                     patientData['phone'] ?? '',
//                     style: TextStyle(fontSize: 16),
//                   ),
//                   SizedBox(height: 24),
//                   // Button to navigate to main_screen.dart
//                   TextButton(
//                     onPressed: () {
//                       Get.to(() => DashboardPage(patientData: {},));
//                     },
//                     child: const Text(
//                       'Back to Main Screen',
//                       style: TextStyle(color: Colors.blue),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

class PatientsListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Patients List'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('patients').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          var patients = snapshot.data!.docs;
          return ListView.builder(
            itemCount: patients.length,
            itemBuilder: (context, index) {
              var patient = patients[index].data() as Map<String, dynamic>;
              return ListTile(
                title: Text(patient['username'] ?? 'No Name'),
                subtitle: Text(patient['email'] ?? 'No Email'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PatientDetailsPage(
                        patientData: {
                          'id': patients[index].id,
                          'username': patient['username'],
                          'email': patient['email'],
                        },
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}







class PatientDetailsPage extends StatelessWidget {
  final Map<String, String> patientData;

  PatientDetailsPage({required this.patientData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(patientData['username'] ?? 'Patient Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Name: ${patientData['username'] ?? 'N/A'}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 8),
            Text(
              'Email: ${patientData['email'] ?? 'N/A'}',
              style: TextStyle(fontSize: 18),
            ),
            // يمكنك إضافة باقي المعلومات هنا
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DashboardPage(patientData: patientData),
                  ),
                );
              },
              child: Text('Go to Dashboard'),
            ),
          ],
        ),
      ),
    );
  }
}
