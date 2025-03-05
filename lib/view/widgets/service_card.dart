// import 'package:flutter/material.dart';
// import 'package:easy_localization/easy_localization.dart';
// import 'package:flutter/widgets.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:provider/provider.dart';
// import 'package:lastrasin1/view/screens/auth_screens/login_screen.dart';
// import 'package:lastrasin1/viewmodel/auth_provider.dart';
// import 'package:lastrasin1/viewmodel/fav_manager.dart';
// import 'package:lastrasin1/viewmodel/services_provider.dart';
// import 'package:lastrasin1/viewmodel/worker_provider.dart';
// import 'package:url_launcher/url_launcher.dart';

// class ServiceCard extends StatefulWidget {
//   final String title;

//   const ServiceCard({
//     super.key,
//     required this.title,
//   });

//   @override
//   _ServiceCardState createState() => _ServiceCardState();
// }

// class _ServiceCardState extends State<ServiceCard> {
//   bool _isExpanded = false;
//   bool _isFavorite = false;

//   final ServiceProvider _serviceProvider = ServiceProvider();
//   String _selectedCountry = '';
//   bool _isRent = false;
//   String _selectedDuration = '';
//   final FavoritesManager _favoritesManager = FavoritesManager();

//   @override
//   void initState() {
//     super.initState();
//     _loadFavoriteStatus();
//   }

//   void _loadFavoriteStatus() async {
//     bool isFavorite = await _favoritesManager.isFavorite(widget.title);
//     setState(() {
//       _isFavorite = isFavorite;
//     });
//   }

//   void _toggleFavorite() async {
//     await _favoritesManager.toggleFavorite(widget.title);
//     setState(() {
//       _isFavorite = !_isFavorite;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final authProvider = Provider.of<AuthProvider>(context);
//     final user = authProvider.user;
//     return Card(
//         elevation: 4,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(16),
//         ),
//         margin: const EdgeInsets.only(bottom: 16),
//         child: Column(children: [
//           InkWell(
//             onTap: () {
//               setState(() {
//                 _isExpanded = !_isExpanded;
//               });
//             },
//             borderRadius: BorderRadius.circular(16),
//             child: Container(
//               padding: const EdgeInsets.all(20),
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(16),
//                 gradient: LinearGradient(
//                   colors: [
//                     const Color(0xFF626f9f),
//                     const Color(0xFF626f9f).withOpacity(0.9)
//                   ],
//                   begin: Alignment.topLeft,
//                   end: Alignment.bottomRight,
//                 ),
//               ),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Expanded(
//                     child: Text(
//                       widget.title,
//                       style: const TextStyle(
//                         fontSize: 20,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.white,
//                       ),
//                     ),
//                   ),
//                   Row(
//                     children: [
//                       IconButton(
//                         icon: Icon(
//                           _isFavorite ? Icons.favorite : Icons.favorite_border,
//                           color: _isFavorite ? Colors.red : Colors.white,
//                         ),
//                         onPressed: _toggleFavorite,
//                       ),
//                       Icon(
//                         _isExpanded ? Icons.expand_less : Icons.expand_more,
//                         color: const Color(0xFFFFD700),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           AnimatedContainer(
//               duration: const Duration(milliseconds: 300),
//               curve: Curves.easeInOut,
//               height: _isExpanded ? 140 : 0,
//               child: SingleChildScrollView(
//                   physics: const NeverScrollableScrollPhysics(),
//                   child: Padding(
//                     padding: const EdgeInsets.symmetric(
//                         horizontal: 20, vertical: 10),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                       children: [
//                         Expanded(
//                           child: _buildHiringOption(
//                             'Rent'.tr(),
//                             () {
//                               if (user == null) {
//                                 Navigator.push(
//                                     context,
//                                     MaterialPageRoute(
//                                       builder: (context) => const LoginScreen(),
//                                     ));
//                               } else {
//                                 _showCountryList(context, true);
//                               }
//                             },
//                             const Color(0xffb0b3be),
//                           ),
//                         ),
//                         const SizedBox(width: 12),
//                         Expanded(
//                           child: _buildHiringOption(
//                             'Recruit'.tr(),
//                             () {
//                               if (user == null) {
//                                 Navigator.push(
//                                     context,
//                                     MaterialPageRoute(
//                                       builder: (context) => const LoginScreen(),
//                                     ));
//                               } else {
//                                 _showCountryList(context, false);
//                               }
//                             },
//                             const Color(0xffb0b3be),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ))),
//           if (_isExpanded)
//             const SizedBox(
//               height: 20,
//             )
//         ]));
//   }

