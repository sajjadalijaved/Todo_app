import 'dart:io';
import 'dart:developer';
import 'package:intl/intl.dart';
import '../models/user_model.dart';
import 'package:ndialog/ndialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'AuthScreens/login_screen.dart';
import 'package:animate_do/animate_do.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:todo_app/Screens/home_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo_app/Screens/add_task_screen.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:flutter_image_compress/flutter_image_compress.dart';

// ignore_for_file: unused_local_variable

// ignore_for_file: use_build_context_synchronously

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  File? newImage;

  XFile? image;
  bool localImage = false;
  UserModel? userModel;

  User? user;
  late Stream<DocumentSnapshot<Map<String, dynamic>>> dataSnapshot;
  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        dataSnapshot = FirebaseFirestore.instance
            .collection('user')
            .doc(user!.uid)
            .snapshots();

        dataSnapshot.listen((DocumentSnapshot<Map<String, dynamic>> snapshot) {
          if (snapshot.exists) {
            log("Fetching user detail: ${snapshot.data()}");
            setState(() {
              userModel = UserModel.fromJson(snapshot.data()!);
            });
          }
        });
      } catch (error) {
        // Handle error if any
        log("Error fetching user detail: $error");
      }
    }
  }

  Future pickImageGallery() async {
    image = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (image == null) return;

    final dir = await path_provider.getTemporaryDirectory();
    final targetPath = '${dir.absolute.path}/temp.jpg';
    final result = await FlutterImageCompress.compressAndGetFile(
      image!.path,
      targetPath,
      minHeight: 1080,
      minWidth: 1080,
      quality: 90,
    );
    final data = await result!.readAsBytes();
    final newKb = data.length / 1024;
    final newMb = newKb / 1024;
    newImage = File(result.path);

    localImage = true;
    setState(() {});

    ProgressDialog progressDialog = ProgressDialog(
      context,
      title: const Text('Uploading !!!'),
      message: const Text('Please wait'),
    );
    progressDialog.show();

    var fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
    UploadTask uploadTask =
        FirebaseStorage.instance.ref().child(fileName).putFile(newImage!);

    TaskSnapshot snapshot = await uploadTask;
    String imageUrl = await snapshot.ref.getDownloadURL();
    log("ImageUrl:$imageUrl");

    // update user in realtime database

    if (user != null) {
      FirebaseFirestore.instance.collection('user').doc(user!.uid).update(
        {
          'profileImage': imageUrl,
        },
      );
    }

    progressDialog.dismiss();
  }

  Future pickImageCamera() async {
    image = await ImagePicker().pickImage(
      source: ImageSource.camera,
    );
    if (image == null) return;

    final dir = await path_provider.getTemporaryDirectory();
    final targetPath = '${dir.absolute.path}/temp.jpg';
    final result = await FlutterImageCompress.compressAndGetFile(
      image!.path,
      targetPath,
      minHeight: 1080,
      minWidth: 1080,
      quality: 90,
    );

    newImage = File(result!.path);

    localImage = true;
    setState(() {});

    ProgressDialog progressDialog = ProgressDialog(
      context,
      title: const Text('Uploading !!!'),
      message: const Text('Please wait'),
    );
    progressDialog.show();

    var fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
    UploadTask uploadTask =
        FirebaseStorage.instance.ref().child(fileName).putFile(newImage!);

    TaskSnapshot snapshot = await uploadTask;
    String imageUrl = await snapshot.ref.getDownloadURL();
    log("ImageUrl:$imageUrl");

    if (user != null) {
      FirebaseFirestore.instance.collection('user').doc(user!.uid).update(
        {
          'profileImage': imageUrl,
        },
      );
    }

    progressDialog.dismiss();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffFFB900),
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const HomeScreen()),
                  (route) => false);
            },
            icon: const Icon(Icons.arrow_back)),
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarBrightness: Brightness.dark,
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: IconButton(
              onPressed: () {
                showModalBottomSheet(
                    context: context,
                    builder: (context) {
                      return Padding(
                        padding: const EdgeInsets.all(8),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ListTile(
                              leading: const Icon(Icons.image),
                              title: const Text('Gallery'),
                              onTap: () {
                                pickImageGallery();
                                Navigator.of(context).pop();
                              },
                            ),
                            ListTile(
                              leading: const Icon(Icons.camera_alt),
                              title: const Text('Camera'),
                              onTap: () {
                                pickImageCamera();
                                Navigator.of(context).pop();
                              },
                            )
                          ],
                        ),
                      );
                    });
              },
              icon: const Icon(
                Icons.camera_alt,
                size: 35,
              ),
            ),
          )
        ],
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: userModel == null
          ? const Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            )
          : Stack(
              alignment: Alignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 100),
                  child: Container(
                    height: double.infinity,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30)),
                    ),
                  ),
                ),
                Positioned(
                  top: 20,
                  child: FadeInUp(
                    duration: const Duration(milliseconds: 1500),
                    child: Container(
                      height: 160,
                      width: 160,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                          border: Border.all(
                            width: 3,
                            color: Colors.white,
                          ),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 10,
                                offset: const Offset(0, 5))
                          ]),
                      child: ClipOval(
                        child: localImage == true
                            ? Image.file(
                                newImage!,
                                height: 125,
                                width: 125,
                                fit: BoxFit.cover,
                              )
                            : Image.network(
                                userModel!.profileImage == ''
                                    ? 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSnme6H9VJy3qLGvuHRIX8IK4jRpjo_xUWlTw&usqp=CAU'
                                    : userModel!.profileImage.toString(),
                                height: 125,
                                width: 125,
                                fit: BoxFit.cover,
                              ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 200),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      FadeInUp(
                        duration: const Duration(milliseconds: 1000),
                        delay: const Duration(milliseconds: 1000),
                        child: Text(
                          userModel!.name.toString(),
                          style: const TextStyle(
                              fontSize: 25, color: Colors.black87),
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      FadeInUp(
                        duration: const Duration(milliseconds: 1000),
                        delay: const Duration(milliseconds: 1200),
                        child: Text(
                          userModel!.email.toString(),
                          style: const TextStyle(color: Colors.black54),
                        ),
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 250, 20, 10),
                  child: FadeInUp(
                    duration: const Duration(milliseconds: 1000),
                    delay: const Duration(milliseconds: 1400),
                    child: Container(
                        width: double.infinity,
                        height: MediaQuery.of(context).size.height * 0.45,
                        decoration: const BoxDecoration(
                            border: Border(
                                bottom: BorderSide(
                          width: 2,
                          color: Color(0xffFFB900),
                        ))),
                        child: FadeInLeft(
                          duration: const Duration(milliseconds: 1000),
                          delay: const Duration(milliseconds: 1600),
                          child: GridView(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3),
                            children: [
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const HomeScreen()),
                                  );
                                },
                                child: const Icon(
                                  Icons.home,
                                  size: 40,
                                  color: Color(0xffFFB900),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const AddTaskScreen()),
                                  );
                                },
                                child: const Icon(
                                  Icons.task,
                                  size: 40,
                                  color: Color(0xffFFB900),
                                ),
                              ),
                              InkWell(
                                onTap: () async {
                                  FirebaseAuth auth = FirebaseAuth.instance;
                                  await auth
                                      .signOut()
                                      .then((value) => Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const LoginScreen()),
                                          ));
                                },
                                child: const Icon(
                                  Icons.logout,
                                  size: 40,
                                  color: Color(0xffFFB900),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const AddTaskScreen()),
                                  );
                                },
                                child: const Icon(
                                  Icons.add_task,
                                  size: 40,
                                  color: Color(0xffFFB900),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const HomeScreen()),
                                  );
                                },
                                child: const Icon(
                                  Icons.delete,
                                  size: 40,
                                  color: Color(0xffFFB900),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const HomeScreen()),
                                  );
                                },
                                child: const Icon(
                                  Icons.edit,
                                  size: 40,
                                  color: Color(0xffFFB900),
                                ),
                              ),
                            ],
                          ),
                        )),
                  ),
                )
              ],
            ),
    );
  }

  String getHumanReadableDate(int dt) {
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(dt);
    return DateFormat('dd-MMM-yyyy').format(dateTime);
  }
}
