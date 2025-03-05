import 'package:cloud_firestore/cloud_firestore.dart';

class ServiceProvider {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Future<List> getCountries(bool isRent) async {
    String collection = isRent ? 'rent' : 'recruit';
    var snapshot = await _firestore.collection(collection).get();
    if (snapshot.docs.isEmpty) {
      return []; // تأكد من أن البيانات ليست فارغة
    }
    return snapshot.docs.map((doc) {
      return doc['countryEn'] ?? ''; // تأكد من التعامل مع القيم null
    }).toList();
  }
}
