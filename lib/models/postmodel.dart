import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';

class Posts {
  const Posts({
    required this.description,
    required this.uid,
    required this.username,
    required this.postId,
    required this.datePublished,
    required this.profileImg,
    required this.postUrl,
    required this.likes,
  });

  final String description;
  final String uid;
  final String username;
  final String postId;
  final datePublished;
  final String profileImg;
  final String postUrl;
  final likes;

  Map<String, dynamic> toJson() => {
        'username': username,
        'uid': uid,
        'description': description,
        'postId': postId,
        'datePublished': datePublished,
        'profileImg': profileImg,
        'postUrl': postUrl,
        'likes':likes
      };

  //function that takes document snapshot and returns a user model
  static Posts fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Posts(
      username: snapshot['username'],
      description: snapshot['description'],
      postId: snapshot['postId'],
      datePublished: snapshot['datePublished'],
      profileImg: snapshot['profileImg'],
      postUrl: snapshot['postUrl'],
      uid: snapshot['uid'],
      likes:snapshot['likes'],
    );
  }
}
