import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:socialmediaapp/db/firestore_db.dart';
import 'package:socialmediaapp/models/post_model.dart';
import 'package:socialmediaapp/models/user_model.dart';
import 'package:socialmediaapp/screens/add_post_screen.dart';
import 'package:image_cropper/image_cropper.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  User? user = FirebaseAuth.instance.currentUser;

  late Future<List<PostModel>> postList;

  Future<List<PostModel>> getAllPostOfUser() async {
    List<PostModel> userPostsList = [];
    await FirestoreDB.postReference
        .where("uid", isEqualTo: user!.uid)
        .get()
        .then((QuerySnapshot snapshot) {
      for (var doc in snapshot.docs) {
        Map<String, dynamic> docdata = doc.data() as Map<String, dynamic>;
        userPostsList.add(PostModel.fromJson(docdata, doc.id));
      }
    }).catchError((error, stackTrace) {
      print(error);
    });

    return userPostsList;
  }

  @override
  void initState() {
    super.initState();
    postList = getAllPostOfUser();
  }

  CroppedFile? imageFile1;
  CroppedFile? imageFile2;
  pickUserProfileImage() async {
    try {
      final ImagePicker _picker = ImagePicker();
      // Pick an image
      final XFile? image = await _picker.pickImage(source: ImageSource.camera);
      if (image != null) {
        // imageFile2 = File(image.path);
        imageFile2 = await ImageCropper().cropImage(
          sourcePath: image.path,
          aspectRatioPresets: [
            CropAspectRatioPreset.square,
            CropAspectRatioPreset.ratio3x2,
            CropAspectRatioPreset.original,
            CropAspectRatioPreset.ratio4x3,
            CropAspectRatioPreset.ratio16x9
          ],
          uiSettings: [
            AndroidUiSettings(
                toolbarTitle: 'Profile Photo',
                toolbarColor: Colors.deepOrange,
                toolbarWidgetColor: Colors.white,
                initAspectRatio: CropAspectRatioPreset.square,
                lockAspectRatio: false),
            IOSUiSettings(
              title: 'Profile Photo',
            ),
            WebUiSettings(
              context: context,
            ),
          ],
        );
        setState(() {});
      }
    } catch (err) {
      print(err);
    }
  }

  pickUserCoverImage() async {
    try {
      final ImagePicker _picker = ImagePicker();
      // Pick an image
      final XFile? image = await _picker.pickImage(source: ImageSource.camera);
      if (image != null) {
        // imageFile1 = File(image.path);
        imageFile1 = await ImageCropper().cropImage(
          sourcePath: image.path,
          aspectRatioPresets: [
            CropAspectRatioPreset.square,
            CropAspectRatioPreset.ratio3x2,
            CropAspectRatioPreset.original,
            CropAspectRatioPreset.ratio4x3,
            CropAspectRatioPreset.ratio16x9
          ],
          uiSettings: [
            AndroidUiSettings(
                toolbarTitle: 'Cover Photo',
                toolbarColor: Colors.deepOrange,
                toolbarWidgetColor: Colors.white,
                initAspectRatio: CropAspectRatioPreset.ratio16x9,
                lockAspectRatio: false),
            IOSUiSettings(
              title: 'Cover Photo',
            ),
            WebUiSettings(
              context: context,
            ),
          ],
        );
        setState(() {});
      }
    } catch (err) {
      print(err);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          FutureBuilder<DocumentSnapshot>(
              future: FirestoreDB.userReference.doc(user!.uid).get(),
              builder: ((context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Row(
                    children: [
                      Center(
                        child: IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.replay_outlined,
                              size: 30,
                            )),
                      ),
                    ],
                  );
                }
                if (snapshot.hasData && !snapshot.data!.exists) {
                  return Row(
                    children: [
                      Center(
                        child: IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.replay_outlined,
                              size: 30,
                            )),
                      ),
                    ],
                  );
                }
                if (snapshot.connectionState == ConnectionState.done) {
                  print(snapshot.data);
                  UserModel details = UserModel.fromJson(
                      snapshot.data!.data() as Map<String, dynamic>);
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 40,
                      ),
                      Stack(alignment: Alignment.bottomCenter, children: [
                        GestureDetector(
                          onTap: () {
                            pickUserCoverImage();
                          },
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 30),
                            height: 200,
                            width: MediaQuery.of(context).size.width,
                            decoration: const BoxDecoration(
                              color: Colors.grey,
                            ),
                            child: imageFile1 != null
                                ? ClipRRect(
                                    child: Image.file(
                                    File(imageFile1!.path),
                                    fit: BoxFit.cover,
                                  ))
                                : const Icon(
                                    Icons.person,
                                    color: Colors.white,
                                    size: 80,
                                  ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            pickUserProfileImage();
                          },
                          child: Container(
                            height: 100,
                            width: 100,
                            decoration: const BoxDecoration(
                                color: Color.fromARGB(255, 41, 40, 40),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(50))),
                            child: details.profileImage != ""
                                ? ClipRRect(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(50)),
                                    child: Image.network(
                                      details.profileImage,
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                : const Icon(
                                    Icons.person,
                                    color: Colors.white,
                                    size: 80,
                                  ),
                          ),
                        ),
                      ]),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [const Text("Name :"), Text(details.name)],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [const Text("Email :"), Text(details.email)],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Gender :"),
                          Text(details.gender)
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [const Text("DOB :"), Text(details.dob)],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Address :"),
                          Text(details.address)
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Phone # :"),
                          Text(details.phone)
                        ],
                      ),
                    ],
                  );
                }
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    CircularProgressIndicator(),
                  ],
                );
              })),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) {
                  return AddPostScreen();
                }));
              },
              child: Text("Add New Post"),
            ),
          ),
          FutureBuilder<List<PostModel>>(
              future: postList,
              builder: ((context, AsyncSnapshot<List<PostModel>> snapshot) {
                if (snapshot.hasError) {
                  return Row(
                    children: [
                      Center(
                        child: IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.replay_outlined,
                              size: 30,
                            )),
                      ),
                    ],
                  );
                }

                if (snapshot.connectionState == ConnectionState.done) {
                  return ListView.builder(
                      physics: ScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(snapshot.data![index].title),
                          subtitle: Text(snapshot.data![index].body),
                        );
                      });
                }
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: const [
                    CircularProgressIndicator(),
                  ],
                );
              })),
        ],
      ),
    );
  }
}
