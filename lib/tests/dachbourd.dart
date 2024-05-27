// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
//
// import 'package:syncfusion_flutter_charts/charts.dart';
// import 'dart:io'; // Ensure correct File class is imported
// import 'package:image_picker/image_picker.dart';
//
// class dash extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('nutrition_sqlite'),
//         actions: [
//           IconButton(
//             icon: Icon(Icons.brightness_6),
//             onPressed: () {
//               Provider.of<DashboardState>(context, listen: false).toggleTheme();
//             },
//           ),
//         ],
//       ),
//       body: Row(
//         children: [
//           // Sidebar
//           CollapsibleSidebar(),
//           // Main Dashboard
//           Expanded(
//             child: Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Column(
//                 children: [
//                   // Search Bar and Quick Stats
//                   Row(
//                     children: [
//                       Expanded(
//                         child: TextField(
//                           decoration: InputDecoration(
//                             hintText: 'Search',
//                             prefixIcon: Icon(Icons.search),
//                             border: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(8.0),
//                             ),
//                           ),
//                           onSubmitted: (value) {
//                             Provider.of<DashboardState>(context, listen: false).updateSearchTerm(value);
//                           },
//                         ),
//                       ),
//                     ],
//                   ),
//                   SizedBox(height: 20),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceAround,
//                     children: [
//                       QuickStat(icon: Icons.local_fire_department, label: 'Calories burned'),
//                       QuickStat(icon: Icons.directions_walk, label: 'Steps'),
//                       QuickStat(icon: Icons.map, label: 'Distance'),
//                       QuickStat(icon: Icons.nightlight_round, label: 'Sleep'),
//                     ],
//                   ),
//                   SizedBox(height: 20),
//                   // BMI Overview Chart
//                   Expanded(
//                     child: Card(
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(10.0),
//                       ),
//                       child: Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: Column(
//                           children: [
//                             Text('BMI Overview', style: TextStyle(fontSize: 20)),
//                             Expanded(child: BMIChart()),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           // Right Sidebar
//
//         ],
//       ),
//     );
//   }
// }
//
// class CollapsibleSidebar extends StatefulWidget {
//   @override
//   _CollapsibleSidebarState createState() => _CollapsibleSidebarState();
// }
//
// class _CollapsibleSidebarState extends State<CollapsibleSidebar> with SingleTickerProviderStateMixin {
//   late AnimationController _controller;
//   late Animation<double> _widthAnimation;
//   bool _isCollapsed = true;
//
//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(
//       duration: const Duration(milliseconds: 300),
//       vsync: this,
//     );
//     _widthAnimation = Tween<double>(begin: 200, end: 60).animate(_controller);
//   }
//
//   void _toggleSidebar() {
//     setState(() {
//       _isCollapsed = !_isCollapsed;
//       _isCollapsed ? _controller.reverse() : _controller.forward();
//     });
//   }
//
//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return AnimatedBuilder(
//       animation: _controller,
//       builder: (context, child) {
//         return Container(
//           width: _widthAnimation.value,
//           color: Colors.black87,
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.start,
//             children: [
//               IconButton(
//                 icon: Icon(_isCollapsed ? Icons.menu : Icons.arrow_back),
//                 color: Colors.white,
//                 onPressed: _toggleSidebar,
//               ),
//               SidebarItem(icon: Icons.home, text: 'Dashboard', isSelected: true),
//               SidebarItem(icon: Icons.person, text: 'Profile'),
//               SidebarItem(icon: Icons.directions_run, text: 'Exercise'),
//               SidebarItem(icon: Icons.settings, text: 'Settings'),
//               SidebarItem(icon: Icons.history, text: 'History'),
//               SidebarItem(icon: Icons.logout, text: 'SignOut'),
//             ],
//           ),
//         );
//       },
//     );
//   }
// }
//
// class SidebarItem extends StatelessWidget {
//   final IconData icon;
//   final String text;
//   final bool isSelected;
//
//   SidebarItem({required this.icon, required this.text, this.isSelected = false});
//
//   @override
//   Widget build(BuildContext context) {
//     return ListTile(
//       leading: Icon(icon, color: Colors.white),
//       title: Text(text, style: TextStyle(color: Colors.white)),
//       onTap: () {
//         print('$text clicked'); // Replace with navigation logic
//       },
//     );
//   }
// }
//
// class QuickStat extends StatefulWidget {
//   final IconData icon;
//   final String label;
//
//   QuickStat({required this.icon, required this.label});
//
//   @override
//   _QuickStatState createState() => _QuickStatState();
// }
//
// class _QuickStatState extends State<QuickStat> with SingleTickerProviderStateMixin {
//   late AnimationController _controller;
//
//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(
//       duration: const Duration(milliseconds: 300),
//       vsync: this,
//     );
//   }
//
//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }
//
//   void _handleTap() {
//     _controller.forward().then((_) => _controller.reverse());
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return ScaleTransition(
//       scale: Tween<double>(begin: 1.0, end: 1.1).animate(
//         CurvedAnimation(
//           parent: _controller,
//           curve: Curves.easeInOut,
//         ),
//       ),
//       child: GestureDetector(
//         onTap: _handleTap,
//         child: Card(
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(8.0),
//           ),
//           child: Container(
//             width: 100,
//             height: 100,
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Icon(widget.icon, size: 40, color: Colors.blue),
//                 SizedBox(height: 10),
//                 Text(widget.label),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// class BMIChart extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return SfCartesianChart(
//       primaryXAxis: CategoryAxis(),
//       series: <CartesianSeries>[
//         LineSeries<ChartData, String>(
//           dataSource: [
//             ChartData('Jan', 60),
//             ChartData('Feb', 62),
//             ChartData('Mar', 65),
//             ChartData('Apr', 70),
//             ChartData('May', 72),
//             ChartData('Jun', 75),
//             ChartData('Jul', 80),
//             ChartData('Aug', 85),
//             ChartData('Sep', 90),
//           ],
//           xValueMapper: (ChartData data, _) => data.month,
//           yValueMapper: (ChartData data, _) => data.value,
//           dataLabelSettings: DataLabelSettings(isVisible: true),
//           enableTooltip: true,
//         ),
//         LineSeries<ChartData, String>(
//           dataSource: [
//             ChartData('Jan', 55),
//             ChartData('Feb', 58),
//             ChartData('Mar', 60),
//             ChartData('Apr', 63),
//             ChartData('May', 65),
//             ChartData('Jun', 68),
//             ChartData('Jul', 70),
//             ChartData('Aug', 72),
//             ChartData('Sep', 75),
//           ],
//           xValueMapper: (ChartData data, _) => data.month,
//           yValueMapper: (ChartData data, _) => data.value,
//           dataLabelSettings: DataLabelSettings(isVisible: true),
//           enableTooltip: true,
//         )
//       ],
//     );
//   }
// }
//
// class ProfilePictureUpload extends StatefulWidget {
//   @override
//   _ProfilePictureUploadState createState() => _ProfilePictureUploadState();
// }
//
// class _ProfilePictureUploadState extends State<ProfilePictureUpload> {
//   XFile? _image;
//   final ImagePicker _picker = ImagePicker();
//
//   Future<void> _pickImage() async {
//     final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
//     setState(() {
//       _image = pickedFile;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(16.0),
//       child: InkWell(
//         onTap: _pickImage,
//         child: Container(
//           height: 100,
//           decoration: BoxDecoration(
//             color: Colors.black,
//             borderRadius: BorderRadius.circular(8.0),
//             image: _image != null
//                 ? DecorationImage(image: FileImage(File(_image!.path)), fit: BoxFit.cover)
//                 : null,
//           ),
//           child: _image == null
//               ? Center(
//             child: Icon(Icons.camera_alt, color: Colors.white, size: 50),
//           )
//               : null,
//         ),
//       ),
//     );
//   }
// }
//
// class ScheduleItem extends StatelessWidget {
//   final String doctor;
//   final String time;
//
//   ScheduleItem({required this.doctor, required this.time});
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8.0),
//       child: Container(
//         decoration: BoxDecoration(
//           color: Colors.black,
//           borderRadius: BorderRadius.circular(8.0),
//         ),
//         padding: const EdgeInsets.all(8.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(doctor, style: TextStyle(color: Colors.white)),
//             SizedBox(height: 5),
//             Text(time, style: TextStyle(color: Colors.white)),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class ChartData {
//   final String month;
//   final double value;
//
//   ChartData(this.month, this.value);
// }
//
//
// class DashboardState extends ChangeNotifier {
//   String _searchTerm = '';
//   bool _isDarkMode = false;
//
//   String get searchTerm => _searchTerm;
//   bool get isDarkMode => _isDarkMode;
//
//   void updateSearchTerm(String term) {
//     _searchTerm = term;
//     notifyListeners();
//   }
//
//   void toggleTheme() {
//     _isDarkMode = !_isDarkMode;
//     notifyListeners();
//   }
// }
//
//
// class ThemeService with ChangeNotifier {
//   ThemeMode _themeMode = ThemeMode.light;
//
//   ThemeMode get theme => _themeMode;
//
//   void switchTheme() {
//     _themeMode = _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
//     notifyListeners();
//   }
// }
//
//
// class Themes {
//   static final light = ThemeData(
//     primarySwatch: Colors.blue,
//     brightness: Brightness.light,
//   );
//
//   static final dark = ThemeData(
//     primarySwatch: Colors.blue,
//     brightness: Brightness.dark,
//   );
// }
//
//
