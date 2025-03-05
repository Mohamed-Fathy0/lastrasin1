import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lastrasin1/viewmodel/theme_provider.dart';
import 'package:provider/provider.dart';

class MyOrdersPage extends StatefulWidget {
  const MyOrdersPage({super.key});

  @override
  _MyOrdersPageState createState() => _MyOrdersPageState();
}

class _MyOrdersPageState extends State<MyOrdersPage>
    with SingleTickerProviderStateMixin {
  final user = FirebaseAuth.instance.currentUser;
  bool isExpandedPending = false;
  bool isExpandedReceived = false;
  bool isExpandedCompleted = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(actions: [
        IconButton(
          icon: const Icon(Icons.brightness_6),
          onPressed: () {
            Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
          },
        ),
      ], title: const Text("إدارة الطلبات")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // الكارد الخاص بحالة "قيد التنفيذ"
            _buildOrderCard('قيد التنفيذ', isExpandedPending, () {
              setState(() {
                isExpandedPending = !isExpandedPending;
              });
            }),
            const SizedBox(height: 16),

            // الكارد الخاص بحالة "تم الاستلام"
            _buildOrderCard('تم الاستلام', isExpandedReceived, () {
              setState(() {
                isExpandedReceived = !isExpandedReceived;
              });
            }),
            const SizedBox(height: 16),

            // الكارد الخاص بحالة "تم الانتهاء"
            _buildOrderCard('تم الانتهاء', isExpandedCompleted, () {
              setState(() {
                isExpandedCompleted = !isExpandedCompleted;
              });
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderCard(String status, bool isExpanded, VoidCallback onTap) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          ListTile(
            title: Text(
              status,
              style: const TextStyle(
                  fontSize: 20, fontWeight: FontWeight.bold), // تكبير حجم النص
            ),
            subtitle: _buildOrderCount(status),
            trailing: Icon(isExpanded ? Icons.expand_less : Icons.expand_more),
            onTap: onTap,
          ),

          // عرض الطلبات مع تأثير انيميشن إذا كانت البطاقة مفتوحة
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: isExpanded ? null : 0,
            child: isExpanded ? _buildOrdersList(status) : null,
          ),
        ],
      ),
    );
  }

  Widget _buildOrderCount(String status) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('orders')
          .where('email', isEqualTo: user?.email)
          .where('orderStatus', isEqualTo: status)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Text('تحميل...',
              style: TextStyle(fontSize: 16)); // تكبير حجم النص
        }

        final orderCount = snapshot.data!.docs.length;
        return Text('عدد الطلبات: $orderCount',
            style: const TextStyle(fontSize: 16)); // تكبير حجم النص
      },
    );
  }

  Widget _buildOrdersList(String status) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('orders')
          .where('email', isEqualTo: user?.email)
          .where('orderStatus', isEqualTo: status)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text('لا توجد طلبات في هذه الحالة.',
                style: TextStyle(fontSize: 16)), // تكبير حجم النص
          );
        }

        final orders = snapshot.data!.docs;

        return Column(
          children: orders.map((order) {
            final orderData = order.data() as Map<String, dynamic>;
            return _buildOrderCardDetails(orderData);
          }).toList(),
        );
      },
    );
  }

  Widget _buildOrderCardDetails(Map<String, dynamic> orderData) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'نوع الطلب: ${orderData['type']}',
                style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold), // تكبير حجم النص
              ),
              const SizedBox(height: 8),
              if (orderData['phoneNumber'] != null)
                Text('رقم الهاتف: ${orderData['phoneNumber']}',
                    style: const TextStyle(fontSize: 16)), // تكبير حجم النص
              if (orderData['serviceDetails'] != null)
                Text('تفاصيل الخدمة: ${orderData['serviceDetails']}',
                    style: const TextStyle(fontSize: 16)), // تكبير حجم النص
              if (orderData['notes'] != null)
                Text('تفاصيل الخدمة: ${orderData['notes']}',
                    style: const TextStyle(fontSize: 16)), // تكبير حجم النص
              if (orderData['date'] != null)
                Text('تاريخ: ${orderData['date']}',
                    style: const TextStyle(fontSize: 16)), // تكبير حجم النص
              if (orderData['time'] != null)
                Text('وقت الزيارة: ${orderData['time']}',
                    style: const TextStyle(fontSize: 16)), // تكبير حجم النص
              if (orderData['country'] != null)
                Text('الجنسية: ${orderData['country']}',
                    style: const TextStyle(fontSize: 16)), // تكبير حجم النص
              const SizedBox(height: 8),
              Text('حالة الطلب: ${orderData['orderStatus']}',
                  style: const TextStyle(
                      fontSize: 16, color: Colors.green)), // تكبير حجم النص
              const SizedBox(height: 8),
              _buildDate(orderData['timestamp']),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDate(Timestamp timestamp) {
    final date = timestamp.toDate();
    final formattedDate = DateFormat('yyyy-MM-dd HH:mm').format(date);
    return Text('تاريخ الطلب: $formattedDate',
        style: const TextStyle(fontSize: 16)); // تكبير حجم النص
  }
}
