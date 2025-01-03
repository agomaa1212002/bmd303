import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_ml_kit/google_ml_kit.dart'; // Import the ML Kit package
import 'package:neutrition_sqlite/tests/prescp.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../screens/app.dart';
import '../screens/home_page.dart';
import '../screens/login.dart';
import '../screens/pateint.dart';
import '../screens/profilepage.dart';
import '../screens/t_plans_mean.screen.dart';


import '../widgets/add_task_bar.dart';
import 'geminipage.dart';
import 'ocrveiw.dart';

class DashboardPage extends StatelessWidget {
  final Map<String, String> patientData;

  DashboardPage({required this.patientData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${patientData['username']}\'s Dashboard'),
        backgroundColor: Colors.teal,
        actions: [
          IconButton(
            icon: Icon(Icons.brightness_6),
            onPressed: () {
              Provider.of<DashboardState>(context, listen: false).toggleTheme();
            },
          ),
        ],
      ),
      drawer: _buildDrawer(context),
      body: Row(
        children: [
          // Main Dashboard
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Search Bar and Quick Stats
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: 'Search',
                            prefixIcon: Icon(Icons.search),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                          onSubmitted: (value) {
                            Provider.of<DashboardState>(context, listen: false).updateSearchTerm(value);
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      QuickStat(icon: Icons.scanner_outlined, label: 'OCR'),
                      QuickStat(icon: Icons.directions_walk, label: 'Plans', patientId: patientData['id'], isPlans: true),
                      QuickStat(icon: Icons.medical_information, label: 'Prescription', patientId: patientData['id'], isPrescription: true),
                      QuickStat(icon: Icons.camera_alt, label: 'Add Photo', patientId: patientData['id']),
                    ],
                  ),
                  SizedBox(height: 20),
                  // BMI Overview Chart
                  Expanded(
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Text('BMI Overview', style: TextStyle(fontSize: 20)),
                            Expanded(child: BMIChart()),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Allergies and Drugs for ${patientData['username']}:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20),
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  Text('Allergies', style: TextStyle(fontSize: 20)),
                                  Expanded(
                                    child: StreamBuilder<QuerySnapshot>(
                                      stream: FirebaseFirestore.instance
                                          .collection('patients')
                                          .doc(patientData['id'])
                                          .collection('allergy')
                                          .snapshots(),
                                      builder: (context, snapshot) {
                                        if (!snapshot.hasData) {
                                          return Center(child: CircularProgressIndicator());
                                        }
                                        var allergies = snapshot.data!.docs;
                                        return ListView.builder(
                                          itemCount: allergies.length,
                                          itemBuilder: (context, index) {
                                            var allergy = allergies[index];
                                            return ListTile(
                                              title: Text(allergy['allergyName']),
                                            );
                                          },
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 20),
                        Expanded(
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  Text('Drugs', style: TextStyle(fontSize: 20)),
                                  Expanded(
                                    child: StreamBuilder<QuerySnapshot>(
                                      stream: FirebaseFirestore.instance
                                          .collection('patients')
                                          .doc(patientData['id'])
                                          .collection('drugs')
                                          .snapshots(),
                                      builder: (context, snapshot) {
                                        if (!snapshot.hasData) {
                                          return Center(child: CircularProgressIndicator());
                                        }
                                        var drugs = snapshot.data!.docs;
                                        return ListView.builder(
                                          itemCount: drugs.length,
                                          itemBuilder: (context, index) {
                                            var drug = drugs[index];
                                            var time = drug['time'] as Timestamp;
                                            var formattedTime = DateFormat('yyyy-MM-dd – kk:mm').format(time.toDate());
                                            return ListTile(
                                              title: Text(drug['username']),
                                              subtitle: Text('Dose: ${drug['dose']}, Interval: ${drug['interval']}, Time: $formattedTime'),
                                            );
                                          },
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Right Sidebar for PDF Files and Appointments
          Container(
            width: 300,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Text(
                    'PDF Files for ${patientData['username']}:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Expanded(
                    child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('patients')
                          .doc(patientData['id'])
                          .collection('pdf files')
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Center(child: CircularProgressIndicator());
                        }
                        var pdfFiles = snapshot.data!.docs;
                        return ListView.builder(
                          itemCount: pdfFiles.length,
                          itemBuilder: (context, index) {
                            var pdfFile = pdfFiles[index];
                            return CachedNetworkImage(
                              imageUrl: pdfFile['image_url'],
                              placeholder: (context, url) => CircularProgressIndicator(),
                              errorWidget: (context, url, error) => Icon(Icons.error),
                            );
                          },
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Appointments for ${patientData['username']}:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Expanded(
                    child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('patients')
                          .doc(patientData['id'])
                          .collection('appointments')
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Center(child: CircularProgressIndicator());
                        }
                        var appointments = snapshot.data!.docs;
                        return ListView.builder(
                          itemCount: appointments.length,
                          itemBuilder: (context, index) {
                            var appointment = appointments[index];
                            var date = appointment['date'] as Timestamp;
                            var formattedDate = DateFormat('yyyy-MM-dd – kk:mm').format(date.toDate());
                            return ListTile(
                              title: Text(appointment['title']),
                              subtitle: Text('Date: $formattedDate'),
                            );
                          },
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
                  'Hi Doctor',
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
            leading: Icon(Icons.stars_outlined, color: Colors.teal),
            title: Text('AI'),
            onTap: () {
              Navigator.pop(context); // Close the drawer
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Geminipage()), // Navigate to HomePage
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
                MaterialPageRoute(builder: (context) =>DoctorProfilePage(doctorName: '', gender: '', address: '', email: '', phone: '', qualifications: '', biography: '', avatarUrl: '',)),  // Navigate to PatientsListPage
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

  List<ChartData> getChartData() {
    final List<ChartData> chartData = [
      ChartData('Protein', 25),
      ChartData('Carbs', 35),
      ChartData('Fat', 15),
      ChartData('Fiber', 20),
      ChartData('Sugar', 5)
    ];
    return chartData;
  }
}

class SidebarItem extends StatelessWidget {
  final IconData icon;
  final String text;
  final bool isSelected;

  SidebarItem({required this.icon, required this.text, this.isSelected = false});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(text, style: TextStyle(color: Colors.white)),
      onTap: () {
        print('$text clicked'); // Replace with navigation logic
      },
    );
  }
}

class QuickStat extends StatefulWidget {
  final IconData icon;
  final String label;
  final String? patientId; // Optional patientId for adding photos
  final bool isPrescription; // Optional flag for prescription navigation
  final bool isPlans; // Optional flag for plans navigation

  QuickStat({required this.icon, required this.label, this.patientId, this.isPrescription = false, this.isPlans = false});

  @override
  _QuickStatState createState() => _QuickStatState();
}

class _QuickStatState extends State<QuickStat> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final ImagePicker _picker = ImagePicker();
  XFile? _image;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = pickedFile;
      });

      // Upload the image to Firebase Storage and get the URL
      final storageRef = FirebaseStorage.instance.ref().child('pdf files/${widget.patientId}/${pickedFile.name}');
      final uploadTask = storageRef.putFile(File(pickedFile.path));
      final snapshot = await uploadTask.whenComplete(() => {});
      final downloadUrl = await snapshot.ref.getDownloadURL();

      // Add the image URL to Firestore
      FirebaseFirestore.instance
          .collection('patients')
          .doc(widget.patientId)
          .collection('pdf files')
          .add({'image_url': downloadUrl});
    }
  }

  Future<void> _performOCR() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final inputImage = InputImage.fromFilePath(pickedFile.path);
      final textRecognizer = GoogleMlKit.vision.textRecognizer();
      final RecognizedText recognizedText = await textRecognizer.processImage(inputImage);
      await textRecognizer.close();

      String extractedText = recognizedText.text;
      print('Extracted Text: $extractedText');

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => OcrResultPage(extractedText: extractedText),
        ),
      );
    }
  }

  void _handleTap() {
    if (widget.label == 'OCR') {
      _performOCR();
    } else if (widget.isPrescription) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => PrescriptionScreen()),
      );
    } else if (widget.isPlans) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => TreatmentPlan()),
      );
    } else if (widget.patientId != null) {
      _pickImage();
    } else {
      _controller.forward().then((_) => _controller.reverse());
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: Tween<double>(begin: 1.0, end: 1.1).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Curves.easeInOut,
        ),
      ),
      child: GestureDetector(
        onTap: _handleTap,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Container(
            width: 100,
            height: 100,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(widget.icon, size: 40, color: Colors.blue),
                SizedBox(height: 10),
                Text(widget.label),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class BMIChart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
      primaryXAxis: CategoryAxis(),
      series: <CartesianSeries>[
        LineSeries<ChartData, String>(
          dataSource: [
            ChartData('Jan', 60),
            ChartData('Feb', 62),
            ChartData('Mar', 65),
            ChartData('Apr', 70),
            ChartData('May', 72),
            ChartData('Jun', 75),
            ChartData('Jul', 80),
            ChartData('Aug', 85),
            ChartData('Sep', 90),
          ],
          xValueMapper: (ChartData data, _) => data.month,
          yValueMapper: (ChartData data, _) => data.value,
          dataLabelSettings: DataLabelSettings(isVisible: true),
          enableTooltip: true,
        ),
        LineSeries<ChartData, String>(
          dataSource: [
            ChartData('Jan', 55),
            ChartData('Feb', 58),
            ChartData('Mar', 60),
            ChartData('Apr', 63),
            ChartData('May', 65),
            ChartData('Jun', 68),
            ChartData('Jul', 70),
            ChartData('Aug', 72),
            ChartData('Sep', 75),
          ],
          xValueMapper: (ChartData data, _) => data.month,
          yValueMapper: (ChartData data, _) => data.value,
          dataLabelSettings: DataLabelSettings(isVisible: true),
          enableTooltip: true,
        ),
      ],
    );
  }
}

