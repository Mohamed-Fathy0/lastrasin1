// import 'package:shared_preferences/shared_preferences.dart';

// class FavoritesManager {
//   static const String _favoritesKey = 'favorites';

//   Future<void> toggleFavorite(String serviceName) async {
//     final prefs = await SharedPreferences.getInstance();
//     final favoriteServices = prefs.getStringList(_favoritesKey) ?? [];

//     if (favoriteServices.contains(serviceName)) {
//       favoriteServices.remove(serviceName);
//     } else {
//       favoriteServices.add(serviceName);
//     }

//     await prefs.setStringList(_favoritesKey, favoriteServices);
//   }

//   Future<bool> isFavorite(String serviceName) async {
//     final prefs = await SharedPreferences.getInstance();
//     final favoriteServices = prefs.getStringList(_favoritesKey) ?? [];
//     return favoriteServices.contains(serviceName);
//   }

//   Future<List<String>> getFavoriteServices() async {
//     final prefs = await SharedPreferences.getInstance();
//     return prefs.getStringList(_favoritesKey) ?? [];
//   }
// }
