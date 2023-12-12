import 'package:intl/intl.dart';
import 'update_task_screen.dart';
import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:todo_app/Widgets/drawer.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:todo_app/Models/task_model.dart';
import 'package:todo_app/Models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo_app/Screens/profile_screen.dart';
import 'package:todo_app/Screens/AuthScreens/login_screen.dart';

// ignore_for_file: use_build_context_synchronously

// ignore_for_file: non_constant_identifier_names, must_be_immutable

// ignore_for_file: unnecessary_null_comparison

// ignore_for_file: deprecated_member_use, prefer_null_aware_operators

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  User? user;
  UserModel? userModel;
  late TextEditingController taskName;
  Stream<QuerySnapshot> getTasksStream() {
    if (user == null) {
      return const Stream.empty();
    }

    return FirebaseFirestore.instance
        .collection('task')
        .doc(user!.uid)
        .collection("tasks")
        .snapshots();
  }

  Future<void> deleteTask(String nodeId) async {
    try {
      await FirebaseFirestore.instance
          .collection('task')
          .doc(user!.uid)
          .collection("tasks")
          .doc(nodeId)
          .delete();

      Fluttertoast.showToast(msg: 'Task Deleted');
    } catch (e) {
      Fluttertoast.showToast(msg: 'Failed to delete task');
    }
  }

  // getAllTasks() async {
  //   if (user == null) {
  //     return;
  //   }
  //   CollectionReference taskCollection = FirebaseFirestore.instance
  //       .collection('task')
  //       .doc(user!.uid)
  //       .collection("tasks");

  //   try {
  //     QuerySnapshot querySnapshot = await taskCollection.get();

  //     for (QueryDocumentSnapshot documentSnapshot in querySnapshot.docs) {
  //       Map<String, dynamic> data =
  //           documentSnapshot.data() as Map<String, dynamic>;

  //       String nodeId = data['nodeId'];
  //       String taskName = data['taskName'];
  //       String dt = data['dt'];

  //       log('Node ID: $nodeId, Task Name: $taskName, Date Time: $dt');
  //     }
  //   } catch (e) {
  //     log('Error getting documents: $e');
  //   }
  // }

  @override
  void initState() {
    super.initState();
    taskName = TextEditingController();
    user = FirebaseAuth.instance.currentUser;
    getTasksStream();
  }

  @override
  void dispose() {
    taskName.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Task List"),
          backgroundColor: const Color(0xffFFB900),
          actions: [
            InkWell(
              onTap: () {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const ProfileScreen()),
                    (route) => false);
              },
              child: const Icon(
                Icons.person_pin,
                size: 35,
              ),
            ),
            const SizedBox(
              width: 15,
            ),
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: InkWell(
                onTap: () async {
                  FirebaseAuth auth = FirebaseAuth.instance;
                  await auth.signOut().then((value) =>
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LoginScreen()),
                          (route) => false));
                },
                child: const Icon(
                  Icons.logout,
                  size: 33,
                ),
              ),
            )
          ],
          leading: Builder(
            builder: (context) => InkWell(
              onTap: () => Scaffold.of(context).openDrawer(),
              child: const Icon(
                Icons.menu,
                size: 35,
              ),
            ),
          ),
        ),
        drawer: const NavDrawer(),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: StreamBuilder(
                stream: getTasksStream(),
                builder: (context, snapShots) {
                  if (snapShots.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: Colors.orange,
                      ),
                    );
                  }
                  if (!snapShots.hasData || snapShots.data!.docs.isEmpty) {
                    return const Center(
                      child: Text('No Task Yet '),
                    );
                  }

                  if (snapShots.hasData && !snapShots.hasError) {
                    return ListView.builder(
                        itemCount: snapShots.data!.docs.length,
                        itemBuilder: (context, index) {
                          var document = snapShots.data!.docs[index];
                          var taskName = document['taskName'];
                          var dt = document['dt'];
                          var nodeId = document['nodeId'];
                          return Padding(
                            padding: const EdgeInsets.fromLTRB(8, 15, 8, 0),
                            child: FadeInUp(
                              duration: const Duration(milliseconds: 1000),
                              delay: const Duration(milliseconds: 1000),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      offset: const Offset(0, 1),
                                      spreadRadius: 1,
                                      blurRadius: 5,
                                      color: Colors.grey.withOpacity(0.4),
                                    ),
                                  ],
                                  border: const Border(
                                      left: BorderSide(
                                          width: 2, color: Color(0xffFFB900))),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                      flex: 3,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          MyRow(
                                              Task: taskName,
                                              Date: int.parse(dt))
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          IconButton(
                                              onPressed: () {
                                                if (user != null) {
                                                  showDialog(
                                                      barrierDismissible: false,
                                                      context: context,
                                                      builder: (context) {
                                                        return AlertDialog(
                                                          title: const Text(
                                                              "Confirmation"),
                                                          content: const Text(
                                                              'Are You Sure To Delete'),
                                                          actions: [
                                                            TextButton(
                                                                onPressed: () {
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop();
                                                                },
                                                                child:
                                                                    const Text(
                                                                        'No')),
                                                            TextButton(
                                                                onPressed:
                                                                    () async {
                                                                  try {
                                                                    await deleteTask(
                                                                        nodeId);
                                                                    Navigator.of(
                                                                            context)
                                                                        .pop();
                                                                  } catch (e) {
                                                                    Fluttertoast
                                                                        .showToast(
                                                                            msg:
                                                                                'Failes');
                                                                  }
                                                                },
                                                                child:
                                                                    const Text(
                                                                        'Yes'))
                                                          ],
                                                        );
                                                      });
                                                }
                                              },
                                              icon: const Icon(Icons.delete)),
                                          IconButton(
                                              onPressed: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (ctx) {
                                                    return UpdateScreen(
                                                        taskModel: TaskModel(
                                                            nodeId: nodeId,
                                                            taskName: taskName,
                                                            dt: int.parse(dt)));
                                                  }),
                                                );
                                              },
                                              icon: const Icon(Icons.edit)),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                        });
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: Colors.orange,
                      ),
                    );
                  }
                },
              ),
            ),
            FadeInDown(
              duration: const Duration(milliseconds: 1000),
              delay: const Duration(milliseconds: 1000),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                child: TextField(
                  controller: taskName,
                  textCapitalization: TextCapitalization.words,
                  cursorColor: const Color(0xffFFB900),
                  decoration: InputDecoration(
                      labelText: 'Enter Task',
                      labelStyle: const TextStyle(color: Colors.grey),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                            width: 2, color: Color(0xffFFB900)),
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                              width: 2, color: Color(0xffFFB900))),
                      suffixIcon: IconButton(
                          onPressed: () async {
                            var name = taskName.text;
                            taskName.text = '';
                            if (name.isEmpty) {
                              Fluttertoast.showToast(
                                  msg: 'Plz Enter Task Name');
                              return;
                            }
                            User? user = FirebaseAuth.instance.currentUser;
                            FirebaseFirestore databaseRef =
                                FirebaseFirestore.instance;
                            if (user == null) {
                              return;
                            }
                            var key = databaseRef.collection('task').doc().id;
                            try {
                              await databaseRef
                                  .collection('task')
                                  .doc(user.uid)
                                  .collection("tasks")
                                  .doc(key)
                                  .set({
                                'nodeId': key,
                                'taskName': name,
                                'dt': DateTime.now()
                                    .microsecondsSinceEpoch
                                    .toString(),
                              });
                              Fluttertoast.showToast(msg: 'Task Added');
                            } catch (e) {
                              Fluttertoast.showToast(
                                  msg: 'Something went wrong');
                            }
                          },
                          icon: const Icon(
                            Icons.send,
                            color: Color(0xffFFB900),
                            size: 30,
                          ))),
                ),
              ),
            )
          ],
        ));
  }
}

String HumanReadable(int dt) {
  DateTime dateTime = DateTime.fromMicrosecondsSinceEpoch(dt);
  return DateFormat('dd/MM/yyyy').format(dateTime);
}

class MyRow extends StatelessWidget {
  String Task;
  int Date;
  MyRow({super.key, required this.Task, required this.Date});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Task : $Task',
          style: const TextStyle(fontSize: 18),
        ),
        const SizedBox(
          height: 10,
        ),
        Text(
          'Date : ${HumanReadable(Date)}',
          style: const TextStyle(fontSize: 16),
        ),
      ],
    );
  }
}
