import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lastrasin1/viewmodel/tabs_provider.dart';
import '../../viewmodel/theme_provider.dart';

class MyBottomNavigationBar extends StatelessWidget {
  const MyBottomNavigationBar({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Consumer<TabsViewProvider>(
      builder: (context, provider, child) {
        return StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('toggle')
              .doc('oCEGfp5xKrN9MRUIcUV7') // ضع معرف الوثيقة هنا
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              List<BottomNavigationBarItem> navItems = [
                const BottomNavigationBarItem(
                  icon: Icon(Icons.home, size: 30),
                  label: 'الرئيسية',
                ),
                const BottomNavigationBarItem(
                  icon: Icon(Icons.list_alt, size: 30),
                  label: 'الطلبات',
                ),
                const BottomNavigationBarItem(
                  icon: Icon(Icons.contact_support, size: 30),
                  label: 'تواصل معنا',
                ),
                const BottomNavigationBarItem(
                  icon: Icon(Icons.settings, size: 30),
                  label: 'الإعدادات',
                ),
                const BottomNavigationBarItem(
                  icon: Icon(Icons.support_agent, size: 30),
                  label: 'الدعم',
                ),
              ];
            }

            if (snapshot.hasError) {
              return const SizedBox(); // يمكنك عرض رسالة خطأ هنا
            }

            bool showSupportTab = snapshot.data?.get('tap') ?? true;

            List<BottomNavigationBarItem> navItems = [
              const BottomNavigationBarItem(
                icon: Icon(Icons.home, size: 30),
                label: 'الرئيسية',
              ),
              const BottomNavigationBarItem(
                icon: Icon(Icons.list_alt, size: 30),
                label: 'الطلبات',
              ),
              const BottomNavigationBarItem(
                icon: Icon(Icons.contact_support, size: 30),
                label: 'تواصل معنا',
              ),
              const BottomNavigationBarItem(
                icon: Icon(Icons.settings, size: 30),
                label: 'الإعدادات',
              ),
            ];

            // إضافة تبويب الدعم إذا كانت قيمة tap = true
            if (showSupportTab) {
              navItems.add(
                const BottomNavigationBarItem(
                  icon: Icon(Icons.support_agent, size: 30),
                  label: 'الدعم',
                ),
              );
            }

            return BottomNavigationBar(
              currentIndex: provider.index,
              onTap: (index) {
                provider.index = index;
              },
              type: BottomNavigationBarType.fixed,
              backgroundColor: themeProvider.isDarkMode
                  ? const Color(0xFF004D40)
                  : const Color(0xFF004D40),
              selectedItemColor: Colors.white,
              unselectedItemColor: Colors.white70,
              selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
              unselectedLabelStyle: const TextStyle(fontSize: 12),
              items: navItems,
            );
          },
        );
      },
    );
  }
}