//   Widget _buildHiringOption(String title, VoidCallback onPressed, Color color) {
//     return AspectRatio(
//       aspectRatio: 1,
//       child: ElevatedButton(
//         onPressed: onPressed,
//         style: ElevatedButton.styleFrom(
//           backgroundColor: color,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(10),
//           ),
//           elevation: 3,
//         ),
//         child: Text(
//           title,
//           style: const TextStyle(
//             fontSize: 24,
//             fontWeight: FontWeight.bold,
//             color: Color(0xFF263238),
//           ),
//           textAlign: TextAlign.center,
//         ),
//       ),
//     );
//   }

//   void _showCountryList(BuildContext context, bool isRent) async {
//     _isRent = isRent;
//     List countries = await _serviceProvider.getCountries(isRent);

//     countries ??= [];

//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: Colors.transparent,
//       builder: (BuildContext context) {
//         return Container(
//           height: MediaQuery.of(context).size.height * 0.75,
//           decoration: const BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//           ),
//           child: Column(
//             children: [
//               Container(
//                 padding: const EdgeInsets.all(16),
//                 decoration: const BoxDecoration(
//                   color: Color(0xFF626f9f),
//                   borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//                 ),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text(
//                       isRent
//                           ? 'Select Rent Country'.tr()
//                           : 'Select Recruit Country'.tr(),
//                       style: const TextStyle(
//                           fontSize: 20,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.white),
//                     ),
//                     IconButton(
//                       icon: const Icon(Icons.close, color: Colors.white),
//                       onPressed: () => Navigator.pop(context),
//                     ),
//                   ],
//                 ),
//               ),
//               Expanded(
//                 child: ListView.builder(
//                   itemCount: countries.length,
//                   itemBuilder: (context, index) {
//                     return ListTile(
//                       leading:
//                           const Icon(Icons.location_on, color: Colors.grey),
//                       title: Text(countries[index],
//                           style: const TextStyle(fontSize: 18)),
//                       trailing: const Icon(Icons.arrow_forward_ios, size: 16),
//                       onTap: () {
//                         _selectedCountry = countries[index];
//                         Navigator.pop(context);
//                         _showDurationPicker(context, isRent);
//                       },
//                     );
//                   },
//                 ),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   void _showDurationPicker(BuildContext context, bool isRent) {
//     List<String> durationOptions = [];

//     if (isRent) {
//       for (int i = 1; i <= 24; i++) {
//         durationOptions.add('$i ${i == 1 ? 'month'.tr() : 'months'.tr()}');
//       }
//     } else {
//       for (double i = 1; i <= 10; i += 0.5) {
//         if (i % 1 == 0) {
//           durationOptions.add('${i.toInt()} ${'years'.tr()}');
//         } else {
//           durationOptions
//               .add('${i.toStringAsFilastrasin1d(1)} ${'years'.tr()}');
//         }
//       }
//     }

