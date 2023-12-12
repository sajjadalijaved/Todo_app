import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:todo_app/Models/task_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// ignore_for_file: deprecated_member_use, use_build_context_synchronously

class UpdateScreen extends StatefulWidget {
  final TaskModel taskModel;
  const UpdateScreen({super.key, required this.taskModel});

  @override
  State<UpdateScreen> createState() => _UpdateScreenState();
}

class _UpdateScreenState extends State<UpdateScreen> {
  var taskNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    taskNameController.text = widget.taskModel.taskName;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Update Task'),
        backgroundColor: const Color(0xffFFB900),
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 50,
          ),
          FadeInUp(
            duration: const Duration(milliseconds: 1500),
            child: Padding(
              padding: const EdgeInsets.all(30),
              child: TextField(
                controller: taskNameController,
                textCapitalization: TextCapitalization.words,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                    prefixIcon: const Icon(
                      Icons.update,
                      color: Colors.grey,
                    ),
                    labelText: 'Enter Task Name',
                    labelStyle: const TextStyle(color: Colors.grey),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide:
                          const BorderSide(width: 2, color: Color(0xffFFB900)),
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                            width: 2, color: Color(0xffFFB900)))),
              ),
            ),
          ),
          FadeInUp(
            duration: const Duration(milliseconds: 1000),
            delay: const Duration(milliseconds: 1000),
            child: SizedBox(
              width: 200,
              height: 45,
              child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: const Color(0xffFFB900),
                  ),
                  onPressed: () async {
                    var taskName = taskNameController.text;
                    if (taskName.isEmpty) {
                      Fluttertoast.showToast(msg: 'Please Enter Task Name');
                      return;
                    }
                    User? user = FirebaseAuth.instance.currentUser;
                    FirebaseFirestore databaseRef = FirebaseFirestore.instance;
                    if (user != null) {
                      try {
                        await databaseRef
                            .collection('task')
                            .doc(user.uid)
                            .collection("tasks")
                            .doc(widget.taskModel.nodeId)
                            .update({'taskName': taskName});
                        Fluttertoast.showToast(msg: 'Task Updated');
                      } catch (e) {
                        Fluttertoast.showToast(msg: 'Something went wrong');
                      }
                    }
                  },
                  child: const Text(
                    'Update Task',
                    style: TextStyle(fontSize: 20),
                  )),
            ),
          )
        ],
      ),
    );
  }
}
