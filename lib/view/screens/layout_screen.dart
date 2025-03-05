import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lastrasin1/view/screens/auth_screens/login_screen.dart';
import 'package:lastrasin1/view/screens/chat_screen.dart';
import 'package:lastrasin1/view/screens/contact_screen.dart';
import 'package:lastrasin1/view/screens/my_orders.dart';
import 'package:provider/provider.dart';
import 'package:lastrasin1/view/screens/home_screen.dart';
import 'package:lastrasin1/view/screens/my_orders1_screen.dart';
import 'package:lastrasin1/view/screens/offers_screen.dart';
import 'package:lastrasin1/view/screens/settings_screen.dart';
import 'package:lastrasin1/view/widgets/my_bottom_navigationbar.dart';
import 'package:lastrasin1/viewmodel/tabs_provider.dart';

class LayoutScreen extends StatelessWidget {
  final User? firebaseUser = FirebaseAuth.instance.currentUser;

  LayoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<TabsViewProvider>(
      builder: (context, provider, child) {
        List<Widget> body = [
          const HomeScreen(),
          firebaseUser != null
              ? const OrdersHomePage()
              : const LoginScreen(), //MyOrdersPage
          firebaseUser != null
              ? const ContactSupportScreen()
              : const LoginScreen(),

          //  const OffersScreen(),
          firebaseUser != null ? const SettingsScreen() : const LoginScreen(),
          firebaseUser != null ? const ChatScreen() : const LoginScreen(),
        ];

        return Scaffold(
          backgroundColor: Colors.grey[100],
          bottomNavigationBar: const MyBottomNavigationBar(),
          body: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (child, animation) {
              return SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(-1, 0),
                  end: Offset.zero,
                ).animate(animation),
                child: child,
              );
            },
            child: body[provider.index],
          ),
        );
      },
    );
  }
}
