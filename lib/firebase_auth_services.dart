import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Sign up
  Future<void> signUp(String name, String email, String password) async {
    UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    await _firestore.collection('users').doc(userCredential.user?.uid).set({
      'name': name,
      'email': email,
    });
  }

  // Login
  Future<void> login(String email, String password) async {
    await _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  // Get Current User
  User? get currentUser => _auth.currentUser;

  // Logout
  Future<void> logout() async {
    await _auth.signOut();
  }

  // Fetch User Data
  Future<Map<String, dynamic>> fetchUserData() async {
    DocumentSnapshot userDoc =
        await _firestore.collection('users').doc(currentUser?.uid).get();
    return userDoc.data() as Map<String, dynamic>;
  }

  Future<void> deleteAccount() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await user.delete();
    }
  }
}
