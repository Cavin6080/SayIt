import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sayit/Utils/colors.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController textEditingController = TextEditingController();
  bool isShowusers = false;

  @override
  void dispose() {
    super.dispose();
    textEditingController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        title: Text(
          'Search',
          style: GoogleFonts.openSans(
            textStyle: const TextStyle(
              color: purplecolor,
              fontSize: 27,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            TextFormField(
              controller: textEditingController,
              decoration: InputDecoration(
                focusedBorder: InputBorder.none,
                hintText: 'Search for a user...',
                hintStyle: GoogleFonts.openSans(
                  textStyle: TextStyle(
                    color: purplecolor.withOpacity(0.6),
                  ),
                ),
              ),
              autofocus: true,
              onFieldSubmitted: (String _) {
                setState(() {
                  isShowusers = true;
                });
              },
            ),
            isShowusers
                ? FutureBuilder(
                    future: FirebaseFirestore.instance
                        .collection('users')
                        .where(
                          'username',
                          isGreaterThanOrEqualTo: textEditingController.text,
                        )
                        .get(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      return ListView.builder(
                        itemCount: (snapshot.data! as dynamic).docs.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            leading: CircleAvatar(
                              backgroundImage: NetworkImage(
                                (snapshot.data! as dynamic).docs[index]
                                    ['photoUrl'],
                              ),
                            ),
                            title: Text((snapshot.data! as dynamic).docs[index]
                                ['username']),
                          );
                        },
                      );
                    },
                  )
                : const SizedBox(width: 1)
          ],
        ),
      ),
    );
  }
}
