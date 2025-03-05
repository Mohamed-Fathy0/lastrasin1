import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:lastrasin1/viewmodel/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:lastrasin1/view/screens/about_us.dart';
import 'package:lastrasin1/view/screens/auth_screens/login_screen.dart';
import 'package:lastrasin1/view/screens/complain_history.dart';
import 'package:lastrasin1/view/screens/contact_us_screen.dart';
import 'package:lastrasin1/view/screens/home_screen.dart';
import 'package:lastrasin1/view/screens/profile_screem.dart';
import 'package:lastrasin1/view/screens/settings_screen.dart';
import 'package:lastrasin1/viewmodel/auth_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.user;

    final themeProvider = Provider.of<ThemeProvider>(context);

    return Drawer(
      backgroundColor: themeProvider.isDarkMode
          ? const Color(0xFF1C1C1C) // Dark background color
          : const Color(0xFFF8F9FA), // Light background color
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          _buildDrawerHeader(themeProvider),
          if (user != null) ...[
            _buildDrawerItem(
              icon: Icons.person,
              title: user.email ?? 'User'.tr(),
              onTap: () => _navigateToScreen(context, const ProfileScreen()),
              themeProvider: themeProvider,
            ),
            // _buildDrawerItem(
            //   icon: Icons.settings,
            //   title: 'الاعدادات'.tr(),
            //   onTap: () => _navigateToScreen(context, const SettingsScreen()),
            //   themeProvider: themeProvider,
            // ),
          ] else ...[
            _buildDrawerItem(
              icon: Icons.login,
              title: 'تسجيل الدخول'.tr(),
              onTap: () => _navigateToScreen(context, const LoginScreen()),
              themeProvider: themeProvider,
            ),
          ],
          // _buildDrawerItem(
          //   icon: Icons.phone,
          //   title: 'تواصل بنا'.tr(),
          //   onTap: () => _navigateToScreen(context, const ContactUsScreen()),
          //   themeProvider: themeProvider,
          // ),
          // _buildDrawerItem(
          //   icon: Icons.history,
          //   title: 'سجل الشكاوي'.tr(),
          //   onTap: () => _navigateToScreen(context, const ComplaintsLog()),
          //   themeProvider: themeProvider,
          // ),
          _buildDrawerItem(
            icon: Icons.info,
            title: 'About Us'.tr(),
            onTap: () => _navigateToScreen(context, const AboutUsScreen()),
            themeProvider: themeProvider,
          ),
          // _buildDrawerItem(
          //   icon: Icons.privacy_tip,
          //   title: 'Privacy Policy'.tr(),
          //   onTap: () {}, //_launchPrivacyPolicy(context),
          //   themeProvider: themeProvider,
          // ),
        ],
      ),
    );
  }

  Widget _buildDrawerHeader(ThemeProvider themeProvider) {
    return DrawerHeader(
      decoration: BoxDecoration(
        color: themeProvider.isDarkMode
            ? const Color(0xFF333333) // Dark header background
            : const Color(0xFFF8F9FA), // Light header background
      ),
      child: Center(
        child: Image.asset(
          "assets/logo.png",
          fit: BoxFit.contain,
        ),
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required void Function() onTap,
    required ThemeProvider themeProvider,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: themeProvider.isDarkMode
            ? const Color(0xFFE0E0E0) // Light icon color for dark mode
            : const Color(0xFF6D4C41), // Darker icon color for light mode
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          color: themeProvider.isDarkMode
              ? const Color(0xFFE0E0E0) // Light text color for dark mode
              : const Color(0xFF333333), // Dark text color for light mode
        ),
      ),
      onTap: onTap,
    );
  }

  void _navigateToScreen(BuildContext context, Widget screen) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => screen),
    );
  }

  // void _launchPrivacyPolicy(BuildContext context) async {
  //   try {
  //     DocumentSnapshot snapshot = await FirebaseFirestore.instance
  //         .collection('links')
  //         .doc('mmszhdSQSs70TGNlastrasin1C3J')
  //         .get();
  //     String url = snapshot['privacyPolicyLink'];

  //     if (await canLaunch(url)) {
  //       await launch(url);
  //     } else {
  //       print('Could not launch $url');
  //     }
  //   } catch (e) {
  //     print('Error fetching privacy policy URL: $e');
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('Error fetching privacy policy URL: $e')),
  //     );
  //   }
  // }
}
