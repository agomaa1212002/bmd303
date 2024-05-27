import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DoctorSignupPage extends StatelessWidget {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();

  void _signupDoctor(BuildContext context) {
    String username = usernameController.text.trim();
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    String firstName = firstNameController.text.trim();
    String lastName = lastNameController.text.trim();

    if (username.isNotEmpty &&
        email.isNotEmpty &&
        password.isNotEmpty &&
        firstName.isNotEmpty &&
        lastName.isNotEmpty) {
      // Add doctor to Firestore
      FirebaseFirestore.instance.collection('doctors').add({
        'dr_username': username,
        'dr_email': email,
        'dr_password': password,
        'dr_firstname': firstName,
        'dr_lastname': lastName,
      }).then((value) {
        // Success message or navigation to another page
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Doctor signup successful')),
        );
      }).catchError((error) {
        // Error handling
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error signing up')),
        );
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill all fields')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Doctor Signup'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: usernameController,
              decoration: InputDecoration(labelText: 'Doctor Username'),
            ),
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Doctor Email'),
            ),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: 'Doctor Password'),
              obscureText: true,
            ),
            TextField(
              controller: firstNameController,
              decoration: InputDecoration(labelText: 'Doctor First Name'),
            ),
            TextField(
              controller: lastNameController,
              decoration: InputDecoration(labelText: 'Doctor Last Name'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _signupDoctor(context),
              child: Text('Signup'),
            ),
          ],
        ),
      ),
    );
  }
}
