import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class WorkersProvider extends ChangeNotifier {
  List<Worker> _workers = [];

  WorkersProvider() {
    fetchWorkers();
  }

  List<Worker> get workers => _workers;

  Future<void> fetchWorkers() async {
    final snapshot =
        await FirebaseFirestore.instance.collection('workers').get();
    _workers = snapshot.docs.map((doc) => Worker.fromFirestore(doc)).toList();
    notifyListeners();
  }
}

class Worker {
  final String name;
  final String nameEn;
  final String phoneNumber;

  Worker({
    required this.name,
    required this.nameEn,
    required this.phoneNumber,
  });

  factory Worker.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Worker(
      name: data['name'],
      nameEn: data['nameEn'],
      phoneNumber: data['phoneNumber'],
    );
  }
}
