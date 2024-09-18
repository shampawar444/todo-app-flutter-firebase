import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

class AddTodo extends StatefulWidget {
  const AddTodo({super.key});

  @override
  State<AddTodo> createState() => _AddTodoState();
}

class _AddTodoState extends State<AddTodo> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionContrller = TextEditingController();

  addTasksToDatabase() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final user = auth.currentUser;
    final uid = user!.uid;
    var time = DateTime.now();

    await FirebaseFirestore.instance
        .collection('tasks')
        .doc(uid)
        .collection('userTasks')
        .doc(time.toString())
        .set({
      'title': _titleController.text,
      'description': _descriptionContrller.text,
      'time': time.toString(),
    });

    Fluttertoast.showToast(msg: 'Task Added Successfully');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Todo'),
        centerTitle: true,
        backgroundColor: Colors.grey[600],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(children: [
          const SizedBox(
            height: 40,
          ),
          Text(
            "Add task you want to do",
            style:
                GoogleFonts.roboto(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 40,
          ),
          TextFormField(
            controller: _titleController,
            decoration: InputDecoration(
                labelText: "Title",
                labelStyle: GoogleFonts.roboto(),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10))),
          ),
          const SizedBox(
            height: 10,
          ),
          TextFormField(
            controller: _descriptionContrller,
            decoration: InputDecoration(
                labelText: "Description",
                labelStyle: GoogleFonts.roboto(),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10))),
          ),
          const SizedBox(
            height: 20,
          ),
          SizedBox(
            height: 50,
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                addTasksToDatabase();
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green.shade300,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                'Add Todo',
                style: GoogleFonts.roboto(color: Colors.white, fontSize: 18),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
