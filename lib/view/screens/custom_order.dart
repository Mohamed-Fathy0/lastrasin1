// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/material.dart';

// class CustomOrderForm extends StatefulWidget {
//   final String orderType;

//   const CustomOrderForm({super.key, required this.orderType});

//   @override
//   _CustomOrderFormState createState() => _CustomOrderFormState();
// }

// class _CustomOrderFormState extends State<CustomOrderForm> {
//   final _formKey = GlobalKey<FormState>();
//   final _phoneController = TextEditingController();
//   final _detailsController = TextEditingController();
//   final _ageController = TextEditingController();
//   String? _selectedReligion;
//   String? _selectedExperience;
//   String? _selectedNationality;
//   String? _selectedJob;
//   bool _isLoading = false;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.orderType),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Form(
//           key: _formKey,
//           child: ListView(
//             children: _buildFormFields(),
//           ),
//         ),
//       ),
//     );
//   }

//   List<Widget> _buildFormFields() {
//     List<Widget> fields = [];

//     // الحقول المشتركة لكل النماذج
//     fields.add(
//       Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: TextFormField(
//           controller: _phoneController,
//           decoration: const InputDecoration(labelText: 'رقم الهاتف'),
//           keyboardType: TextInputType.phone,
//           validator: (value) {
//             if (value == null || value.isEmpty) {
//               return 'يرجى إدخال رقم الهاتف';
//             }
//             return null;
//           },
//         ),
//       ),
//     );

//     // حسب نوع الطلب يتم إضافة حقول معينة
//     switch (widget.orderType) {
//       case '':
//         fields.addAll([
//           _buildAgeField(),
//           _buildExperienceField(),
//           _buildReligionField(),
//           _buildDurationField(),
//         ]);
//         break;
//       case 'باقة مقيمة':
//         fields.addAll([
//           _buildAgeField(),
//           _buildExperienceField(),
//           _buildReligionField(),
//           _buildNationalityField(),
//         ]);
//         break;
//       case 'نقل خدمات':
//         fields.addAll([
//           _buildJobField(),
//           _buildTextField('جهة العمل السابقة'),
//         ]);
//         break;
//       case 'خصص طلبك':
//         fields.add(
//           TextFormField(
//             controller: _detailsController,
//             decoration: const InputDecoration(labelText: 'تفاصيل الطلب'),
//             maxLines: 4,
//             validator: (value) {
//               if (value == null || value.isEmpty) {
//                 return 'يرجى إدخال تفاصيل الطلب';
//               }
//               return null;
//             },
//           ),
//         );
//         break;
//     }

//     // زر الإرسال
//     fields.add(
//       _isLoading
//           ? const CircularProgressIndicator()
//           : ElevatedButton(
//               onPressed: _submitForm,
//               child: const Text('ارسال الطلب'),
//             ),
//     );

//     return fields;
//   }

//   // حقل العمر
//   Widget _buildAgeField() {
//     return TextFormField(
//       controller: _ageController,
//       decoration: const InputDecoration(labelText: 'العمر'),
//       keyboardType: TextInputType.number,
//       validator: (value) {
//         if (value == null || value.isEmpty) {
//           return 'يرجى إدخال العمر';
//         }
//         return null;
//       },
//     );
//   }

//   // حقل الخبرة
//   Widget _buildExperienceField() {
//     return DropdownButtonFormField<String>(
//       decoration: const InputDecoration(labelText: 'الخبرة'),
//       value: _selectedExperience,
//       items: ['عامل', 'عاملة', 'سائق']
//           .map((exp) => DropdownMenuItem(value: exp, child: Text(exp)))
//           .toList(),
//       onChanged: (value) {
//         setState(() {
//           _selectedExperience = value;
//         });
//       },
//       validator: (value) => value == null ? 'يرجى اختيار الخبرة' : null,
//     );
//   }

