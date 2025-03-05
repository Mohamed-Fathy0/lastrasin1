// // ignore_for_file: public_member_api_docs, sort_constructors_first
// import 'package:easy_localization/easy_localization.dart';
// import 'package:flutter/material.dart';
// import 'package:lastrasin1/viewmodel/body_provider.dart';
// import 'package:provider/provider.dart';

// import 'package:lastrasin1/methods/methods.dart';
// import 'package:lastrasin1/viewmodel/countries_provider.dart';

// class CountryListScreen extends StatelessWidget {
//   final bool isRent;
//   final bool isOther;
//   final String service;

//   const CountryListScreen({
//     super.key,
//     required this.isRent,
//     required this.isOther,
//     required this.service,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final bodyProvider = Provider.of<BodyProvider>(context);
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('اختر الجنسية'.tr()),
//       ),
//       body: Consumer<CountriesProvider>(
//         builder: (context, countriesProvider, child) {
//           if (countriesProvider.isLoading) {
//             return const Center(child: CircularProgressIndicator());
//           }

//           final filteredCountries =
//               countriesProvider.countries.where((country) {
//             return isRent
//                 ? country['collectionName'] == 'rent'
//                 : country['collectionName'] == 'recruit';
//           }).toList();

//           if (filteredCountries.isEmpty) {
//             return Center(child: Text('Check Your Wifi '.tr()));
//           }
//           return GridView.builder(
//             padding: const EdgeInsets.all(10),
//             gridDelegate: const SliverGridDelegateWithFilastrasin1dCrossAxisCount(
//               crossAxisCount: 3,
//               childAspectRatio: 1,
//               mainAxisSpacing: 10,
//               crossAxisSpacing: 10,
//             ),
//             itemCount: filteredCountries.length,
//             itemBuilder: (context, index) {
//               final country = filteredCountries[index];
//               final imageUrl = country['imageUrl'];
//               final countryName = country['countryAr'];

//               return InkWell(
//                 onTap: () {
//                   showCountryList(context, isRent, isOther, countryName,
//                       service, bodyProvider);
//                 },
//                 child: Column(
//                   children: [
//                     CircleAvatar(
//                       backgroundColor: Colors.transparent,
//                       backgroundImage: NetworkImage(imageUrl),
//                       radius: 30,
//                     ),
//                     const SizedBox(height: 8),
//                     Text(
//                       countryName,
//                       style: const TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                       ),
//                       textAlign: TextAlign.center,
//                     ),
//                   ],
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }
