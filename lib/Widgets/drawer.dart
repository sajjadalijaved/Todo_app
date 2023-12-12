import 'dart:developer';
import '../Models/drawer_model.dart';
import 'package:flutter/material.dart';
import '../Screens/profile_screen.dart';
import 'package:todo_app/Models/task_model.dart';
import '../Screens/AuthScreens/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:todo_app/Screens/home_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo_app/Screens/add_task_screen.dart';
import 'package:todo_app/Screens/update_task_screen.dart';

// ignore_for_file: unnecessary_null_comparison

// ignore_for_file: deprecated_member_use

class NavDrawer extends StatefulWidget {
  const NavDrawer({super.key});

  @override
  State<NavDrawer> createState() => _NavDrawerState();
}

class _NavDrawerState extends State<NavDrawer> {
  Model? model;
  User? user;

  late Stream<DocumentSnapshot<Map<String, dynamic>>> dataSnapshot;

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;

    try {
      dataSnapshot = FirebaseFirestore.instance
          .collection('user')
          .doc(user!.uid)
          .snapshots();

      dataSnapshot.listen((DocumentSnapshot<Map<String, dynamic>> snapshot) {
        if (snapshot.exists) {
          log("Fetching user detail: ${snapshot.data()!}");
          setState(() {
            model = Model.fromJson(snapshot.data()!);
          });
        }
      });
    } catch (error) {
      // Handle error if any
      log("Error fetching user detail: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: model == null
          ? const Center(
              child: CircularProgressIndicator(
              color: Colors.orange,
            ))
          : ListView(
              children: [
                UserAccountsDrawerHeader(
                  decoration: const BoxDecoration(
                    color: Color(0xffFFB900),
                  ),
                  accountName: Text(
                    model!.name.toString(),
                    style: const TextStyle(fontSize: 16),
                  ),
                  accountEmail: Text(model!.email.toString()),
                  currentAccountPicture: ClipOval(
                    child: model!.profileImage == ''
                        ? const Image(image: AssetImage("assets/12.png"))
                        : Image.network(
                            model!.profileImage,
                            fit: BoxFit.cover,
                          ),
                  ),
                ),
                ListTile(
                  leading: const Icon(
                    Icons.home,
                    size: 35,
                    color: Color(0xffFFB900),
                  ),
                  title: const Text(
                    'Home',
                    style: TextStyle(
                      fontSize: 18,
                      color: Color(0xffFFB900),
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const HomeScreen()));
                  },
                ),
                ListTile(
                  leading: const Icon(
                    Icons.add_task,
                    size: 35,
                    color: Color(0xffFFB900),
                  ),
                  title: const Text(
                    'Add Task',
                    style: TextStyle(
                      fontSize: 18,
                      color: Color(0xffFFB900),
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const AddTaskScreen()));
                  },
                ),
                ListTile(
                  leading: const Icon(
                    Icons.person_pin,
                    size: 35,
                    color: Color(0xffFFB900),
                  ),
                  title: const Text(
                    'Profile',
                    style: TextStyle(
                      fontSize: 18,
                      color: Color(0xffFFB900),
                    ),
                  ),
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const ProfileScreen()));
                  },
                ),
                ListTile(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => UpdateScreen(
                                taskModel: TaskModel(
                                    nodeId: "", taskName: "", dt: 45))));
                  },
                  leading: const Icon(
                    Icons.edit,
                    size: 35,
                    color: Color(0xffFFB900),
                  ),
                  title: const Text(
                    'Edit',
                    style: TextStyle(
                      fontSize: 18,
                      color: Color(0xffFFB900),
                    ),
                  ),
                ),
                const ListTile(
                  leading: Icon(
                    Icons.settings,
                    size: 35,
                    color: Color(0xffFFB900),
                  ),
                  title: Text(
                    'Settings',
                    style: TextStyle(
                      fontSize: 18,
                      color: Color(0xffFFB900),
                    ),
                  ),
                ),
                ListTile(
                  onTap: () async {
                    FirebaseAuth auth = FirebaseAuth.instance;
                    await auth.signOut().then((value) =>
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LoginScreen()),
                            (route) => false));
                  },
                  leading: const Icon(
                    Icons.logout,
                    size: 35,
                    color: Color(0xffFFB900),
                  ),
                  title: const Text(
                    'Logout',
                    style: TextStyle(
                      fontSize: 18,
                      color: Color(0xffFFB900),
                    ),
                  ),
                ),
                const Divider(
                  color: Color(0xffFFB900),
                  thickness: 1,
                ),
                const ListTile(
                    leading: Text(
                      'Rate App',
                      style: TextStyle(
                        fontSize: 18,
                        color: Color(0xffFFB900),
                      ),
                    ),
                    title: Row(
                      children: [
                        Icon(
                          Icons.star,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Icon(
                          Icons.star,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Icon(
                          Icons.star,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Icon(
                          Icons.star,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Icon(
                          Icons.star,
                        )
                      ],
                    )),
              ],
            ),
    );
  }
}
