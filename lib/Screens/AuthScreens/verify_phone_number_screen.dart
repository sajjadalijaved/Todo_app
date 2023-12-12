import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:todo_app/Screens/home_screen.dart';
import 'package:pin_code_text_field/pin_code_text_field.dart';
// ignore_for_file: must_be_immutable

class VeriyPhoneNumberScreen extends StatefulWidget {
  String verificationId;
  VeriyPhoneNumberScreen({
    super.key,
    required this.verificationId,
  });

  @override
  State<VeriyPhoneNumberScreen> createState() => _VeriyPhoneNumberScreenState();
}

class _VeriyPhoneNumberScreenState extends State<VeriyPhoneNumberScreen> {
  late TextEditingController codeController;
  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    codeController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    codeController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark));
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(
              height: 100,
            ),
            const Center(
              child: Image(height: 150, image: AssetImage('assets/verify.png')),
            ),
            const SizedBox(
              height: 30,
            ),
            const Text(
              'OTP Verification',
              style: TextStyle(fontSize: 22),
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              'Enter the OTP sent to your phone',
              style: TextStyle(fontSize: 16, color: Colors.black54),
            ),
            const SizedBox(
              height: 40,
            ),
            PinCodeTextField(
              controller: codeController,
              maxLength: 6,
              pinBoxHeight: 50,
              pinBoxWidth: 50,
            ),
            const SizedBox(
              height: 50,
            ),
            SizedBox(
              height: 50,
              width: 350,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xffFFB900),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      )),
                  onPressed: () async {
                    var credential = PhoneAuthProvider.credential(
                        verificationId: widget.verificationId.toString(),
                        smsCode: codeController.text.toString());
                    try {
                      await auth.signInWithCredential(credential).then(
                          (value) => Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const HomeScreen()),
                              (route) => false));
                    } catch (e) {
                      Fluttertoast.showToast(msg: e.toString());
                    }
                  },
                  child: const Text(
                    'Verify & Continue',
                    style: TextStyle(fontSize: 18),
                  )),
            )
          ],
        ),
      ),
    );
  }
}
