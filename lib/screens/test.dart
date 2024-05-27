import 'package:flutter/material.dart';

class BookingPage extends StatefulWidget {
  @override
  _BookingPageState createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  String _name = '';
  String _note = '';
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now();

  void _setName(String name) {
    setState(() {
      _name = name;
    });
  }

  void _setNote(String note) {
    setState(() {
      _note = note;
    });
  }

  void _setStartDate(DateTime startDate) {
    setState(() {
      _startDate = startDate;
    });
  }

  void _setEndDate(DateTime endDate) {
    setState(() {
      _endDate = endDate;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Booking'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(labelText: 'Name'),
              onChanged: (value) => _setName(value),
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Note'),
              onChanged: (value) => _setNote(value),
            ),
            Row(
              children: [
                Text('Start Date:'),
                TextButton(
                  onPressed: () => _selectStartDate(context),
                  child: Text(_startDate.toString()),
                ),
              ],
            ),
            Row(
              children: [
                Text('End Date:'),
                TextButton(
                  onPressed: () => _selectEndDate(context),
                  child: Text(_endDate.toString()),
                ),
              ],
            ),
            ElevatedButton(
              onPressed: () {
                // Handle booking creation
              },
              child: Text('Create Booking'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectStartDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _startDate,
      firstDate: DateTime(2024),
      lastDate: DateTime(2025),
    );
    if (picked != null && picked != _startDate) {
      _setStartDate(picked);
    }
  }

  Future<void> _selectEndDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _endDate,
      firstDate: DateTime(2024),
      lastDate: DateTime(2025),
    );
    if (picked != null && picked != _endDate) {
      _setEndDate(picked);
    }
  }
}