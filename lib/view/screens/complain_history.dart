import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // استخدم حزمة intl لتنسيق الوقت

class ComplaintsLog extends StatelessWidget {
  const ComplaintsLog({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('سجل الشكاوي'),
      ),
      body: const ComplaintsList(),
    );
  }
}

class ComplaintsList extends StatefulWidget {
  const ComplaintsList({super.key});

  @override
  _ComplaintsListState createState() => _ComplaintsListState();
}

class _ComplaintsListState extends State<ComplaintsList> {
  // دالة لتنسيق التاريخ والوقت كما هو مطلوب
  String formatTimestamp(Timestamp? timestamp) {
    if (timestamp == null) return '';
    DateTime dateTime = timestamp.toDate();
    return DateFormat('yyyy/MM/dd HH:mm').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('complaints')
          .orderBy('timestamp', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(
            child: Text('لا توجد شكاوي مسجلة.'),
          );
        }

        final complaints = snapshot.data!.docs;

        return ListView.builder(
          itemCount: complaints.length,
          itemBuilder: (context, index) {
            final complaint = complaints[index];
            final name = complaint['name'];
            final phoneNumber = complaint['phoneNumber'];
            final subject = complaint['subject'];
            final details = complaint['details'];
            final timestamp = complaint['timestamp'] as Timestamp?;

            return Card(
              margin:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              child: ListTile(
                title: Text(subject),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('الاسم: $name'),
                    Text('رقم الجوال: $phoneNumber'),
                    Text('التفاصيل: $details'),
                    if (timestamp != null)
                      Text('التاريخ: ${formatTimestamp(timestamp)}'),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