//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: Colors.transparent,
//       builder: (BuildContext context) {
//         return Container(
//           height: MediaQuery.of(context).size.height * 0.75,
//           decoration: const BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//           ),
//           child: Column(
//             children: [
//               Container(
//                 padding: const EdgeInsets.all(16),
//                 decoration: const BoxDecoration(
//                   color: Color(0xFF626f9f),
//                   borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//                 ),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text(
//                       'Select Duration'.tr(),
//                       style: const TextStyle(
//                           fontSize: 20,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.white),
//                     ),
//                     IconButton(
//                       icon: const Icon(Icons.close, color: Colors.white),
//                       onPressed: () {
//                         Navigator.pop(context);
//                       },
//                     ),
//                   ],
//                 ),
//               ),
//               Expanded(
//                 child: ListView.builder(
//                   itemCount: durationOptions.length,
//                   itemBuilder: (context, index) {
//                     return ListTile(
//                       leading: const Icon(Icons.calendar_today,
//                           color: Colors.orange),
//                       title: Text(
//                         durationOptions[index],
//                         style: const TextStyle(fontSize: 18),
//                       ),
//                       trailing: const Icon(Icons.arrow_forward_ios, size: 16),
//                       onTap: () {
//                         Navigator.pop(context);
//                         _selectedDuration = durationOptions[index];
//                         _showWorkerSelectionDialog(context);
//                       },
//                     );
//                   },
//                 ),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   void _showWorkerSelectionDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return Dialog(
//           backgroundColor: const Color(0xFF626f9f),
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(16),
//           ),
//           child: ConstrainedBox(
//             constraints: BoxConstraints(
//               maxHeight: MediaQuery.of(context).size.height * 0.7,
//               maxWidth: MediaQuery.of(context).size.width * 0.9,
//             ),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Flexible(
//                   child: Consumer<WorkersProvider>(
//                     builder: (context, workersProvider, child) {
//                       return ListView.separated(
//                         shrinkWrap: true,
//                         itemCount: workersProvider.workers.length,
//                         separatorBuilder: (context, index) =>
//                             const Divider(height: 1),
//                         itemBuilder: (context, index) {
//                           final worker = workersProvider.workers[index];
//                           return ListTile(
//                             leading: SvgPicture.asset(
//                                 "assets/whatsapp-svgrepo-com.svg"),
//                             title: Text(
//                               context.locale.languageCode == 'ar'
//                                   ? worker.name
//                                   : worker.nameEn,
//                               style: const TextStyle(
//                                   color: Colors.white,
//                                   fontSize: 22,
//                                   fontWeight: FontWeight.w500),
//                             ),
//                             subtitle: Text(
//                               worker.phoneNumber,
//                               style: const TextStyle(
//                                   color: Colors.white,
//                                   fontSize: 18,
//                                   fontWeight: FontWeight.w300),
//                             ),
//                             trailing: const Icon(
//                               Icons.arrow_forward_ios,
//                               size: 16,
//                               color: Color(0xFFFFD700),
//                             ),
//                             onTap: () {
//                               Navigator.of(context).pop();
//                               _openWhatsApp(context, worker.phoneNumber);
//                             },
//                           );
//                         },
//                       );
//                     },
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }

//   void _openWhatsApp(BuildContext context, String phoneNumber) async {
//     final serviceType = _isRent ? 'Rent'.tr() : 'Recruit'.tr();
//     final message = '''
// ${context.locale.languageCode == 'ar' ? "السلام عليكم، أنا اخترت" : 'السلام عليكم'}
// ${context.locale.languageCode == 'ar' ? 'الخدمة' : 'Service'}: ${widget.title}
// ${context.locale.languageCode == 'ar' ? 'النوع' : 'Type'}: $serviceType
// ${context.locale.languageCode == 'ar' ? 'البلد' : 'Country'}: $_selectedCountry
// ${context.locale.languageCode == 'ar' ? 'المدة' : 'Duration'}: $_selectedDuration
// ''';

//     final encodedMessage = Uri.encodeFull(message);
//     final whatsappUrl = 'https://wa.me/$phoneNumber?text=$encodedMessage';

//     if (await canLaunch(whatsappUrl)) {
//       await launch(whatsappUrl);
//       print(message);
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Could not open WhatsApp'.tr())),
//       );
//     }
//   }
// }
