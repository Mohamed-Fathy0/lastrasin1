import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class VisitPackagesScreen extends StatefulWidget {
  const VisitPackagesScreen({super.key});

  @override
  _VisitPackagesScreenState createState() => _VisitPackagesScreenState();
}

class _VisitPackagesScreenState extends State<VisitPackagesScreen> {
  DateTime selectedDate = DateTime.now();
  int selectedHour = 1;
  String selectedAmPm = 'صباحاً';
  final _phoneNumberController =
      TextEditingController(); // Controller for phone number

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('باقات الزيارة'),
        backgroundColor: const Color(0xFF004D40), // Adjust the color as needed
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Hourly Service Card
            _buildHourlyServiceCard(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHourlyServiceCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.brown,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'خدمة بالساعات',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          // Date Picker
          ElevatedButton(
            onPressed: () => _selectDate(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.brown.shade700,
            ),
            child: Text(
              'تاريخ: ${DateFormat('yyyy/MM/dd').format(selectedDate)}',
              style: const TextStyle(color: Colors.white),
            ),
          ),

          const SizedBox(height: 20),
          // Hour Input Field
          TextField(
            style: const TextStyle(color: Colors.white),
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'أدخل الساعة',
              labelStyle: TextStyle(color: Colors.white),
              border: OutlineInputBorder(),
            ),
            onChanged: (value) {
              selectedHour =
                  int.tryParse(value) ?? 1; // Default to 1 if input is invalid
            },
          ),
          const SizedBox(height: 20),
          // AM/PM Selection Dropdown
          DropdownButton<String>(
            value: selectedAmPm,
            items: <String>['صباحاً', 'مساءً']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value, style: const TextStyle(color: Colors.white)),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                selectedAmPm = newValue!;
              });
            },
            dropdownColor: Colors.brown.shade700,
            style: const TextStyle(color: Colors.white),
          ),
          const SizedBox(height: 20),
          // Phone Number Input Field
          TextField(
            style: const TextStyle(color: Colors.white),
            controller: _phoneNumberController,
            keyboardType: TextInputType.phone,
            decoration: const InputDecoration(
              labelText: 'رقم الهاتف',
              labelStyle: TextStyle(color: Colors.white),
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              // Handle the service booking confirmation
              _confirmBooking();
            },
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.brown,
              backgroundColor: Colors.white, // Text color
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('تأكيد الحجز'),
          ),
        ],
      ),
    );
  }

  void _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(), // التاريخ الحالي
      lastDate: DateTime(2025, 12, 31), // آخر تاريخ مسموح به (نهاية عام 2025)
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  void _confirmBooking() async {
    if (_phoneNumberController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('يرجى إدخال رقم الهاتف')),
      );
      return;
    }

    User? firebaseUser = FirebaseAuth.instance.currentUser;
    if (firebaseUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('يجب تسجيل الدخول أولاً')),
      );
      return;
    }

    String phoneNumber = _phoneNumberController.text;
    String time = '$selectedHour $selectedAmPm';
    String date = DateFormat('yyyy/MM/dd').format(selectedDate);

    await FirebaseFirestore.instance.collection('orders').add({
      'phoneNumber': phoneNumber,
      'email': firebaseUser.email,
      'time': time,
      'date': date,
      'type': 'باقة الزيارة',
      'orderStatus': 'تم الاستلام',
      'timestamp': FieldValue.serverTimestamp(),
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
          backgroundColor: Colors.green,
          content: Text('تم تأكيد الحجز بنجاح!')),
    );

    _phoneNumberController.clear();
  }

  @override
  void dispose() {
    _phoneNumberController.dispose();
    super.dispose();
  }
}
