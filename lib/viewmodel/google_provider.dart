import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class GoogleFieldProvider with ChangeNotifier {
  bool _googleValue = false;

  bool get googleValue => _googleValue;

  void setGoogleValue(bool value) {
    _googleValue = value;
    notifyListeners();
  }

  // استمع للتغييرات في المستند
  void listenToGoogleField() {
    FirebaseFirestore.instance
        .collection('toggle')
        .doc('53oKNtUzodgdzWtH1Wjo')
        .snapshots()
        .listen((documentSnapshot) {
      if (documentSnapshot.exists) {
        bool value = documentSnapshot.get('google');
        setGoogleValue(value);
      }
    });
  }
}
