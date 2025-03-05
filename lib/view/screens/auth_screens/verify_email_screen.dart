import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lastrasin1/view/screens/layout_screen.dart';

class VerifyEmailScreen extends StatefulWidget {
  const VerifyEmailScreen({super.key});

  @override
  _VerifyEmailScreenState createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
  final _auth = FirebaseAuth.instance;

  Future<void> _checkEmailVerified() async {
    User? user = _auth.currentUser;
    await user?.reload();
    user = _auth.currentUser;

    if (user != null && user.emailVerified) {
      Fluttertoast.showToast(msg: 'تم تأكيد الحساب بنجاح'.tr());
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => LayoutScreen(),
        ),
      );
    } else {
      Fluttertoast.showToast(msg: 'من فضلك تحقق من بريدك'.tr());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('تأكيد البريد'.tr()),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'من فضلك تحقق من بريدك الاكتروني لتأكيد حسابك'.tr(),
                style: const TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _checkEmailVerified,
                child: Text('تم التأكيد'.tr()),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
