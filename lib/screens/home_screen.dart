import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:sayit/Utils/colors.dart';
import 'package:sayit/Utils/utilityFunction.dart';
import 'package:sayit/models/usermodel.dart';
import 'package:sayit/providers/user_provider.dart';
import 'package:sayit/resources/firestore_methods.dart';
import 'package:sayit/screens/screens.dart';
import 'package:sayit/widgets/like_animation.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Uint8List? _file;

  @override
  Widget build(BuildContext context) {
    return _file != null
        ? AddPostScreen(
            file: _file,
          )
        : Scaffold(
            appBar: AppBar(
              title: Text(
                'Home',
                style: GoogleFonts.openSans(
                    textStyle: const TextStyle(
                        color: purplecolor,
                        fontSize: 27,
                        fontWeight: FontWeight.w600)),
              ),
              actions: [
                IconButton(
                    onPressed: () {
                      // ignore: void_checks
                      return _selectImage(context);
                    },
                    icon: const Icon(
                      Icons.add_box_rounded,
                      color: purplecolor,
                    ))
              ],
              elevation: 0,
              backgroundColor: Colors.white,
              centerTitle: false,
            ),
            body: StreamBuilder(
              // to see realtime post data
              stream:
                  FirebaseFirestore.instance.collection('posts').snapshots(),
              builder: (context,
                  AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) => PostCard(
                          snap: snapshot.data!.docs[index].data(),
                        ));
              },
            ),
          );
  }

  _selectImage(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: const Text('Create a Post'),
            children: [
              SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('Take a Photo'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  Uint8List file = await pickImage(ImageSource.camera);
                  setState(() {
                    _file = file;
                  });
                },
              ),
              SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('Choose from Gallery'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  Uint8List? file = await pickImage(ImageSource.gallery);
                  setState(() {
                    _file = file;
                  });
                },
              ),
            ],
          );
        });
  }
}

class PostCard extends StatefulWidget {
  const PostCard({
    Key? key,
    required this.snap,
  }) : super(key: key);

  final snap;

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool isLikeAnimating = false;
  int commentLen = 0;

  @override
  void initState() {
    super.initState();
    getComments();
  }

