// import 'package:easy_localization/easy_localization.dart';
// import 'package:flutter/material.dart';
// import 'package:lastrasin1/view/screens/home_screen.dart';

// class LanguageToggle extends StatelessWidget {
//   const LanguageToggle({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         ToggleButtons(
//           isSelected: [
//             context.locale.languageCode == 'ar',
//             context.locale.languageCode == 'en',
//           ],
//           onPressed: (index) {
//             if (index == 0) {
//               context.setLocale(const Locale('ar', 'SA'));
//             } else if (index == 1) {
//               context.setLocale(const Locale('en', 'US'));
//             }
//             Navigator.pushReplacement(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => const HomeScreen(),
//                 ));
//           },
//           color: Colors.black,
//           selectedColor: Colors.white,
//           fillColor: const Color(0xFF3F51B5),
//           borderRadius: BorderRadius.circular(8),
//           children: <Widget>[
//             Container(
//               padding: const EdgeInsets.symmetric(horizontal: 16),
//               child: Text(
//                 'عربي', // Arabic
//                 style: TextStyle(
//                   color: context.locale.languageCode == 'ar'
//                       ? Colors.white
//                       : Colors.black,
//                 ),
//               ),
//             ),
//             Container(
//               padding: const EdgeInsets.symmetric(horizontal: 16),
//               child: Text(
//                 'EN', // English
//                 style: TextStyle(
//                   color: context.locale.languageCode == 'en'
//                       ? Colors.white
//                       : Colors.black,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ],
//     );
//   }
// }
