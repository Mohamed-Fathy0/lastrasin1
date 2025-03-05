import 'package:cloud_firestore/cloud_firestore.dart';

class LinkService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<LinkModel> getLink() async {
    DocumentSnapshot doc = await _firestore
        .collection('links')
        .doc('mmszhdSQSs70TGNlastrasin1C3J')
        .get();
    return LinkModel.fromMap(doc.id, doc.data() as Map<String, dynamic>);
  }
}

class LinkModel {
  String id;
  String websiteLink;
  String privacyPolicyLink;

  LinkModel({
    required this.id,
    required this.websiteLink,
    required this.privacyPolicyLink,
  });

  Map<String, dynamic> toMap() {
    return {
      'websiteLink': websiteLink,
      'privacyPolicyLink': privacyPolicyLink,
    };
  }

  static LinkModel fromMap(String id, Map<String, dynamic> map) {
    return LinkModel(
      id: id,
      websiteLink: map['websiteLink'],
      privacyPolicyLink: map['privacyPolicyLink'],
    );
  }
}
