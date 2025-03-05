import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lastrasin1/view/screens/auth_screens/login_screen.dart';
import 'package:lastrasin1/viewmodel/auth_provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.user;

    if (user == null) {
      return const LoginScreen();
    }

    return Scaffold(
      body: FutureBuilder<DocumentSnapshot>(
        future:
            FirebaseFirestore.instance.collection('users').doc(user.uid).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('خطأ: ${snapshot.error}'));
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text('بيانات المستخدم غير موجودة'));
          }

          var userData = snapshot.data!.data() as Map<String, dynamic>;

          return CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 200.0,
                floating: false,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(userData['firstName'] ?? 'الملف الشخصي'),
                  background: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                        colors: [Colors.blue, Colors.purple],
                      ),
                    ),
                    child: const Center(
                      child: CircleAvatar(
                        radius: 50,
                        child: Icon(Icons.person),
                      ),
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildInfoCard(
                        icon: Icons.person,
                        title: 'الاسم الكامل',
                        value:
                            '${userData['firstName'] ?? ''} ${userData['lastName'] ?? ''}',
                      ),
                      _buildInfoCard(
                        icon: Icons.email,
                        title: 'البريد الإلكتروني',
                        value: user.email ?? 'غير متوفر',
                      ),
                      // _buildInfoCard(
                      //   icon: Icons.phone,
                      //   title: 'رقم الهاتف',
                      //   value: userData['phoneNumber'] ?? 'غير متوفر',
                      // ),
                      // _buildInfoCard(
                      //   icon: Icons.location_on,
                      //   title: 'العنوان',
                      //   value: userData['address'] ?? 'غير متوفر',
                      // ),
                      const SizedBox(height: 20),
                      // ElevatedButton(
                      //   onPressed: () {
                      //     // TODO: Implement edit profile functionality
                      //   },
                      //   style: ElevatedButton.styleFrom(
                      //     foregroundColor: Colors.white,
                      //     backgroundColor: Colors.purple,
                      //     padding: const EdgeInsets.symmetric(
                      //         horizontal: 50, vertical: 15),
                      //     shape: RoundedRectangleBorder(
                      //       borderRadius: BorderRadius.circular(30),
                      //     ),
                      //   ),
                      //   child: const Text('تعديل الملف الشخصي'),
                      // ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildInfoCard(
      {required IconData icon, required String title, required String value}) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: Icon(icon, color: Colors.purple),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(value),
      ),
    );
  }
}
