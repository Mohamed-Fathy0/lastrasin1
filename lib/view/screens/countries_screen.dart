// // ignore_for_file: public_member_api_docs, sort_constructors_first
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:url_launcher/url_launcher.dart';

// import 'package:lastrasin1/model/recruit.dart';
// import 'package:lastrasin1/viewmodel/countries_provider.dart';

// class CountryScreen extends StatelessWidget {
//   final String type;
//   final String backgroundImagePath =
//       'assets/images/background1.jpg'; // ضع مسار الصورة هنا

//   const CountryScreen({
//     super.key,
//     required this.type,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final countryProvider = Provider.of<CountryProvider>(context);

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('اختر الجنسية'),
//         backgroundColor: const Color(0xFF004D40),
//       ),
//       body: Stack(
//         children: [
//           // صورة الخلفية
//           Positioned.fill(
//             child: Image.asset(
//               backgroundImagePath,
//               fit: BoxFit.cover, // لجعل الصورة تغطي الشاشة بالكامل
//             ),
//           ),
//           // المحتوى الرئيسي
//           countryProvider.countries.isEmpty
//               ? const Center(child: CircularProgressIndicator())
//               : GridView.builder(
//                   gridDelegate: const SliverGridDelegateWithFilastrasin1dCrossAxisCount(
//                     crossAxisCount: 3,
//                     childAspectRatio: 0.7,
//                     mainAxisSpacing: 16,
//                     crossAxisSpacing: 16,
//                   ),
//                   padding: const EdgeInsets.all(16),
//                   itemCount: countryProvider.countries.length,
//                   itemBuilder: (context, index) {
//                     final country = countryProvider.countries[index];
//                     return CountryCard(
//                       country: country,
//                       type: type,
//                     );
//                   },
//                 ),
//         ],
//       ),
//     );
//   }
// }

// class CountryCard extends StatelessWidget {
//   final Country country;
//   final String type;

//   const CountryCard({
//     super.key,
//     required this.country,
//     required this.type,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () async {
//         final encodedMessage =
//             Uri.encodeComponent("الجنسية:${country.countryAr}الخدمة: $type");
//         final url = 'https://wa.me/+966575980275?text=$encodedMessage';

//         // تحقق مما إذا كان يمكن فتح الرابط
//         if (await canLaunch(url)) {
//           await launch(url); // افتح الرابط في تطبيق WhatsApp
//         } else {
//           throw 'لا يمكن فتح الرابط $url';
//         }
//       },
//       child: Card(
//         color: const Color(0xFF004D40),
//         elevation: 4,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(12),
//         ),
//         child: ClipRRect(
//           borderRadius: BorderRadius.circular(12),
//           child: Column(
//             children: [
//               Expanded(
//                 child: CachedNetworkImage(
//                   imageUrl: country.imageUrl,
//                   placeholder: (context, url) =>
//                       const CircularProgressIndicator(
//                     color: Colors.white,
//                   ),
//                   errorWidget: (context, url, error) => const Icon(Icons.error),
//                   fit: BoxFit.cover,
//                 ),
//               ),
//               Container(
//                 padding: const EdgeInsets.all(8.0),
//                 color: const Color(0xFF004D40), // خلفية النص
//                 child: Text(
//                   country.countryAr,
//                   style: const TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.white,
//                   ),
//                   textAlign: TextAlign.center,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// // class BackgroundPainter extends CustomPainter {
// //   @override
// //   void paint(Canvas canvas, Size size) {
// //     final paint = Paint()..style = PaintingStyle.fill;

// //     // الخلفية الرئيسية
// //     paint.color = const Color(0xFFE3D5C8); // لون الخلفية
// //     canvas.drawRect(Rect.fromLTRB(0, 0, size.width, size.height), paint);

// //     // إضافة أشكال دائرية جميلة
// //     paint.color = const Color(0xFF004D40).withOpacity(0.5);
// //     canvas.drawCircle(Offset(size.width * 0.2, size.height * 0.3), 100, paint);

// //     paint.color = const Color(0xFFD1B6A9).withOpacity(0.5);
// //     canvas.drawCircle(Offset(size.width * 0.8, size.height * 0.7), 150, paint);

// //     paint.color = const Color(0xFFE0B0B8).withOpacity(0.5);
// //     canvas.drawCircle(Offset(size.width * 0.5, size.height * 0.9), 80, paint);
// //   }

// //   @override
// //   bool shouldRepaint(covariant CustomPainter oldDelegate) {
// //     return false; // لا حاجة لإعادة الرسم إذا لم يتغير التصميم
// //   }
// // }
