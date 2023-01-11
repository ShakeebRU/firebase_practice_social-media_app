import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:socialmediaapp/db/firestore_db.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({super.key});

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  TextEditingController _titleController = TextEditingController();
  TextEditingController _bodyController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: Icon(Icons.arrow_back_ios_new)),
          title: const Center(child: Text("Add Post")),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            children: [
              const SizedBox(
                height: 40,
              ),
              TextFormField(
                controller: _titleController,
                maxLines: 1,
                decoration: const InputDecoration(
                    hintText: "Enter Title",
                    label: Text("Title"),
                    border: OutlineInputBorder()),
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: _bodyController,
                maxLines: 6,
                decoration: const InputDecoration(
                  hintText: "Enter Body",
                  label: Text("Body"),
                  border: OutlineInputBorder(),
                ),
              ),
              TextButton(
                  onPressed: () {
                    Map<String, dynamic> data = {
                      "title": _titleController.text,
                      "body": _bodyController.text
                    };
                    FirestoreDB.addNewPost(data);
                    _titleController.clear();
                    _bodyController.clear();
                  },
                  style: const ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll(Colors.blue)),
                  child: const Text(
                    "Post",
                    style: TextStyle(color: Colors.white),
                  )),
            ],
          ),
        ));
  }
}
