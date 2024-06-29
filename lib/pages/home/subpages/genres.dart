import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mybookshelf/res/filters.dart';

FirebaseFirestore cloud = FirebaseFirestore.instance;

class GenresPage extends StatefulWidget {
  final String genre;

  const GenresPage({
    super.key,
    required this.genre,
  });

  @override
  State<GenresPage> createState() => _GenresPageState();
}

class _GenresPageState extends State<GenresPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(widget.genre.toUpperCase()),
        ),
        body: SingleChildScrollView(
          child: FilteredView(
              filter: cloud
                  .collection("Data")
                  .doc(FirebaseAuth.instance.currentUser!.email.toString())
                  .collection("books")
                  .where('genres', arrayContains: widget.genre)
                  .limit(4)
                  .snapshots()),
        ));
  }
}
