import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:socialmediaapp/models/user_model.dart';
import '../db/firestore_db.dart';

class Auth {
  static CollectionReference userReference =
      FirebaseFirestore.instance.collection("user");

  static Future<bool> signupUser({required UserModel data}) async {
    bool status = false;
    try {
      final credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: data.email, password: data.password);
      User? currentUser = credential.user;
      if (currentUser != null) {
        // print("posted url" + data.profileImage);
        Map<String, dynamic> userProfileData = {
          "name": data.name,
          "phone": data.phone,
          "email": data.email,
          "password": data.password,
          "gender": data.gender,
          "address": data.address,
          "dob": data.dob,
          "uid": currentUser.uid,
          "profileimage": data.profileImage
        };
        FirestoreDB.addUserProfile(data: userProfileData, uid: currentUser.uid);
      }
      status = true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
    return status;
  }

  static Future<bool> loginUser({
    required String email,
    required String password,
  }) async {
    bool status = false;
    try {
      final credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      User? currentUser = credential.user;
      status = true;
    } on FirebaseAuthException catch (e) {
    } catch (e) {
      print(e);
    }
    return status;
  }
}
