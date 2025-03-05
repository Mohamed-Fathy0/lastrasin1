// import 'package:flutter/material.dart';
// import 'package:lastrasin1/view/widgets/service_card.dart';
// import 'package:lastrasin1/viewmodel/fav_manager.dart';

// class FavoritesScreen extends StatefulWidget {
//   const FavoritesScreen({super.key});

//   @override
//   _FavoritesScreenState createState() => _FavoritesScreenState();
// }

// class _FavoritesScreenState extends State<FavoritesScreen> {
//   List<String> _favoriteServices = [];

//   @override
//   void initState() {
//     super.initState();
//     _loadFavorites();
//   }

//   Future<void> _loadFavorites() async {
//     final FavoritesManager favoritesManager = FavoritesManager();
//     final List<String> favoriteServices =
//         await favoritesManager.getFavoriteServices();
//     setState(() {
//       _favoriteServices = favoriteServices;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('الخدمات المفضلة'),
//       ),
//       body: _favoriteServices.isEmpty
//           ? const Center(
//               child: Text(
//                 'No favorite services found.',
//                 style: TextStyle(fontSize: 18),
//               ),
//             )
//           : ListView.builder(
//               padding: const EdgeInsets.all(16),
//               itemCount: _favoriteServices.length,
//               itemBuilder: (context, index) {
//                 return ServiceCard(
//                   title: _favoriteServices[index],
//                 );
//               },
//             ),
//     );
//   }
// }
