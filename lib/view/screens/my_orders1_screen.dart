import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class OrdersHomePage extends StatelessWidget {
  const OrdersHomePage({super.key});

  Stream<Map<String, int>> getOrderCounts() {
    return FirebaseFirestore.instance
        .collection('orders')
        .snapshots()
        .map((snapshot) {
      Map<String, int> counts = {
        'قيد التنفيذ': 0,
        'تم الاستلام': 0,
        'تم الانتهاء': 0,
        'ملغي': 0,
      };

      for (var doc in snapshot.docs) {
        String status = doc.data()['orderStatus'] as String;
        counts[status] = (counts[status] ?? 0) + 1;
      }

      return counts;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "إدارة الطلبات",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).primaryColor.withOpacity(0.1),
              Colors.white,
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(bottom: 16.0),
                child: Text(
                  "حالة الطلبات",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Expanded(
                child: StreamBuilder<Map<String, int>>(
                  stream: getOrderCounts(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Center(
                        child: Text('Error: ${snapshot.error}'),
                      );
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    final counts = snapshot.data!;

                    return GridView.count(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      children: [
                        OrderCategoryCard(
                          status: "قيد التنفيذ",
                          color: Colors.orange,
                          icon: Icons.pending_actions,
                          count: counts['قيد التنفيذ'].toString(),
                        ),
                        OrderCategoryCard(
                          status: "تم الاستلام",
                          color: Colors.blue,
                          icon: Icons.check_circle,
                          count: counts['تم الاستلام'].toString(),
                        ),
                        OrderCategoryCard(
                          status: "تم الانتهاء",
                          color: Colors.green,
                          icon: Icons.task_alt,
                          count: counts['تم الانتهاء'].toString(),
                        ),
                        OrderCategoryCard(
                          status: "ملغي",
                          color: Colors.red,
                          icon: Icons.cancel,
                          count: counts['ملغي'].toString(),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class OrderCategoryCard extends StatelessWidget {
  final String status;
  final Color color;
  final IconData icon;
  final String count;

  const OrderCategoryCard({
    super.key,
    required this.status,
    required this.color,
    required this.icon,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OrdersListPage(orderStatus: status),
          ),
        );
      },
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                color.withOpacity(0.8),
                color.withOpacity(0.6),
              ],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  color: Colors.white,
                  size: 32,
                ),
                const SizedBox(height: 8),
                Text(
                  status,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 4),
                Text(
                  count,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class OrdersListPage extends StatelessWidget {
  final String orderStatus;
  const OrdersListPage({super.key, required this.orderStatus});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(title: Text("الطلبات - $orderStatus")),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('orders')
            .where('email', isEqualTo: user?.email)
            .where('orderStatus', isEqualTo: orderStatus)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("لا توجد طلبات."));
          }

          final orders = snapshot.data!.docs;

          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final orderData = orders[index].data() as Map<String, dynamic>;
              return _buildOrderCard(orderData);
            },
          );
        },
      ),
    );
  }

  Widget _buildOrderCard(Map<String, dynamic> orderData) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      margin: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('نوع الطلب: ${orderData['type']}',
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            if (orderData['phoneNumber'] != null)
              Text('رقم الهاتف: ${orderData['phoneNumber']}',
                  style: const TextStyle(fontSize: 16)),
            if (orderData['serviceDetails'] != null)
              Text('تفاصيل الخدمة: ${orderData['serviceDetails']}',
                  style: const TextStyle(fontSize: 16)),
            if (orderData['date'] != null)
              Text('التاريخ: ${orderData['date']}',
                  style: const TextStyle(fontSize: 16)),
            if (orderData['time'] != null)
              Text('وقت الزيارة: ${orderData['time']}',
                  style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Text('حالة الطلب: ${orderData['orderStatus']}',
                style: const TextStyle(fontSize: 16, color: Colors.green)),
            const SizedBox(height: 8),
            _buildDate(orderData['timestamp']),
          ],
        ),
      ),
    );
  }

  Widget _buildDate(Timestamp timestamp) {
    final date = timestamp.toDate();
    final formattedDate = DateFormat('yyyy-MM-dd HH:mm').format(date);
    return Text('تاريخ الطلب: $formattedDate',
        style: const TextStyle(fontSize: 16));
  }
}
