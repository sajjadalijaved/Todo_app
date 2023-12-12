import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import '../Utils/Validation/validation.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  late TextEditingController addTask;
  GlobalKey<FormState> key = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    addTask = TextEditingController();
  }

  @override
  void dispose() {
    addTask.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.arrow_back)),
        centerTitle: true,
        title: const Text('Add Task'),
        backgroundColor: const Color(0xffFFB900),
      ),
      body: Form(
        key: key,
        child: Column(
          children: [
            const SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.all(30),
              child: FadeInUp(
                duration: const Duration(milliseconds: 1500),
                child: TextFormField(
                  cursorColor: const Color(0xffFFB900),
                  controller: addTask,
                  textCapitalization: TextCapitalization.words,
                  keyboardType: TextInputType.text,
                  validator: (value) {
                    return FieldValidator.addTaskName(value.toString());
                  },
                  decoration: InputDecoration(
                      prefixIcon: const Icon(
                        Icons.add_task,
                        color: Colors.grey,
                      ),
                      labelText: 'Enter Task Name',
                      labelStyle: const TextStyle(color: Colors.grey),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                            width: 2, color: Color(0xffFFB900)),
                      ),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:
                              const BorderSide(color: Color(0xffFFB900))),
                      errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: Colors.red)),
                      disabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:
                              const BorderSide(color: Color(0xffFFB900))),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                              width: 2, color: Color(0xffFFB900)))),
                ),
              ),
            ),
            FadeInUp(
              duration: const Duration(milliseconds: 1000),
              delay: const Duration(milliseconds: 1300),
              child: SizedBox(
                width: 150,
                height: 40,
                child: OutlinedButton(
                    onPressed: () async {
                      if (key.currentState!.validate()) {
                        String addTaskName = addTask.text.toString();
                        addTask.clear();
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
                            'taskName': addTaskName,
                            'dt': DateTime.now()
                                .microsecondsSinceEpoch
                                .toString(),
                          });
                          Fluttertoast.showToast(
                              msg: 'Task Added Successfully!');
                        } catch (e) {
                          Fluttertoast.showToast(msg: 'Something went wrong');
                        }
                      }
                    },
                    child: const Text(
                      'Save Task',
                      style: TextStyle(fontSize: 20, color: Color(0xffFFB900)),
                    )),
              ),
            )
          ],
        ),
      ),
    );
  }
}
