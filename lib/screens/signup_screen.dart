import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:socialmediaapp/auth/firebase_auth.dart';
import 'package:socialmediaapp/models/user_model.dart';
import 'package:image_picker/image_picker.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController rePasswordController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController websiteController = TextEditingController();
  TextEditingController companyController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  bool showPassword = false;
  static const List<String> choices = <String>["Male", "Female", "Others"];
  var date;
  static const List<String> gender = <String>[
    'Male',
    'Female',
    'Others',
  ];
  String dropdownValue = gender.first;
  final _formKey = GlobalKey<FormState>();

  void datePicker() async {
    date = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1900),
        lastDate: DateTime.now());

    if (date != null) {
      dateController.text = date.toString();
      dateController.text = dateController.text.substring(0, 10);
    }
    setState(() {});
  }

  String? imageUrl;
  File? imageFile;
  pickUserProfileImage() async {
    try {
      final ImagePicker _picker = ImagePicker();
      // Pick an image
      final XFile? image = await _picker.pickImage(source: ImageSource.camera);
      if (image != null) {
        imageFile = File(image.path);
        print("image.path: ${image.path}");
        setState(() {});
      }
    } catch (err) {
      print(err);
    }
  }

  uploadImageToFirebaseStorage() async {
    try {
      String uniqueName = DateTime.now().microsecondsSinceEpoch.toString();
      firebase_storage.UploadTask? uploadTask;
      firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
          .ref()
          .child("images")
          .child('/' + uniqueName);
      uploadTask = ref.putFile(File(imageFile!.path));
      await uploadTask.whenComplete(() => print("Error"));

      imageUrl = await ref.getDownloadURL();
      setState(() {});
      print("image Url is" + imageUrl!);
      Auth.signupUser(
          data: UserModel(
              name: nameController.text,
              password: passwordController.text,
              email: emailController.text,
              address: addressController.text,
              phone: phoneController.text,
              dob: dateController.text,
              gender: dropdownValue,
              profileImage: imageUrl!));
    } catch (err) {
      print("error is big" + err.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Column(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  Stack(alignment: Alignment.bottomRight, children: [
                    Container(
                      height: 100,
                      width: 100,
                      decoration: const BoxDecoration(
                          color: Color.fromARGB(255, 41, 40, 40),
                          borderRadius: BorderRadius.all(Radius.circular(50))),
                      child: imageFile != null
                          ? ClipRRect(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(50)),
                              child: Image.file(
                                imageFile!,
                                fit: BoxFit.cover,
                              ),
                            )
                          : const Icon(
                              Icons.person,
                              color: Colors.white,
                              size: 80,
                            ),
                    ),
                    InkWell(
                      onTap: () {
                        pickUserProfileImage();
                      },
                      child: Container(
                        height: 27,
                        width: 27,
                        decoration: const BoxDecoration(
                            color: Colors.blue,
                            borderRadius:
                                BorderRadius.all(Radius.circular(50))),
                        child: const Icon(
                          Icons.add,
                          color: Colors.white,
                          size: 27,
                        ),
                      ),
                    )
                  ]),
                  const SizedBox(
                    height: 20,
                  ),
                  const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Name:",
                        style: TextStyle(fontSize: 17),
                      )),
                  TextFormField(
                    controller: nameController,
                    maxLines: 1,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(50)))),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter Name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Email:",
                        style: TextStyle(fontSize: 17),
                      )),
                  TextFormField(
                    controller: emailController,
                    maxLines: 1,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(50)))),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter Email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Password:",
                        style: TextStyle(fontSize: 17),
                      )),
                  TextFormField(
                    obscureText: showPassword,
                    controller: passwordController,
                    maxLines: 1,
                    decoration: InputDecoration(
                        suffix: InkWell(
                          onTap: () {
                            showPassword = !showPassword;
                            setState(() {});
                          },
                          child: Icon(
                            showPassword
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Colors.grey,
                          ),
                        ),
                        border: const OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(50)))),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter Password';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Re-Type Password:",
                        style: TextStyle(fontSize: 17),
                      )),
                  TextFormField(
                    obscureText: showPassword,
                    controller: rePasswordController,
                    maxLines: 1,
                    decoration: InputDecoration(
                        suffix: InkWell(
                          onTap: () {
                            showPassword = !showPassword;
                            setState(() {});
                          },
                          child: Icon(
                            showPassword
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Colors.grey,
                          ),
                        ),
                        border: const OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(50)))),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter Password';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Phone Number:",
                        style: TextStyle(fontSize: 17),
                      )),
                  TextFormField(
                    controller: phoneController,
                    maxLines: 1,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(50)))),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter Phone Number';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Date of Birth:",
                        style: TextStyle(fontSize: 17),
                      )),
                  TextFormField(
                    controller: dateController,
                    decoration: const InputDecoration(
                        suffixIcon: Icon(Icons.calendar_month),
                        hintText: "YYYY/MM/DD",
                        hintStyle: TextStyle(fontSize: 20),
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(50)))),
                    onTap: () {
                      datePicker();
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Gender:",
                            style: TextStyle(fontSize: 17),
                          )),
                      DropdownButton<String>(
                        value: dropdownValue,
                        icon: const Icon(
                          Icons.arrow_drop_down,
                          size: 35,
                        ),
                        elevation: 16,
                        style: const TextStyle(
                            color: Color.fromARGB(255, 53, 52, 52),
                            fontSize: 25),
                        underline: Container(
                          height: 1,
                          color: Colors.black,
                        ),
                        onChanged: (String? value) {
                          // This is called when the user selects an item.
                          setState(() {
                            dropdownValue = value!;
                          });
                        },
                        items: gender
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Address:",
                        style: TextStyle(fontSize: 17),
                      )),
                  TextFormField(
                    controller: addressController,
                    maxLines: 4,
                    decoration:
                        const InputDecoration(border: OutlineInputBorder()),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter Address';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text("Already have account? Sign In")),
                  const SizedBox(
                    height: 10,
                  ),
                  TextButton(
                      style: const ButtonStyle(
                          backgroundColor:
                              MaterialStatePropertyAll(Colors.blue),
                          minimumSize: MaterialStatePropertyAll(Size(80, 60))),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          uploadImageToFirebaseStorage();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Done......!")),
                          );
                        }
                      },
                      child: const Text(
                        "Sign up",
                        style: TextStyle(fontSize: 22, color: Colors.white),
                      ))
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
