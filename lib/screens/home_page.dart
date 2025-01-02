import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:neutrition_sqlite/screens/profilepage.dart';
import 'package:neutrition_sqlite/screens/theme.dart';
import 'package:neutrition_sqlite/servises/theme_servises.dart';

import '../tests/geminipage.dart';
import '../widgets/add_task_bar.dart';
import '../widgets/botton.dart';
import 'app.dart';
import 'login.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DateTime _selectedDate = DateTime.now();
  late Stream<List<Map<String, dynamic>>> _appointmentsStream;

  @override
  void initState() {
    super.initState();
    _appointmentsStream = _fetchAppointments(_selectedDate);
  }

  Stream<List<Map<String, dynamic>>> _fetchAppointments(DateTime selectedDate) {
    return FirebaseFirestore.instance.collection('patients').snapshots().asyncMap(
          (snapshot) async {
        List<Map<String, dynamic>> appointments = [];
        for (var patientDoc in snapshot.docs) {
          var appointmentsSnapshot = await patientDoc.reference
              .collection('appointments')
              .where('date', isEqualTo: selectedDate)
              .get();
          for (var appointmentDoc in appointmentsSnapshot.docs) {
            var appointmentData = appointmentDoc.data() as Map<String, dynamic>;
            appointments.add(appointmentData);
          }
        }
        return appointments;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      drawer: Drawer(
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
                    'Cardiologist',
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
                  MaterialPageRoute(builder: (context) => HomePage()), // Navigate to MainScreen
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.account_circle, color: Colors.teal),
              title: Text('profile'),
              onTap: () {
                Navigator.pop(context); // Close the drawer
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) =>DoctorProfilePage(doctorName: '', gender: '', address: '', email: '', phone: '', qualifications: '', biography: '', avatarUrl: '',)), // Navigate to MainScreen
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
              leading: Icon(Icons.settings, color: Colors.teal),
              title: Text('Settings'),
              onTap: () {
                Navigator.pop(context);
                // Navigate to settings page
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
      ),
      body: Column(
        children: [
          _addTaskBar(),
          _datePicker(),
          Expanded(child: _appointmentsList()),
        ],
      ),
    );
  }

  Widget _datePicker() {
    return Container(
      margin: const EdgeInsets.only(top: 20, left: 20),
      child: DatePicker(
        DateTime.now(),
        height: 100,
        width: 80,
        initialSelectedDate: DateTime.now(),
        selectionColor: Colors.blue,
        selectedTextColor: Colors.white,
        dateTextStyle: GoogleFonts.lato(
          textStyle: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.grey,
          ),
        ),
        dayTextStyle: GoogleFonts.lato(
          textStyle: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.grey,
          ),
        ),
        monthTextStyle: GoogleFonts.lato(
          textStyle: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w600,
            color: Colors.grey,
          ),
        ),
        onDateChange: (date) {
          setState(() {
            _selectedDate = date;
            _appointmentsStream = _fetchAppointments(_selectedDate);
          });
        },
      ),
    );
  }

  Widget _appointmentsList() {
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: _appointmentsStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No appointments found'));
        } else {
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              var appointment = snapshot.data![index];
              return _appointmentCard(appointment);
            },
          );
        }
      },
    );
  }

  Widget _appointmentCard(Map<String, dynamic> appointment) {
    return Card(
      margin: EdgeInsets.all(10),
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.all(15),
        leading: Icon(Icons.event, color: Colors.blue, size: 40),
        title: Text(
          appointment['title'] ?? 'No Title',
          style: GoogleFonts.lato(
            textStyle: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 5),
            Text(
              appointment['note'] ?? 'No Description',
              style: GoogleFonts.lato(
                textStyle: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
            ),
            SizedBox(height: 5),
            Text(
              'Time: ${appointment['startTime']} - ${appointment['endTime']}',
              style: GoogleFonts.lato(
                textStyle: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _addTaskBar() {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  DateFormat.yMMMMd().format(DateTime.now()),
                  style: subHeadingStyle,
                ),
                Text(
                  "Today",
                  style: headingStyle,
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddTaskPage(generatedId: '',)),
              );
            },
            child: Mybutton(
              label: "Appointment",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddAppointmentPage()),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _appBar() {
    return AppBar(
      leading: GestureDetector(
        onTap: () {
          themeservise().swiththeme();
        },
        child: Icon(
          Icons.nightlight_round,
          size: 20,
        ),
      ),
      actions: [
        GestureDetector(
          onTap: () {
            // Handle the onTap event for the person icon
            // For example, navigate to profile page
          },
          child: Icon(
            Icons.person,
            size: 20,
          ),
        ),
        SizedBox(width: 20),
      ],
    );
  }
}
