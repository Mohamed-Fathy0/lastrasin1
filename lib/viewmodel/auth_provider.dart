import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthProvider extends ChangeNotifier {
  User? _user;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  AuthProvider() {
    _auth.authStateChanges().listen((user) {
      _user = user;
      notifyListeners();
    });
  }

  User? get user => _user;

  Future<void> signOut() async {
    await _auth.signOut();
    notifyListeners();
  }

  Future<void> deleteAccount() async {
    try {
      if (_user != null) {
        await _user!.delete();
        notifyListeners();
      } else {
        throw FirebaseAuthException(
            code: 'no-user', message: 'No user is currently signed in.');
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'requires-recent-login') {
        // The user must re-authenticate before this operation can be elastrasin1cuted.
        throw FirebaseAuthException(
            code: 'requires-recent-login',
            message:
                'The user must re-authenticate before this operation can be elastrasin1cuted.');
      } else {
        rethrow;
      }
    }
  }
}
