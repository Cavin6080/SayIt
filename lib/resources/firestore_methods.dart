import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sayit/models/postmodel.dart';
import 'package:sayit/resources/storage_methods.dart';
import 'package:uuid/uuid.dart';

class FireStoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //function upload post
  Future<String> uploadPost(String description, Uint8List file, String uid,
      String username, String profileImg) async {
    String result = 'Some error occured';
    //we have to first upload the photo to storage and that store that url in
    //firestore
    try {
      String photoUrl =
          await StorageMethods().uploadImageToStorage('posts', file, true);

      String postId = const Uuid().v1();

      Posts post = Posts(
        description: description,
        uid: uid,
        username: username,
        postId: postId,
        datePublished: DateTime.now(),
        profileImg: profileImg,
        postUrl: photoUrl,
        likes: [],
      );
      //uploaded to storage,now upload to firebase

      _firestore.collection('posts').doc(postId).set(post.toJson());
      result = 'success';
    } catch (e) {
      result = e.toString();
    }
    return result;
  }
}