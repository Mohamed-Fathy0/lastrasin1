import 'package:cloud_firestore/cloud_firestore.dart';

class Recruit {
  final String countryAr;
  final String countryEn;

  Recruit({required this.countryAr, required this.countryEn});

  factory Recruit.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Recruit(
      countryAr: data['countryAr'],
      countryEn: data['countryEn'],
    );
  }
}

class Rent {
  final String countryAr;
  final String countryEn;

  Rent({required this.countryAr, required this.countryEn});

  factory Rent.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Rent(
      countryAr: data['countryAr'],
      countryEn: data['countryEn'],
    );
  }
}

class Country {
  final String countryAr;
  final String imageUrl;

  Country({required this.countryAr, required this.imageUrl});
}
