// import 'package:flutter/material.dart';
// import 'package:lastrasin1/view/screens/country_list_screen.dart';

// class OtherScreen extends StatefulWidget {
//   const OtherScreen({super.key});

//   @override
//   State<OtherScreen> createState() => _OtherScreenState();
// }

// class _OtherScreenState extends State<OtherScreen>
//     with SingleTickerProviderStateMixin {
//   bool _isExpanded = false;
//   late AnimationController _controller;
//   late Animation<double> _arrowAnimation;

//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 300),
//     );
//     _arrowAnimation = Tween<double>(begin: 0, end: 0.5).animate(CurvedAnimation(
//       parent: _controller,
//       curve: Curves.easeInOut,
//     ));
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   void _toggleExpand() {
//     setState(() {
//       _isExpanded = !_isExpanded;
//       if (_isExpanded) {
//         _controller.forward();
//       } else {
//         _controller.reverse();
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("أخرى"),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             _buildServiceCard("السائقون", _toggleExpand),
//             if (_isExpanded)
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: [
//                   Expanded(
//                     child: _buildOptionCard("", () {
//                       Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) => const CountryListScreen(
//                               service: "سائق خاص",
//                               isRent: false,
//                               isOther: true,
//                             ),
//                           ));
//                     }),
//                   ),
//                   const SizedBox(width: 8), // Space between the two cards
//                   Expanded(
//                     child: _buildOptionCard("إيجار", () {
//                       Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) => const CountryListScreen(
//                               service: "سائق خاص",
//                               isRent: true,
//                               isOther: true,
//                             ),
//                           ));
//                     }),
//                   ),
//                 ],
//               ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildServiceCard(String title, void Function()? onTap) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Card(
//         margin: const EdgeInsets.symmetric(vertical: 8.0),
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(16.0),
//         ),
//         elevation: 6,
//         shadowColor: Colors.grey.withOpacity(0.3),
//         child: Container(
//           width: double.infinity,
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(16.0),
//           ),
//           padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 title,
//                 style: const TextStyle(
//                   color: Colors.blueAccent,
//                   fontSize: 24,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               RotationTransition(
//                 turns: _arrowAnimation,
//                 child: const Icon(
//                   Icons.keyboard_arrow_right,
//                   color: Colors.blueAccent,
//                   size: 32.0,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildOptionCard(String title, void Function()? onTap) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Card(
//         margin: const EdgeInsets.symmetric(vertical: 8.0),
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(12.0),
//         ),
//         elevation: 4,
//         shadowColor: Colors.grey.withOpacity(0.2),
//         child: Container(
//           padding: const EdgeInsets.symmetric(vertical: 16.0),
//           child: Center(
//             child: Text(
//               title,
//               style: const TextStyle(
//                 color: Colors.black87,
//                 fontSize: 18,
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
