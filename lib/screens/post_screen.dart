import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:socialmediaapp/db/firestore_db.dart';
import 'package:socialmediaapp/models/comments_models.dart';
import '../models/post_model.dart';

class PostScreen extends StatefulWidget {
  final PostModel detail;

  const PostScreen({Key? key, required this.detail}) : super(key: key);

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  TextEditingController commentController = TextEditingController();
  Future<List<CommentsModel>> getAllCommentsofPost() async {
    List<CommentsModel> comentList = [];
    await FirestoreDB.commentsReference
        .where('postId', isEqualTo: widget.detail.id)
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        Map<String, dynamic> docData = doc.data() as Map<String, dynamic>;
        comentList.add(CommentsModel.fromJson(docData));
      }
    }).catchError((error, stackTrace) {
      print(error);
    });
    return comentList;
  }

  Future<bool> addCommentToPost() async {
    Map<String, dynamic> commentData = {
      "uid": FirebaseAuth.instance.currentUser!.uid,
      "postId": widget.detail.id,
      "text": commentController.text
    };
    bool status = false;
    FirestoreDB.commentsReference.add(commentData).then((value) {
      status = true;
    }).onError((error, stackTrace) {
      status = false;
      print(error);
    });
    return status;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        padding: EdgeInsets.all(25),
        children: [
          ListTile(
            title: Text("${widget.detail.title}"),
            subtitle: Text("${widget.detail.body}"),
          ),
          FutureBuilder<List<CommentsModel>>(
            future: getAllCommentsofPost(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const Center(
                  child: Text("Error"),
                );
              }
              if (snapshot.hasData) {
                return snapshot.data!.isEmpty
                    ? const Center(
                        child: Text("No Comments yet...!"),
                      )
                    : ListView.builder(
                        physics: ScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          CommentsModel comentsOnPost = snapshot.data![index];
                          return ListTile(
                            title: Text(
                              comentsOnPost.text,
                              style: const TextStyle(color: Colors.black),
                            ),
                          );
                        });
              }
              return const Center(
                child: CircularProgressIndicator(),
              );
            },
          ),
          TextFormField(
            controller: commentController,
            decoration: const InputDecoration(hintText: "type comment"),
          ),
          TextButton(
              onPressed: () async {
                bool status = await addCommentToPost();
                setState(() {});
                print("status: $status");
                if (status) {
                  print("posted");
                } else {
                  print("error");
                }
                commentController.clear();
              },
              child: const Text("Add comment"))
        ],
      ),
    );
  }
}
