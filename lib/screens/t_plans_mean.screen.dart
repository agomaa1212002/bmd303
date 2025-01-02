import 'package:flutter/material.dart';
import 'package:neutrition_sqlite/screens/login.dart';
import 'package:neutrition_sqlite/screens/pateint.dart';
import 'package:neutrition_sqlite/screens/profilepage.dart';
import '../tests/geminipage.dart';
import '../util/responsive.dart';
import '../widgets/dashboard_widget.dart';
import '../widgets/side_menu_widget.dart';
import '../widgets/summary_widget.dart';
import 'Treatment_Plan_Page.dart';
import 'home_page.dart';
import 'main_screen.dart';
import 'myplans.dart';

class TreatmentPlan extends StatelessWidget {
  const TreatmentPlan({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Treatment Plan'),
        backgroundColor: Colors.teal,
      ),
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
              title: Text('Profile'),
              onTap: () {
                Navigator.pop(context); // Close the drawer
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DoctorProfilePage(doctorName: '', gender: '', address: '', email: '', phone: '', qualifications: '', biography: '', avatarUrl: '',)), // Navigate to MainScreen
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
              leading: Icon(Icons.people_alt_outlined, color: Colors.teal),
              title: Text('patenits'),
              onTap: () {
                Navigator.pop(context); // Close the drawer
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) =>  PatientsListPage()), // Navigate to MainScreen
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
      ),
      endDrawer: Responsive.isMobile(context)
          ? SizedBox(
        width: MediaQuery.of(context).size.width * 0.8,
        // child: const SummaryWidget(),
      )
          : null,
      body: SafeArea(
        child: Row(
          children: [
            Expanded(
              flex: 7,
              child: FoodCalorieApp(),
            ),
            Expanded(
              flex: 3,
              child: MyAppplan(),
            ),
          ],
        ),
      ),
    );
  }
}
