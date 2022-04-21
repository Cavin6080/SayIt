import 'dart:developer';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sayit/resources/storage_methods.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance; //for adding users all data in database

  //function to sign up the user
  Future<String> signUpUser({
    required String email,
    required String password,
    required String username,
    required String bio,
    required Uint8List file,
  }) async {
    String result = 'Some error occurred';
    try {
      if (email.isNotEmpty ||
          password.isNotEmpty ||
          username.isNotEmpty ||
          bio.isNotEmpty) {
        //register the user
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);

        //uploading prfile pic to storage,function is from storage methods file
        String photoUrl = await StorageMethods()
            .uploadImageToStorage('profilePics', file, false);

        //Add user to firestore database
        await _firestore.collection('users').doc(cred.user!.uid).set({
          'username': username,
          'uid': cred.user!.uid,
          'email': email,
          'bio': bio,
          'followers': [],
          'following': [],
          'photoUrl': photoUrl, //profile pic upload from storage methods
        });
        result = 'success';
        print(result);
      }
    } on FirebaseAuthException catch (e) {
      result = e.toString();
      print(result);
    }
    return result;
  }

  //Function to login the user
  Future<String> logInUser(
      {required String email, required String password}) async {
    String result = 'Some error occurred in login';
    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        result = 'success';
      } else {
        result = 'Please enter all the fields';
      }
    } catch (e) {
      result = e.toString();
      print(result);
    }
    return result;
  }
}
