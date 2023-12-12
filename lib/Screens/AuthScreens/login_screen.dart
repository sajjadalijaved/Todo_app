import 'package:ndialog/ndialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:animate_do/animate_do.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:todo_app/Screens/home_screen.dart';
import 'package:todo_app/Utils/Validation/validation.dart';
import 'package:todo_app/Screens/AuthScreens/sign_up_screen.dart';
// ignore_for_file: use_build_context_synchronously

// ignore_for_file: non_constant_identifier_names

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late TextEditingController emailController;
  late TextEditingController passwordController;
  final GlobalKey<FormState> key = GlobalKey<FormState>();

  ValueNotifier<bool> obscureText = ValueNotifier<bool>(true);

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
    passwordController = TextEditingController();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.sizeOf(context).height;
    double width = MediaQuery.sizeOf(context).width;
    return AnnotatedRegion<SystemUiOverlayStyle>(
        value: const SystemUiOverlayStyle(
            statusBarColor: Color(0xffFFB900),
            systemNavigationBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.light,
            systemNavigationBarIconBrightness: Brightness.dark),
        child: Scaffold(
          backgroundColor: const Color(0xffFFB900),
          body: SingleChildScrollView(
            child: Form(
              key: key,
              child: Column(
                children: [
                  FadeInUp(
                    duration: const Duration(milliseconds: 1500),
                    child: Container(
                        width: width,
                        height: height * 0.35,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/Logo.png'),
                          ),
                          color: Color(0xffFFB900),
                        )),
                  ),
                  Container(
                    width: width,
                    height: height,
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(35),
                            topRight: Radius.circular(35)),
                        color: Colors.white),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: width * 0.03),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: height * 0.03,
                          ),
                          FadeInUp(
                            delay: const Duration(milliseconds: 900),
                            duration: const Duration(milliseconds: 1000),
                            child: Text('SIGNIN',
                                style: TextStyle(
                                    fontSize: 28,
                                    fontFamily: 'Roboto-Bold',
                                    letterSpacing: 3,
                                    color: const Color(0xffFFB900),
                                    shadows: [
                                      BoxShadow(
                                          color: Colors.grey.withOpacity(0.5),
                                          blurRadius: 5,
                                          spreadRadius: 5,
                                          offset: const Offset(1, 2))
                                    ])),
                          ),
                          SizedBox(
                            height: height * 0.03,
                          ),
                          FadeInUp(
                            delay: const Duration(milliseconds: 1200),
                            duration: const Duration(milliseconds: 1000),
                            child: TextFormField(
                              textInputAction: TextInputAction.next,
                              validator: (value) {
                                return FieldValidator.validateEmail(
                                    value.toString());
                              },
                              cursorColor: const Color(0xffFFB900),
                              controller: emailController,
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                  prefixIcon: const Icon(Icons.email,
                                      color: Color(0xffFFB900)),
                                  hintText: 'Enter Email',
                                  hintStyle: const TextStyle(
                                      color: Color(0xffFFB900), fontSize: 18),
                                  labelText: 'Email',
                                  labelStyle: const TextStyle(
                                      color: Color(0xffFFB900), fontSize: 18),
                                  fillColor: Colors.grey.withOpacity(0.1),
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: const BorderSide(
                                          color: Color(0xffFFB900))),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: const BorderSide(
                                          color: Color(0xffFFB900))),
                                  disabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: const BorderSide(
                                          color: Color(0xffFFB900))),
                                  errorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide:
                                          const BorderSide(color: Colors.red)),
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: const BorderSide(
                                          color: Color(0xffFFB900)))),
                            ),
                          ),
                          SizedBox(
                            height: height * 0.03,
                          ),
                          ValueListenableBuilder(
                            valueListenable: obscureText,
                            builder: (context, value, child) => FadeInUp(
                              delay: const Duration(milliseconds: 1400),
                              duration: const Duration(milliseconds: 1000),
                              child: TextFormField(
                                textInputAction: TextInputAction.done,
                                obscureText: obscureText.value,
                                obscuringCharacter: '*',
                                validator: (value) {
                                  return FieldValidator.validatePassword(
                                      value.toString());
                                },
                                cursorColor: const Color(0xffFFB900),
                                controller: passwordController,
                                keyboardType: TextInputType.visiblePassword,
                                decoration: InputDecoration(
                                    suffixIcon: InkWell(
                                        onTap: () {
                                          obscureText.value =
                                              !obscureText.value;
                                        },
                                        child: Icon(
                                            obscureText.value
                                                ? Icons.visibility_off_outlined
                                                : Icons.visibility,
                                            color: const Color(0xffFFB900))),
                                    prefixIcon: const Icon(Icons.password_sharp,
                                        color: Color(0xffFFB900)),
                                    hintText: 'Enter Password',
                                    hintStyle: const TextStyle(
                                        color: Color(0xffFFB900), fontSize: 18),
                                    labelText: 'Password',
                                    labelStyle: const TextStyle(
                                        color: Color(0xffFFB900), fontSize: 18),
                                    fillColor: Colors.grey.withOpacity(0.1),
                                    enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: const BorderSide(
                                            color: Color(0xffFFB900))),
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: const BorderSide(
                                            color: Color(0xffFFB900))),
                                    disabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: const BorderSide(
                                            color: Color(0xffFFB900))),
                                    errorBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: const BorderSide(
                                            color: Colors.red)),
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: const BorderSide(
                                            color: Color(0xffFFB900)))),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: height * 0.01,
                          ),
                          FadeInUp(
                            delay: const Duration(milliseconds: 1600),
                            duration: const Duration(milliseconds: 1000),
                            child: const Align(
                              alignment: Alignment.bottomRight,
                              child: Text(
                                'Forgot Passwrd!',
                                style: TextStyle(
                                    fontSize: 17, color: Color(0xffFFB900)),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: height * 0.05,
                          ),
                          FadeInUp(
                            delay: const Duration(milliseconds: 1800),
                            duration: const Duration(milliseconds: 1000),
                            child: InkWell(
                              onTap: () async {
                                if (key.currentState!.validate()) {
                                  ProgressDialog Progress = ProgressDialog(
                                      context,
                                      title: const Text(
                                        'Signing In',
                                        style:
                                            TextStyle(color: Color(0xffFFB900)),
                                      ),
                                      message: const Text(
                                        'Please Wait...',
                                        style:
                                            TextStyle(color: Color(0xffFFB900)),
                                      ));
                                  Progress.show();
                                  FirebaseAuth FBauth = FirebaseAuth.instance;
                                  try {
                                    UserCredential Usercredential =
                                        await FBauth.signInWithEmailAndPassword(
                                            email: emailController.text.trim(),
                                            password:
                                                passwordController.text.trim());
                                    Progress.dismiss();
                                    User? user = Usercredential.user;
                                    if (user != null) {
                                      Navigator.pushAndRemoveUntil(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const HomeScreen()),
                                          (route) => false);
                                      Fluttertoast.showToast(
                                          msg: 'Login Successfully!');
                                    }
                                  } on FirebaseAuthException catch (e) {
                                    Progress.dismiss();
                                    if (e.code == 'user-not-found') {
                                      Fluttertoast.showToast(
                                          msg: 'Inavalid Email');
                                    } else if (e.code == 'wrong-password') {
                                      Fluttertoast.showToast(
                                          msg: 'Inavalid Password');
                                    }
                                  }
                                } else {
                                  Fluttertoast.showToast(msg: 'Login Failed!');
                                }
                              },
                              child: Container(
                                height: 50,
                                width: 250,
                                decoration: BoxDecoration(
                                    color: const Color(0xffFFB900),
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [
                                      BoxShadow(
                                        offset: const Offset(0, 3),
                                        color: Colors.grey.withOpacity(0.5),
                                        blurRadius: 10,
                                      ),
                                    ]),
                                child: const Center(
                                    child: Text(
                                  'SignIn',
                                  style: TextStyle(
                                      fontSize: 25,
                                      color: Colors.white,
                                      //fontFamily: 'Roboto-Medium',
                                      letterSpacing: 2),
                                )),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: height * 0.02,
                          ),
                          FadeInUp(
                            delay: const Duration(milliseconds: 2000),
                            duration: const Duration(milliseconds: 1000),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  'Don,t have account?',
                                  style: TextStyle(
                                      color: Color(0xffFFB900), fontSize: 17),
                                ),
                                TextButton(
                                    onPressed: () {
                                      Navigator.pushAndRemoveUntil(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const SignUpScreen()),
                                          (route) => false);
                                    },
                                    child: const Text(
                                      'SignUp',
                                      style: TextStyle(
                                          fontSize: 17, color: Colors.blue),
                                    ))
                              ],
                            ),
                          ),
                          SizedBox(
                            height: height * 0.02,
                          ),
                          FadeInUp(
                            delay: const Duration(milliseconds: 2200),
                            duration: const Duration(milliseconds: 1000),
                            child: Container(
                                height: 50,
                                width: 250,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(
                                        color: const Color(0xffFFB900)),
                                    borderRadius: BorderRadius.circular(5),
                                    boxShadow: [
                                      BoxShadow(
                                        offset: const Offset(0, 3),
                                        color: Colors.grey.withOpacity(0.5),
                                        blurRadius: 10,
                                      ),
                                    ]),
                                child: const Center(
                                  child: Text(
                                    'Login with phone number',
                                    style: TextStyle(
                                        color: Color(0xffFFB900), fontSize: 17),
                                  ),
                                )),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
