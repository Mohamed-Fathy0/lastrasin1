// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class OrderFormScreen extends StatefulWidget {
  final String type;
  const OrderFormScreen({
    super.key,
    required this.type,
  });

  @override
  _OrderFormScreenState createState() => _OrderFormScreenState();
}

class _OrderFormScreenState extends State<OrderFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _phoneNumberController = TextEditingController();
  final _notesController = TextEditingController();
  final _recipientNameController = TextEditingController();
  final _cityController = TextEditingController();
  final _addressController = TextEditingController();
  final User? firebaseUser = FirebaseAuth.instance.currentUser;

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      // Get the form values
      String phoneNumber = _phoneNumberController.text;
      String notes = _notesController.text;
      String recipientName = _recipientNameController.text;
      String city = _cityController.text;
      String address = _addressController.text;

      // Save to Firestore
      await FirebaseFirestore.instance.collection('orders').add({
        'phoneNumber': phoneNumber,
        'email': firebaseUser!.email,
        'notes': notes,
        'recipientName': recipientName,
        'city': city,
        'address': address,
        'type': widget.type,
        'orderStatus': 'تم الاستلام',
        'timestamp': FieldValue.serverTimestamp(),
      });

      // Show a success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            backgroundColor: Colors.green,
            content: Text('تم تقديم الطلب بنجاح!')),
      );

      // Clear the form
      _phoneNumberController.clear();
      _notesController.clear();
      _recipientNameController.clear();
      _cityController.clear();
      _addressController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('تقديم طلب جديد'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: _recipientNameController,
                  decoration: const InputDecoration(
                    labelText: 'اسم المستلم',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'يرجى إدخال اسم المستلم';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: _cityController,
                  decoration: const InputDecoration(
                    labelText: 'المدينة',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'يرجى إدخال اسم المدينة';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: _addressController,
                  decoration: const InputDecoration(
                    labelText: 'العنوان',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'يرجى إدخال العنوان';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: _phoneNumberController,
                  decoration: const InputDecoration(
                    labelText: 'رقم الهاتف',
                  ),
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'يرجى إدخال رقم الهاتف';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: _notesController,
                  decoration: const InputDecoration(
                    labelText: 'ملاحظات',
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 24.0),
                ElevatedButton(
                  onPressed: _submitForm,
                  child: const Text('تقديم الطلب'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _phoneNumberController.dispose();
    _notesController.dispose();
    _recipientNameController.dispose();
    _cityController.dispose();
    _addressController.dispose();
    super.dispose();
  }
}
