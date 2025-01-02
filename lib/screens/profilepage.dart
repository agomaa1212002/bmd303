import 'package:flutter/material.dart';
import 'package:neutrition_sqlite/screens/pateint.dart';

import '../tests/geminipage.dart';
import '../tests/prescp.dart';
import 'app.dart';

class DoctorProfilePage extends StatelessWidget {
  final String doctorName;
  final String gender;
  final String address;
  final String email;
  final String phone;
  final String qualifications;
  final String biography;
  final String avatarUrl; // URL for doctor's avatar (profile picture)

  DoctorProfilePage({
    required this.doctorName,
    required this.gender,
    required this.address,
    required this.email,
    required this.phone,
    required this.qualifications,
    required this.biography,
    required this.avatarUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Doctor Profile'),
        backgroundColor: Colors.teal,
        elevation: 4, // A subtle shadow for the AppBar
      ),
      drawer: _buildDrawer(context), // Add the drawer here
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView( // To prevent overflow on smaller devices
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Avatar Section
              Center(
                child: CircleAvatar(
                  radius: 60, // Size of the avatar
                  backgroundImage: NetworkImage(avatarUrl),
                  backgroundColor: Colors.teal.shade200, // Background color if image is not available
                ),
              ),
              SizedBox(height: 20),

              // Doctor's Name with a header
              Text(
                doctorName,
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal,
                  letterSpacing: 1.2,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10),
              Text(
                '$gender • $email',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.teal.shade700,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),

              // Profile Information Cards
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 4,
                color: Colors.teal.shade50, // Light background for the card
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      _buildInfoRow('Name', doctorName),
                      _buildInfoRow('Gender', gender),
                      _buildInfoRow('Address', address),
                      _buildInfoRow('Email', email),
                      _buildInfoRow('Phone', phone),
                      _buildInfoRow('Qualifications', qualifications),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),

              // Biography Section with additional styling
              Text(
                'Biography',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal,
                ),
              ),
              SizedBox(height: 10),
              Text(
                biography,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.teal.shade600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // A reusable widget to display info rows (e.g., "Name: John Doe")
  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.teal.shade800,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              color: Colors.teal.shade600,
            ),
          ),
        ],
      ),
    );
  }

  // Drawer widget
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
                  'Nutrition',
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
                MaterialPageRoute(
                  builder: (context) => DoctorProfilePage(
                    doctorName: '',
                    gender: '',
                    address: '',
                    email: '',
                    phone: '',
                    qualifications: '',
                    biography: '',
                    avatarUrl: '',
                  ),
                ),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.stars_outlined, color: Colors.teal),
            title: Text('Gemini'),
            onTap: () {
              Navigator.pop(context); // Close the drawer
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) =>  Geminipage()), // Navigate to Gemini page
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
                MaterialPageRoute(builder: (context) => PatientsListPage()), // Navigate to Patients List page
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
