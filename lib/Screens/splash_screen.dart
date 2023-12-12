import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:todo_app/Screens/home_screen.dart';
import 'package:todo_app/Screens/AuthScreens/sign_up_screen.dart';
// ignore_for_file: use_build_context_synchronously

class Splash extends StatefulWidget {
  const Splash({super.key});
  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  FirebaseAuth auth = FirebaseAuth.instance;
  void checkAuthentication() async {
    if (auth.currentUser != null) {
      await Future.delayed(const Duration(seconds: 5));
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
          (route) => false);
    } else {
      await Future.delayed(const Duration(seconds: 5));
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const SignUpScreen()),
          (route) => false);
    }
  }

  @override
  void initState() {
    super.initState();
    checkAuthentication();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.sizeOf(context).height;
    double width = MediaQuery.sizeOf(context).width;
    return Scaffold(
      backgroundColor: const Color(0xffFFB900),
      body: SizedBox(
        height: height,
        width: width,
        child: const Center(
          child: Image(
            image: AssetImage('assets/splash.png'),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
