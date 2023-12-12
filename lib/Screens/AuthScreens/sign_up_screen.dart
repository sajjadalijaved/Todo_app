import 'package:ndialog/ndialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:animate_do/animate_do.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo_app/Utils/Validation/validation.dart';
import 'package:todo_app/Screens/AuthScreens/login_screen.dart';
// ignore_for_file: deprecated_member_use

// ignore_for_file: use_build_context_synchronously

// ignore_for_file: non_constant_identifier_names

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  late TextEditingController fullNameController;

  late TextEditingController emailController;
  late TextEditingController passwordController;

  late TextEditingController confirmPasswordController;
  final GlobalKey<FormState> key = GlobalKey<FormState>();

  ValueNotifier<bool> obscureText = ValueNotifier<bool>(true);
  ValueNotifier<bool> confirmPasswordObscureText = ValueNotifier<bool>(true);

  FirebaseAuth fireAuth = FirebaseAuth.instance;
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    fullNameController = TextEditingController();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    confirmPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    fullNameController.dispose();
    confirmPasswordController.dispose();
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
                            image: AssetImage('assets/Signup.png'),
                          ),
                          color: Color(0xffFFB900),
                        )),
                  ),
                  Container(
                    width: width,
                    height: height,
                    decoration: const BoxDecoration(
                        borderRadius:
                            BorderRadius.only(topRight: Radius.circular(70)),
                        color: Colors.white),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: width * 0.03),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: height * 0.06,
                          ),
                          FadeInUp(
                            delay: const Duration(milliseconds: 1000),
                            duration: const Duration(milliseconds: 1000),
                            child: TextFormField(
                              textInputAction: TextInputAction.next,
                              textCapitalization: TextCapitalization.words,
                              validator: (value) {
                                return FieldValidator.validateName(
                                    value.toString());
                              },
                              cursorColor: const Color(0xffFFB900),
                              controller: fullNameController,
                              keyboardType: TextInputType.name,
                              decoration: InputDecoration(
                                  prefixIcon: const Icon(
                                      Icons.supervised_user_circle,
                                      color: Color(0xffFFB900)),
                                  hintText: 'Enter FullName',
                                  hintStyle: const TextStyle(
                                      color: Color(0xffFFB900), fontSize: 18),
                                  labelText: 'FullName',
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
                                textInputAction: TextInputAction.next,
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
                            height: height * 0.03,
                          ),
                          ValueListenableBuilder(
                            valueListenable: confirmPasswordObscureText,
                            builder: (context, value, child) => FadeInUp(
                              delay: const Duration(milliseconds: 1600),
                              duration: const Duration(milliseconds: 1000),
                              child: TextFormField(
                                textInputAction: TextInputAction.done,
                                obscureText: confirmPasswordObscureText.value,
                                obscuringCharacter: '*',
                                validator: (value) {
                                  return FieldValidator.validatePasswordMatch(
                                      passwordController.text.toString(),
                                      value.toString());
                                },
                                cursorColor: const Color(0xffFFB900),
                                controller: confirmPasswordController,
                                keyboardType: TextInputType.visiblePassword,
                                decoration: InputDecoration(
                                    suffixIcon: InkWell(
                                        onTap: () {
                                          confirmPasswordObscureText.value =
                                              !confirmPasswordObscureText.value;
                                        },
                                        child: Icon(
                                            confirmPasswordObscureText.value
                                                ? Icons.visibility_off_outlined
                                                : Icons.visibility,
                                            color: const Color(0xffFFB900))),
                                    prefixIcon: const Icon(Icons.paste_sharp,
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
                            height: height * 0.05,
                          ),
                          FadeInUp(
                            delay: const Duration(milliseconds: 1800),
                            duration: const Duration(milliseconds: 1000),
                            child: InkWell(
                              onTap: () async {
                                if (key.currentState!.validate()) {
                                  ProgressDialog progressDialog =
                                      ProgressDialog(
                                    context,
                                    message: const Text(
                                      'Signing Up',
                                      style:
                                          TextStyle(color: Color(0xffFFB900)),
                                    ),
                                    title: const Text(
                                      'Please Wait...',
                                      style:
                                          TextStyle(color: Color(0xffFFB900)),
                                    ),
                                  );
                                  progressDialog.show();
                                  try {
                                    UserCredential userCredential =
                                        await fireAuth
                                            .createUserWithEmailAndPassword(
                                                email:
                                                    emailController.text.trim(),
                                                password: passwordController
                                                    .text
                                                    .trim());
                                    User? user = userCredential.user;
                                    if (user != null) {
                                      await firebaseFirestore
                                          .collection('user')
                                          .doc(user.uid)
                                          .set({
                                        'uid': user.uid,
                                        'name':
                                            fullNameController.text.toString(),
                                        'email': emailController.text.trim(),
                                        'dt': DateTime.now()
                                            .microsecondsSinceEpoch,
                                        'profileImage': '',
                                        'password':
                                            passwordController.text.toString(),
                                      });
                                      Fluttertoast.showToast(
                                          msg: 'Sign Up Successful');
                                      Navigator.of(context).pop();
                                      progressDialog.dismiss();
                                      Navigator.pushAndRemoveUntil(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const LoginScreen()),
                                          (route) => false);
                                    }
                                  } on FirebaseAuthException catch (e) {
                                    progressDialog.dismiss();
                                    if (e.code == 'weak-password') {
                                      Fluttertoast.showToast(
                                          msg: 'Weak Password');
                                    } else if (e.code ==
                                        'email-already-in-use') {
                                      Fluttertoast.showToast(
                                          msg: 'Email Allready In Used');
                                    }
                                  } catch (e) {
                                    progressDialog.dismiss();
                                  }
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
                                  'SignUp',
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
                                  'Already have an account?',
                                  style: TextStyle(
                                      color: Color(0xffFFB900), fontSize: 17),
                                ),
                                TextButton(
                                    onPressed: () {
                                      Navigator.pushAndRemoveUntil(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const LoginScreen()),
                                          (route) => false);
                                    },
                                    child: const Text(
                                      'SignIn',
                                      style: TextStyle(
                                          fontSize: 17, color: Colors.blue),
                                    ))
                              ],
                            ),
                          ),
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
