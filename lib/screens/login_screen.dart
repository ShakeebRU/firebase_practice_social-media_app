import 'package:flutter/material.dart';
import 'package:socialmediaapp/auth/firebase_auth.dart';
import 'package:socialmediaapp/screens/all_post_screen.dart';
import 'package:socialmediaapp/screens/signup_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Column(
                children: [
                  const SizedBox(
                    height: 150,
                  ),
                  const ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(50)),
                    child: Icon(
                      Icons.login,
                      size: 50,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: emailController,
                    maxLines: 1,
                    decoration: const InputDecoration(
                        hintText: "Enter Email",
                        label: Text(
                          "Email",
                          style: TextStyle(fontSize: 22),
                        ),
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
                  TextFormField(
                    controller: passwordController,
                    maxLines: 1,
                    decoration: const InputDecoration(
                        hintText: "Enter Password",
                        label: Text(
                          "Password",
                          style: TextStyle(fontSize: 22),
                        ),
                        border: OutlineInputBorder(
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
                  TextButton(
                      style: const ButtonStyle(
                          backgroundColor:
                              MaterialStatePropertyAll(Colors.blue),
                          minimumSize: MaterialStatePropertyAll(Size(120, 60))),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Data Send')),
                          );
                          try {
                            Auth.loginUser(
                                email: emailController.text,
                                password: passwordController.text);
                            Navigator.of(context)
                                .push(MaterialPageRoute(builder: (context) {
                              return const AllPostScreen();
                            }));
                          } catch (err) {
                            print(err);
                          }
                        }
                      },
                      child: const Text(
                        "Login",
                        style: TextStyle(fontSize: 22, color: Colors.white),
                      )),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        Navigator.of(context)
                            .push(MaterialPageRoute(builder: (context) {
                          return const SignupScreen();
                        }));
                      },
                      child:
                          const Text("Not have an Account yet? Register Here"),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
