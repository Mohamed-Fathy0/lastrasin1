import 'package:cloud_firestore/cloud_firestore.dart';

class CustomOrderModel {
  final String email;
  final String firstName;
  final String lastName;
  final String serviceType;
  final String phoneNumber;
  final String serviceDetails;
  final Timestamp timestamp;

  CustomOrderModel({
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.serviceType,
    required this.phoneNumber,
    required this.serviceDetails,
    required this.timestamp,
  });

  factory CustomOrderModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return CustomOrderModel(
      email: data['email'],
      firstName: data['firstName'],
      lastName: data['lastName'],
      serviceType: data['serviceType'],
      phoneNumber: data['phoneNumber'],
      serviceDetails: data['serviceDetails'],
      timestamp: data['timestamp'],
    );
  }
}