  void getComments() async {
    try {
      QuerySnapshot snap = await FirebaseFirestore.instance
          .collection('posts')
          .doc(widget.snap['postId'])
          .collection('comments')
          .get();

      commentLen = snap.docs.length;
    } catch (e) {
      showSnackBar(e.toString(), context);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final Users? user = Provider.of<UserProvider>(context).getuser;
    return Container(
      padding: const EdgeInsets.only(top: 5, left: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Container(
          //   height: 60,
          //   child: ListView(
          //     scrollDirection: Axis.horizontal,
          //     children: [
          //       Stack(
          //         children: const [
          //           CircleAvatar(
          //             backgroundImage: NetworkImage(
          //                 'https://images.unsplash.com/photo-1650508761016-c0058a25b284?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxlZGl0b3JpYWwtZmVlZHwyNHx8fGVufDB8fHx8&auto=format&fit=crop&w=500&q=60'),
          //             radius: 26,
          //           ),
          //           Positioned(
          //             child: CircleAvatar(
          //               radius: 10,
          //               backgroundColor: purplecolor,
          //               foregroundColor: purplecolor,
          //               child: Icon(Icons.add, color: Colors.white),
          //             ),
          //             bottom: 6,
          //             right: 0,
          //           ),
          //         ],
          //       ),
          //       const StoriesCard(),
          //       const StoriesCard(),
          //       const StoriesCard(),
          //       const StoriesCard(),
          //       const StoriesCard(),
          //     ],
          //   ),
          // ),
          Divider(
            color: purplecolor.withOpacity(0.1),
            thickness: 1,
            height: 20,
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 7),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundImage:
                              NetworkImage(widget.snap['profileImg']),
                          radius: 17,
                        ),
                        SizedBox(
                          width: 7,
                        ),
                        Text(
                          widget.snap['username'],
                          style: GoogleFonts.openSans(
                            textStyle: const TextStyle(
                              color: Colors.black87,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      icon: Icon(Icons.more_vert_rounded),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => Dialog(
                            child: ListView(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              shrinkWrap: true,
                              children: ['Delete Post']
                                  .map(
                                    (e) => InkWell(
                                      onTap: () async {
                                        await FireStoreMethods()
                                            .deletePost(widget.snap['postId']);
                                        Navigator.of(context).pop();
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 12, horizontal: 16),
                                        child: Text(e),
                                      ),
                                    ),
                                  )
                                  .toList(),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Stack(
                  children: [
                    GestureDetector(
                      onDoubleTap: () async {
                        await FireStoreMethods().likePPost(
                            widget.snap['postId'],
                            user!.uid,
                            widget.snap['likes']);
                        setState(() {
                          isLikeAnimating = true;
                        });
                      },
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(right: 15),
                            height: MediaQuery.of(context).size.width - 50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  offset: const Offset(0, 10),
                                  blurRadius: 20,
                                  color: purplecolor.withOpacity(0.3),
                                ),
                              ],
                              image: DecorationImage(
                                  image: NetworkImage(
                                    widget.snap['postUrl'],
                                  ),
                                  fit: BoxFit.cover),
                            ),
                          ),
                          AnimatedOpacity(
                            duration: const Duration(milliseconds: 200),
                            opacity: isLikeAnimating ? 1 : 0,
                            child: LikeAnimation(
                              child: const Icon(
                                Icons.favorite,
                                color: Colors.white,
                                size: 125,
                              ),
                              isAnimating: isLikeAnimating,
                              duration: const Duration(
                                milliseconds: 400,
                              ),
                              onEnd: () {
                                setState(() {
                                  isLikeAnimating = false;
                                });
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 13,
                      child: LikeAnimation(
                        isAnimating: widget.snap['likes'].contains(user!.uid),
                        smallLike: true,
                        child: IconButton(
                          icon: widget.snap['likes'].contains(user.uid)
                              ? Icon(
                                  Icons.favorite,
                                  color: purplecolor.withOpacity(0.9),
                                )
                              : const Icon(
                                  Icons.favorite_border,
                                ),
                          onPressed: () async {
                            await FireStoreMethods().likePPost(
                                widget.snap['postId'],
                                user.uid,
                                widget.snap['likes']);
                            setState(() {
                              isLikeAnimating = true;
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            color: purplecolor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            '${widget.snap['likes'].length} likes',
                            style: GoogleFonts.openSans(
                              textStyle: const TextStyle(
                                  color: Colors.black87,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {},
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                              color: purplecolor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              '$commentLen comments',
                              style: GoogleFonts.openSans(
                                textStyle: const TextStyle(
                                    color: Colors.black87,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      margin: const EdgeInsets.only(right: 5),
                      child: IconButton(
                        onPressed: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => CommentScreen(
                              snap: widget.snap,
                            ),
                          ),
                        ),
                        icon: Icon(
                          Icons.message_rounded,
                          color: purplecolor.withOpacity(0.6),
                        ),
                      ),
                    ),
                  ],
                ),
                //Description
                // SizedBox(
                //   width: double.infinity,
                //   child: Text(
                //     'This is some description of my kitty',
                //     style: GoogleFonts.openSans(),
                //   ),
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class StoriesCard extends StatelessWidget {
  const StoriesCard({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 55,
      width: 55,
      margin: const EdgeInsets.only(left: 17, bottom: 5),
      padding: const EdgeInsets.all(1.4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: purplecolor,
      ),
      child: const CircleAvatar(
        backgroundImage: NetworkImage(
            'https://images.unsplash.com/photo-1650571799597-d3fee10849f5?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxlZGl0b3JpYWwtZmVlZHw1MHx8fGVufDB8fHx8&auto=format&fit=crop&w=500&q=60'),
        radius: 26,
      ),
    );
  }
}
