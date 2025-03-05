import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class BodyProvider with ChangeNotifier {
  bool _bodyValue = false;

  bool get bodyValue => _bodyValue;

  void setbodyValue(bool value) {
    _bodyValue = value;
    notifyListeners();
  }

  // استمع للتغييرات في المستند
  void listenToBody() {
    FirebaseFirestore.instance
        .collection('toggle')
        .doc('KJeY5UpW6ERvvDIzP8CD')
        .snapshots()
        .listen((documentSnapshot) {
      if (documentSnapshot.exists) {
        bool value = documentSnapshot.get('body');
        setbodyValue(value);
      }
    });
  }
}