class ProfilePictureUpload extends StatefulWidget {
  @override
  _ProfilePictureUploadState createState() => _ProfilePictureUploadState();
}

class _ProfilePictureUploadState extends State<ProfilePictureUpload> {
  XFile? _image;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = pickedFile;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: InkWell(
        onTap: _pickImage,
        child: Container(
          height: 100,
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(8.0),
            image: _image != null
                ? DecorationImage(image: FileImage(File(_image!.path)), fit: BoxFit.cover)
                : null,
          ),
          child: _image == null
              ? Center(
            child: Icon(Icons.camera_alt, color: Colors.white, size: 50),
          )
              : null,
        ),
      ),
    );
  }
}

class ScheduleItem extends StatelessWidget {
  final String doctor;
  final String time;

  ScheduleItem({required this.doctor, required this.time});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(8.0),
        ),
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(doctor, style: TextStyle(color: Colors.white)),
            SizedBox(height: 5),
            Text(time, style: TextStyle(color: Colors.white)),
          ],
        ),
      ),
    );
  }
}

class ChartData {
  final String month;
  final double value;

  ChartData(this.month, this.value);
}

class DashboardState extends ChangeNotifier {
  String _searchTerm = '';
  bool _isDarkMode = false;

  String get searchTerm => _searchTerm;
  bool get isDarkMode => _isDarkMode;

  void updateSearchTerm(String term) {
    _searchTerm = term;
    notifyListeners();
  }

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }
}

class ThemeService with ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;

  ThemeMode get theme => _themeMode;

  void switchTheme() {
    _themeMode = _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
}

class Themes {
  static final light = ThemeData(
    primarySwatch: Colors.teal,
    brightness: Brightness.light,
  );

  static final dark = ThemeData(
    primarySwatch: Colors.teal,
    brightness: Brightness.dark,
  );
}
