
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Users {
  const Users({
    required this.email,
    required this.uid,
    required this.username,
    required this.bio,
    required this.followers,
    required this.following,
    required this.photoUrl,
  });

  final String email;
  final String uid;
  final String username;
  final String bio;
  final List followers;
  final List following;
  final String photoUrl;

  Map<String, dynamic> toJson() => {
        'username': username,
        'uid': uid,
        'email': email,
        'bio': bio,
        'followers': followers,
        'following': following,
        'photoUrl': photoUrl,
      };

  //function that takes document snapshot and returns a user model
  static Users fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Users(
      username:  snapshot['username'],
      bio: snapshot['bio'],
      email: snapshot['email'],
      followers: snapshot['followers'],
      following: snapshot['following'],
      photoUrl: snapshot['photoUrl'],
      uid: snapshot['uid'],

    );
  }
}
