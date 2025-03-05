import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lastrasin1/model/recruit.dart';

class CountryProvider with ChangeNotifier {
  List<Country> _countries = [];

  List<Country> get countries => _countries;

  Future<void> fetchCountries() async {
    final QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('countries').get();

    _countries = snapshot.docs.map((doc) {
      return Country(
        countryAr: doc['countryAr'],
        imageUrl: doc['imageUrl'],
      );
    }).toList();

    notifyListeners();
  }
}
