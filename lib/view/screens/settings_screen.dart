import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:lastrasin1/view/screens/about_us.dart';
import 'package:lastrasin1/view/screens/auth_screens/login_screen.dart';
import 'package:lastrasin1/view/screens/layout_screen.dart';
import 'package:lastrasin1/viewmodel/auth_provider.dart';
import 'package:lastrasin1/viewmodel/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    final user = authProvider.user;

    if (user == null) {
      return const LoginScreen();
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('الإعدادات'.tr()),
      ),
      body: ListView(
        children: [
          const SizedBox(height: 20),
          _buildSettingsCard(
            context: context,
            icon: Icons.brightness_6,
            title: themeProvider.isDarkMode
                ? 'تفعيل الوضع الفاتح'
                : 'تفعيل الوضع المظلم',
            color: Theme.of(context).colorScheme.primary,
            onTap: () {
              themeProvider.toggleTheme();
            },
          ),
          _buildSettingsCard(
            color: Colors.blue,
            context: context,
            icon: Icons.info,
            title: 'About Us'.tr(),
            onTap: () => _navigateToScreen(context, const AboutUsScreen()),
          ),
          _buildSettingsCard(
            color: Colors.blue,
            context: context,
            icon: Icons.privacy_tip,
            title: 'Privacy Policy'.tr(),
            onTap: () => _launchPrivacyPolicy(context),
          ),
          _buildSettingsCard(
            context: context,
            icon: Icons.logout,
            title: 'تسجيل الخروج',
            color: Colors.red,
            onTap: () {
              _showLogoutDialog(context);
            },
          ),
          _buildSettingsCard(
            context: context,
            icon: Icons.delete_forever,
            title: 'حذف الحساب',
            color: Colors.red,
            onTap: () {
              _showDeleteAccountDialog(context);
            },
          ),
        ],
      ),
    );
  }

  void _navigateToScreen(BuildContext context, Widget screen) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => screen),
    );
  }

  void _launchPrivacyPolicy(BuildContext context) async {
    try {
      // Fetch privacy policy URL from Firestore
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('links')
          .doc('GU9we4goMEgn8wSrPtJZ')
          .get();
      String url = snapshot['privacyPolicyLink'];

      if (await canLaunch(url)) {
        await launch(url);
      } else {
        print('Could not launch $url');
      }
    } catch (e) {
      print('Error fetching privacy policy URL: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching privacy policy URL: $e')),
      );
    }
  }

  Widget _buildSettingsCard(
      {required BuildContext context,
      required IconData icon,
      required String title,
      required Color color,
      required VoidCallback onTap}) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ListTile(
        leading: Icon(icon, color: color),
        title: Text(title,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).textTheme.bodyLarge?.color)),
        onTap: onTap,
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.exit_to_app, color: Colors.red, size: 24),
              SizedBox(width: 8),
              Text('تأكيد تسجيل الخروج'),
            ],
          ),
          content: const Text('أنت على وشك تسجيل الخروج'),
          actions: [
            TextButton(
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              onPressed: () {
                Navigator.of(context).pop();
                context.read<AuthProvider>().signOut();
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LayoutScreen(),
                    ));
              },
              child: const Text('نعم'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('لا'),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteAccountDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.delete_forever, color: Colors.red, size: 24),
              SizedBox(width: 8),
              Text('تأكيد حذف الحساب'),
            ],
          ),
          content: const Text('أنت على وشك حذف حسابك! لا يمكن استعادة الحساب'),
          actions: [
            TextButton(
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              onPressed: () async {
                Navigator.of(dialogContext).pop();
                try {
                  await Provider.of<AuthProvider>(context, listen: false)
                      .deleteAccount();
                  _handlePostDeletion(context);
                } catch (e) {
                  print('خطأ في حذف الحساب: $e');
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('خطأ في حذف الحساب: $e')),
                  );
                }
              },
              child: const Text('نعم'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: const Text('لا'),
            ),
          ],
        );
      },
    );
  }

  void _handlePostDeletion(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.of(context).popUntil((route) => route.isFirst);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => LayoutScreen(),
        ),
      );
    });
  }
}
