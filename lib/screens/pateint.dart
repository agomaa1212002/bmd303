import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:neutrition_sqlite/screens/profilepage.dart';
import '../tests/combined_dashboard.dart';

import '../tests/geminipage.dart';
import 'app.dart';
import 'login.dart';
import 'main_screen.dart';
import 'home_page.dart';
import '../widgets/add_task_bar.dart';

class PatientsListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Patients List'),
        backgroundColor: Colors.teal,
      ),
      drawer: _buildDrawer(context),
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
                leading: Icon(Icons.person, color: Colors.teal),
                title: Text(
                  patient['username'] ?? 'No Name',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                subtitle: Text(patient['email'] ?? 'No Email'),
                trailing: IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () async {
                    bool confirmed = await _showConfirmationDialog(context);
                    if (confirmed) {
                      await FirebaseFirestore.instance
                          .collection('patients')
                          .doc(patients[index].id)
                          .delete();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Patient deleted')),
                      );
                    }
                  },
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PatientDetailsPage(
                        patientData: {
                          'id': patients[index].id,
                          'username': patient['username'] ?? '',
                          'email': patient['email'] ?? '',
                          'phone': patient['phone'] ?? '',
                          'nationalId': patient['nationalId'] ?? '',
                          'password': patient['password'] ?? '',
                          'currentDayActivity': patient['currentDayActivity'].toString(),
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

  Future<bool> _showConfirmationDialog(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Confirm Deletion'),
        content: Text('Are you sure you want to delete this patient?'),
        actions: [
          TextButton(
            child: Text('Cancel'),
            onPressed: () => Navigator.of(context).pop(false),
          ),
          TextButton(
            child: Text('Delete'),
            onPressed: () => Navigator.of(context).pop(true),
          ),
        ],
      ),
    );

    return result ?? false;
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
                MaterialPageRoute(builder: (context) => HomePage()), // Navigate to HomePage
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
                MaterialPageRoute(builder: (context) => AddTaskPage(generatedId: '',)), // Navigate to AddTaskPage
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
                MaterialPageRoute(builder: (context) =>DoctorProfilePage(doctorName: '', gender: '', address: '', email: '', phone: '', qualifications: '', biography: '', avatarUrl: '',)), // Navigate to PatientsListPage
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
                MaterialPageRoute(builder: (context) => PatientsListPage()), // Navigate to PatientsListPage
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

class PatientDetailsPage extends StatelessWidget {
  final Map<String, String> patientData;

  PatientDetailsPage({required this.patientData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(patientData['username'] ?? 'Patient Details'),
        backgroundColor: Colors.teal,
      ),
      drawer: _buildDrawer(context),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage('https://example.com/profile_picture.png'),
            ),
            SizedBox(height: 20),
            Text(
              patientData['username'] ?? 'N/A',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            Text(
              'Email: ${patientData['email'] ?? 'N/A'}',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
            SizedBox(height: 20),
            Divider(color: Colors.teal),
            ListTile(
              leading: Icon(Icons.phone, color: Colors.teal),
              title: Text('Phone'),
              subtitle: Text(patientData['phone'] ?? 'N/A'),
            ),
            ListTile(
              leading: Icon(Icons.badge, color: Colors.teal),
              title: Text('National ID'),
              subtitle: Text(patientData['nationalId'] ?? 'N/A'),
            ),
            ListTile(
              leading: Icon(Icons.lock, color: Colors.teal),
              title: Text('Password'),
              subtitle: Text(patientData['password'] ?? 'N/A'),
            ),
            ListTile(
              leading: Icon(Icons.directions_run, color: Colors.teal),
              title: Text('Current Day Activity'),
              subtitle: Text(patientData['currentDayActivity'] ?? 'N/A'),
            ),
            Spacer(),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DashboardPage(patientData: patientData),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                textStyle: TextStyle(fontSize: 18),
              ),
              child: Text('Go to Dashboard'),
            ),
          ],
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
                MaterialPageRoute(builder: (context) => HomePage()), // Navigate to HomePage
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
                MaterialPageRoute(builder: (context) => DoctorProfilePage(doctorName: '', gender: '', address: '', email: '', phone: '', qualifications: '', biography: '', avatarUrl: '',)),  // Navigate to PatientsListPage
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
                MaterialPageRoute(builder: (context) => PatientsListPage()), // Navigate to PatientsListPage
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
