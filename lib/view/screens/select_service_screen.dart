// import 'package:flutter/material.dart';
// import 'package:lastrasin1/methods/methods.dart';

// class SelectServiceScreen extends StatelessWidget {
//   final String title;
//   final bool isRent;
//   final bool isOther;

//   const SelectServiceScreen({
//     super.key,
//     required this.title,
//     required this.isRent,
//     required this.isOther,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(title),
//         elevation: 0,
//       ),
//       body: Center(
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             buildRecruitOption(
//               context,
//               'عاملة منزلية',
//               Icons.cleaning_services,
//             ),
//             const SizedBox(width: 16),
//             buildRecruitOption(
//               context,
//               'سائق',
//               Icons.drive_eta,
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget buildRecruitOption(
//     BuildContext context,
//     String title,
//     IconData icon,
//   ) {
//     return SizedBox(
//       width: 150, // ضبط عرض ثابت لكل زر
//       height: 150, // ضبط ارتفاع ثابت لكل زر
//       child: ElevatedButton(
//         style: ElevatedButton.styleFrom(
//           backgroundColor: const Color(0xFF3F51B5),
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(15),
//           ),
//         ),
//         onPressed: () {
//           // تمرير اسم الخدمة عند الضغط
//           showCountryList(
//             context,
//             isRent,
//             isOther,
//             title,
//           );
//         },
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(icon, color: Colors.white, size: 30),
//             const SizedBox(height: 10),
//             Text(
//               title,
//               style: const TextStyle(fontSize: 18, color: Colors.white),
//               textAlign: TextAlign.center,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
