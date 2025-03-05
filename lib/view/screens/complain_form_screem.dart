import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lastrasin1/view/widgets/my_drawer.dart';

class ComplaintForm extends StatelessWidget {
  const ComplaintForm({super.key});

  @override
  Widget build(BuildContext context) {
    return const ComplaintFormBody();
  }
}

class ComplaintFormBody extends StatefulWidget {
  const ComplaintFormBody({super.key});

  @override
  _ComplaintFormBodyState createState() => _ComplaintFormBodyState();
}

class _ComplaintFormBodyState extends State<ComplaintFormBody> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _subjectController = TextEditingController();
  final _detailsController = TextEditingController();
  bool _isLoading = false; // متغير لتتبع حالة التحميل

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const MyDrawer(),
      appBar: AppBar(
        title: const Text('تقديم شكوى'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                // اسم المستخدم
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'الاسم',
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue, width: 2.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey, width: 1.0),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'يرجى إدخال الاسم';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // رقم الجوال
                TextFormField(
                  controller: _phoneController,
                  decoration: const InputDecoration(
                    labelText: 'رقم الجوال',
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue, width: 2.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey, width: 1.0),
                    ),
                  ),
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'يرجى إدخال رقم الجوال';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // عنوان الشكوى
                TextFormField(
                  controller: _subjectController,
                  decoration: const InputDecoration(
                    labelText: 'عنوان الشكوى',
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue, width: 2.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey, width: 1.0),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'يرجى إدخال عنوان الشكوى';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // تفاصيل الشكوى
                TextFormField(
                  controller: _detailsController,
                  decoration: const InputDecoration(
                    labelText: 'تفاصيل الشكوى',
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue, width: 2.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey, width: 1.0),
                    ),
                  ),
                  maxLines: 4,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'يرجى إدخال تفاصيل الشكوى';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // زر الإرسال مع مؤشر التحميل
                _isLoading
                    ? const CircularProgressIndicator() // مؤشر التحميل
                    : ElevatedButton(
                        onPressed: _submitComplaint,
                        child: const Text('ارسال الشكوى'),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _submitComplaint() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isLoading = true; // إظهار مؤشر التحميل
      });

      final complaintData = {
        'name': _nameController.text,
        'phoneNumber': _phoneController.text,
        'subject': _subjectController.text,
        'details': _detailsController.text,
        'timestamp': FieldValue.serverTimestamp(),
      };

      try {
        await FirebaseFirestore.instance
            .collection('complaints')
            .add(complaintData);

        // Reset the form fields
        _formKey.currentState?.reset();
        _nameController.clear();
        _phoneController.clear();
        _subjectController.clear();
        _detailsController.clear();
        setState(() {
          _isLoading = false; // إخفاء مؤشر التحميل بعد انتهاء العملية
        });

        // Show success dialog
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title:
                const Icon(Icons.check_circle, color: Colors.green, size: 48),
            content: const Text('تم ارسال الشكوى بنجاح'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('موافق'),
              ),
            ],
          ),
        );
      } catch (e) {
        setState(() {
          _isLoading = false; // إخفاء مؤشر التحميل في حالة وجود خطأ
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to submit complaint: $e')),
        );
      }
    }
  }
}