//   // حقل الديانة
//   Widget _buildReligionField() {
//     return DropdownButtonFormField<String>(
//       decoration: const InputDecoration(labelText: 'الديانة'),
//       value: _selectedReligion,
//       items: ['مسلم', 'غير مسلم']
//           .map((religion) =>
//               DropdownMenuItem(value: religion, child: Text(religion)))
//           .toList(),
//       onChanged: (value) {
//         setState(() {
//           _selectedReligion = value;
//         });
//       },
//       validator: (value) => value == null ? 'يرجى اختيار الديانة' : null,
//     );
//   }

//   // حقل الجنسية
//   Widget _buildNationalityField() {
//     return DropdownButtonFormField<String>(
//       decoration: const InputDecoration(labelText: 'الجنسية'),
//       value: _selectedNationality,
//       items: ['سعودية', 'مصرية', 'هندية', 'فلبينية']
//           .map((nationality) =>
//               DropdownMenuItem(value: nationality, child: Text(nationality)))
//           .toList(),
//       onChanged: (value) {
//         setState(() {
//           _selectedNationality = value;
//         });
//       },
//       validator: (value) => value == null ? 'يرجى اختيار الجنسية' : null,
//     );
//   }

//   // حقل الوظيفة الحالية
//   Widget _buildJobField() {
//     return DropdownButtonFormField<String>(
//       decoration: const InputDecoration(labelText: 'الوظيفة الحالية'),
//       value: _selectedJob,
//       items: ['سائق', 'عاملة منزلية']
//           .map((job) => DropdownMenuItem(value: job, child: Text(job)))
//           .toList(),
//       onChanged: (value) {
//         setState(() {
//           _selectedJob = value;
//         });
//       },
//       validator: (value) => value == null ? 'يرجى اختيار الوظيفة' : null,
//     );
//   }

//   // حقل المدة المطلوبة
//   Widget _buildDurationField() {
//     return TextFormField(
//       decoration: const InputDecoration(labelText: 'المدة المطلوبة (أشهر)'),
//       keyboardType: TextInputType.number,
//       validator: (value) {
//         if (value == null || value.isEmpty) {
//           return 'يرجى إدخال المدة المطلوبة';
//         }
//         return null;
//       },
//     );
//   }

//   // حقل نصي عام
//   Widget _buildTextField(String label) {
//     return TextFormField(
//       decoration: InputDecoration(labelText: label),
//       validator: (value) {
//         if (value == null || value.isEmpty) {
//           return 'يرجى إدخال $label';
//         }
//         return null;
//       },
//     );
//   }

//   void _submitForm() async {
//     if (_formKey.currentState?.validate() ?? false) {
//       setState(() {
//         _isLoading = true;
//       });

//       final user = FirebaseAuth.instance.currentUser;
//       if (user == null) return;

//       final orderData = {
//         'email': user.email,
//         'firstName': user.displayName?.split(' ').first ?? '',
//         'lastName': user.displayName?.split(' ').last ?? '',
//         'orderType': widget.orderType, // نوع الطلب
//         'age': _ageController.text,
//         'religion': _selectedReligion,
//         'experience': _selectedExperience,
//         'phoneNumber': _phoneController.text,
//         'serviceDetails': _detailsController.text,
//         'timestamp': FieldValue.serverTimestamp(),
//         'orderStatus': "تم الاستلام", // إضافة حالة الطلب
//       };

//       try {
//         await FirebaseFirestore.instance
//             .collection('custom_orders')
//             .add(orderData);

//         // Reset the form fields
//         _formKey.currentState?.reset();
//         _phoneController.clear();
//         _detailsController.clear();
//         _ageController.clear();
//         setState(() {
//           _selectedReligion = null;
//           _selectedExperience = null;
//           _isLoading = false;
//         });

//         // Show success dialog
//         showDialog(
//           context: context,
//           builder: (context) => AlertDialog(
//             title:
//                 const Icon(Icons.check_circle, color: Colors.green, size: 48),
//             content: const Text('تم ارسال طلبك بنجاح'),
//             actions: [
//               TextButton(
//                 onPressed: () {
//                   Navigator.of(context).pop();
//                 },
//                 child: const Text('موافق'),
//               ),
//             ],
//           ),
//         );
//       } catch (e) {
//         setState(() {
//           _isLoading = false;
//         });
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Failed to submit order: $e')),
//         );
//       }
//     }
//   }
// }
