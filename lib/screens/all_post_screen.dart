import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:socialmediaapp/db/firestore_db.dart';
import 'package:socialmediaapp/screens/post_screen.dart';
import 'package:socialmediaapp/screens/profile_screen.dart';

import '../models/post_model.dart';

class AllPostScreen extends StatefulWidget {
  const AllPostScreen({super.key});

  @override
  State<AllPostScreen> createState() => _AllPostScreenState();
}

class _AllPostScreenState extends State<AllPostScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Icon(
                Icons.person,
                size: 90,
              ),
            ),
            ListTile(
              title: const Text('Profile'),
              onTap: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) {
                  return ProfileScreen();
                }));
              },
            ),
            ListTile(
              title: const Text('Logout'),
              onTap: () {},
            ),
          ],
        ),
      ),
      body: FutureBuilder(
          future: FirestoreDB.postReference.get(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasError) {
              return const Center(
                child: Text("Something went wrong"),
              );
            }
            if (snapshot.hasData) {
              if (snapshot.data != null) {
                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    Map<String, dynamic> doc = snapshot.data!.docs[index].data()
                        as Map<String, dynamic>;
                    String docId = snapshot.data!.docs[index].id;
                    PostModel detail = PostModel.fromJson(doc, docId);
                    return ListTile(
                      title: Text(detail.title),
                      subtitle: Text(detail.body),
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => PostScreen(detail: detail)));
                      },
                    );
                  },
                );
              } else {
                return const Center(
                  child: Text("Nothing to show"),
                );
              }
            }
            return const Center(
              child: Text("Loading...."),
            );
          }),
    );
  }
}
