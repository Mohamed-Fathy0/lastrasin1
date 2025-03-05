import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lastrasin1/view/screens/auth_screens/verify_email_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  //final _googleSignIn = GoogleSignIn();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool _isLoading = false;
  Future<void> _signUpWithEmail() async {
    setState(() {
      _isLoading = true;
    });

    if (_firstNameController.text.isEmpty ||
        _lastNameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _confirmPasswordController.text.isEmpty) {
      Fluttertoast.showToast(msg: 'Please fill in all fields'.tr());
      setState(() {
        _isLoading = false;
      });
      return;
    }

    if (_passwordController.text != _confirmPasswordController.text) {
      Fluttertoast.showToast(msg: 'Passwords do not match'.tr());
      setState(() {
        _isLoading = false;
      });
      return;
    }

    try {
      final UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      if (userCredential.user != null) {
        await userCredential.user!.updateProfile(
          displayName:
              "${_firstNameController.text} ${_lastNameController.text}",
        );

        // إرسال رسالة تحقق للبريد الإلكتروني
        await userCredential.user!.sendEmailVerification();

        // تخزين بيانات المستخدم في مجموعة users في Firestore
        await _firestore.collection('users').doc(userCredential.user!.uid).set({
          'firstName': _firstNameController.text,
          'lastName': _lastNameController.text,
          'email': _emailController.text,
          'uid': userCredential.user!.uid,
        });

        // الانتقال إلى شاشة مراجعة البريد الإلكتروني
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const VerifyEmailScreen(),
          ),
        );
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      switch (e.code) {
        case 'email-already-in-use':
          errorMessage = 'This email address is already in use.'.tr();
          break;
        case 'invalid-email':
          errorMessage = 'This email address is invalid.'.tr();
          break;
        case 'operation-not-allowed':
          errorMessage = 'Email/password accounts are not enabled.'.tr();
          break;
        case 'weak-password':
          errorMessage = 'The password is too weak.'.tr();
          break;
        default:
          errorMessage = 'Failed to sign up: ${e.message}'.tr();
          break;
      }
      Fluttertoast.showToast(msg: errorMessage);
    } catch (e) {
      Fluttertoast.showToast(msg: 'Failed to sign up: ${e.toString()}'.tr());
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Future<void> _signUpWithGoogle() async {
  //   setState(() {
  //     _isLoading = true;
  //   });

  //   try {
  //     final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
  //     final GoogleSignInAuthentication googleAuth =
  //         await googleUser!.authentication;

  //     final credential = GoogleAuthProvider.credential(
  //       accessToken: googleAuth.accessToken,
  //       idToken: googleAuth.idToken,
  //     );

  //     final UserCredential userCredential =
  //         await _auth.signInWithCredential(credential);
  //     if (userCredential.user != null) {
  //       await _firestore.collection('users').doc(userCredential.user!.uid).set({
  //         'firstName': userCredential.user!.displayName!.split(' ')[0],
  //         'lastName': userCredential.user!.displayName!.split(' ')[1],
  //         'email': userCredential.user!.email,
  //         'uid': userCredential.user!.uid,
  //       });
  //       // Navigate to the home screen or another screen
  //     }
  //   } catch (e) {
  //     Fluttertoast.showToast(msg: 'Failed to sign up: ${e.toString()}');
  //   } finally {
  //     setState(() {
  //       _isLoading = false;
  //     });
  //   }
  // }

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: labelText.tr(),
        labelStyle: const TextStyle(color: Colors.grey),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.blue, width: 2),
        ),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        filled: true,
        fillColor: Colors.grey[200],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up'.tr()),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                " رصين".tr(),
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Image.asset(
                "assets/logo.png",
                height: 200,
              ),
              if (_isLoading)
                const Center(child: CircularProgressIndicator())
              else ...[
                _buildTextField(
                  controller: _firstNameController,
                  labelText: 'First Name'.tr(),
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _lastNameController,
                  labelText: 'Last Name'.tr(),
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _emailController,
                  labelText: 'Email'.tr(),
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _passwordController,
                  labelText: 'Password'.tr(),
                  obscureText: true,
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _confirmPasswordController,
                  labelText: 'Confirm Password'.tr(),
                  obscureText: true,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _signUpWithEmail,
                  child: Text('انشاء حساب'.tr()),
                ),
                // const SizedBox(height: 16),
                // ElevatedButton(
                //   onPressed: _signUpWithGoogle,
                //   style: ElevatedButton.styleFrom(
                //     backgroundColor: Colors.red,
                //   ),
                //   child: Text('Sign Up with Google'.tr()),
                // ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Navigate back to LoginScreen
                  },
                  child: Text('Already have an account? Log in'.tr()),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
