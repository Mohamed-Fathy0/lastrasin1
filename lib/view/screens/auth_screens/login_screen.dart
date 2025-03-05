import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lastrasin1/view/screens/auth_screens/forgot_password_screen.dart';
import 'package:lastrasin1/view/screens/auth_screens/signup_screen.dart';
import 'package:lastrasin1/view/screens/layout_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  bool _isLoading = false;
  //final _googleSignIn = GoogleSignIn();

  Future<void> _loginWithEmail() async {
    // التحقق من أن الحقول غير فارغة عند محاولة تسجيل الدخول أول مرة
    if (_emailController.text.isEmpty) {
      Fluttertoast.showToast(msg: 'Please enter your email');
      return;
    }
    if (_passwordController.text.isEmpty) {
      Fluttertoast.showToast(msg: 'Please enter your password');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final UserCredential userCredential =
          await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      if (userCredential.user != null) {
        // Navigate to the home screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => LayoutScreen(),
          ),
        );
      }
    } catch (e) {
      Fluttertoast.showToast(msg: 'Failed to login: ${e.toString()}');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Future<void> _loginWithGoogle() async {
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
  //       Navigator.pushReplacement(
  //         context,
  //         MaterialPageRoute(
  //           builder: (context) => LayoutScreen(),
  //         ),
  //       );
  //     }
  //   } catch (e) {
  //     Fluttertoast.showToast(msg: 'Failed to login: ${e.toString()}');
  //   } finally {
  //     setState(() {
  //       _isLoading = false;
  //     });
  //   }
  // }

//----

  // static signInWithApple(BuildContext context) async {
  //   try {
  //     var redirectURL = "https://facebook.com/api/auth/apple/callback";
  //     var clientID = "com.example.services-app";

  //     print(
  //         '<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< Can Use Apple Auth? ${await SignInWithApple.isAvailable()}>>>>>>>>>>>>>>>>>>>>>>>');
  //     final appleIdCredential = await SignInWithApple.getAppleIDCredential(
  //       scopes: [
  //         AppleIDAuthorizationScopes.email,
  //         AppleIDAuthorizationScopes.fullName,
  //       ],
  //     );

  //     print(
  //         '<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<$appleIdCredential>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>');
  //     await signInApple(context, appleIdCredential);
  //   } catch (error) {
  //     print('Error during sign in with Apple: $error');
  //     Fluttertoast.showToast(msg: 'Failed to sign in with Apple');
  //   }
  // }

  // static Future signInApple(BuildContext context,
  //     AuthorizationCredentialAppleID appleIdCredential) async {
  //   try {
  //     final oAuthProvider = OAuthProvider("apple.com");
  //     final credential = oAuthProvider.credential(
  //       idToken: appleIdCredential.identityToken,
  //       accessToken: appleIdCredential.authorizationCode,
  //     );

  //     UserCredential userCredential =
  //         await FirebaseAuth.instance.signInWithCredential(credential);

  //     if (userCredential.user != null) {
  //       SharedPreferences prefs = await SharedPreferences.getInstance();
  //       await prefs.setString('token', userCredential.user!.uid);
  //       Navigator.pushReplacement(
  //           context, MaterialPageRoute(builder: (context) => LayoutScreen()));
  //     } else {
  //       Fluttertoast.showToast(msg: 'Failed to sign in with Apple');
  //     }
  //   } catch (error) {
  //     print('Error during sign in with Apple: $error');
  //     Fluttertoast.showToast(msg: 'Failed to sign in with Apple');
  //   }
  // }

  //----
  Future<void> _forgotPassword() async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ForgotPasswordScreen(),
      ),
    );
    if (_emailController.text.isEmpty) {
      Fluttertoast.showToast(msg: 'Please enter your email');
      return;
    }

    try {
      await _auth.sendPasswordResetEmail(email: _emailController.text.trim());
      Fluttertoast.showToast(msg: 'Password reset email sent');
    } catch (e) {
      Fluttertoast.showToast(
          msg: 'Failed to send password reset email: ${e.toString()}');
    }
  }

  void _navigateToSignUp() {
    // Navigate to the sign-up screen
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const SignUpScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'.tr()),
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "".tr(),
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF3F51B5),
                  ),
                ),
                const SizedBox(height: 20),
                Image.asset(
                  "assets/logo.png",
                  height: 120,
                ),
                const SizedBox(height: 40),
                if (_isLoading)
                  const Center(child: CircularProgressIndicator())
                else ...[
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
                  const SizedBox(height: 24),
                  _buildButton(
                      text: 'تسجيل الدخول'.tr(),
                      onPressed: _loginWithEmail,
                      color: Colors.black,
                      widget: const Text("")),
                  // const SizedBox(height: 16),
                  // _buildButton(
                  //     text: 'Login with Google'.tr(),
                  //     onPressed: _loginWithGoogle,
                  //     color: Colors.black,
                  //     widget: SvgPicture.asset(
                  //       "assets/google-svgrepo-com.svg",
                  //       height: 20,
                  //     )),
                  const SizedBox(height: 16),
                  // SignInWithAppleButton(onPressed: () async {
                  //   await signInWithApple(context);
                  // }),
                  const SizedBox(height: 24),
                  TextButton(
                    onPressed: _forgotPassword,
                    child: Text(
                      'Forgot Password?'.tr(),
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: _navigateToSignUp,
                    child: Text(
                      'Create an Account'.tr(),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

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
        labelText: labelText,
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

  Widget _buildButton({
    required String text,
    required VoidCallback onPressed,
    required Color color,
    required Widget widget,
  }) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 5,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const Text(""),
            Text(
              text.tr(),
              style: const TextStyle(fontSize: 16, color: Colors.white),
            ),
            widget,
          ],
        ),
      ),
    );
  }
}
