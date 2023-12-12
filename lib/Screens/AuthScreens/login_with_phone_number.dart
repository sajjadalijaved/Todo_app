import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:country_picker/country_picker.dart';
import 'package:todo_app/Screens/AuthScreens/verify_phone_number_screen.dart';

class LoginWithPhoneNumberScreen extends StatefulWidget {
  const LoginWithPhoneNumberScreen({super.key});

  @override
  State<LoginWithPhoneNumberScreen> createState() =>
      _LoginWithPhoneNumberScreenState();
}

class _LoginWithPhoneNumberScreenState
    extends State<LoginWithPhoneNumberScreen> {
  late TextEditingController phoneCotroller;
  final FirebaseAuth auth = FirebaseAuth.instance;
  bool isLoading = false;
  String countryCode = '';
  String txt = '+';
  @override
  void initState() {
    super.initState();
    phoneCotroller = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    phoneCotroller.dispose();
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
              child: Image(height: 150, image: AssetImage('assets/phone.png')),
            ),
            const SizedBox(
              height: 30,
            ),
            const Text(
              'Enter your phone number',
              style: TextStyle(fontSize: 22),
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              'We will sent you 6 digit verification code',
              style: TextStyle(fontSize: 16, color: Colors.black54),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 50),
              child: TextField(
                controller: phoneCotroller,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                    prefixIcon: InkWell(
                        onTap: () {
                          showCountryPicker(
                              context: context,
                              onSelect: (Country value) {
                                setState(() {
                                  countryCode = value.phoneCode.toString();
                                });
                              });
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(15),
                          child: countryCode == ''
                              ? const Text('+00')
                              : Text(txt + countryCode),
                        )),
                    labelText: 'Mobile',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    )),
              ),
            ),
            SizedBox(
                height: 50,
                width: 350,
                child: ElevatedButton(
                    onPressed: () {
                      var phone = txt + countryCode + phoneCotroller.text;
                      setState(() {
                        isLoading = true;
                      });
                      auth.verifyPhoneNumber(
                          phoneNumber: phone,
                          verificationCompleted: (context) {
                            setState(() {
                              isLoading = false;
                            });
                          },
                          verificationFailed: (e) {
                            Fluttertoast.showToast(msg: e.toString());
                            setState(() {
                              isLoading = false;
                            });
                          },
                          codeSent: (String verificationId, int? token) {
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => VeriyPhoneNumberScreen(
                                        verificationId: verificationId)),
                                (route) => false);
                          },
                          codeAutoRetrievalTimeout: (e) {
                            Fluttertoast.showToast(msg: e.toString());
                            setState(() {
                              isLoading = false;
                            });
                          });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xffFFB900),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: isLoading
                        ? const CircularProgressIndicator()
                        : const Text(
                            'Generate OTP',
                            style: TextStyle(fontSize: 18),
                          )))
          ],
        ),
      ),
    );
  }
}
