import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../res/books/filters.dart';
import '../subpages/settings/settings.dart';

class BooksPage extends StatefulWidget {
  const BooksPage({super.key});

  @override
  State<BooksPage> createState() => _BooksPageState();
}

class _BooksPageState extends State<BooksPage> {
  Set<dynamic> currentFilter = {2};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text("Home"),
          actions: [
            MenuAnchor(
              builder: (context, controller, child) {
                return IconButton(
                  onPressed: () {
                    if (controller.isOpen) {
                      controller.close();
                    } else {
                      controller.open();
                    }
                  },
                  icon: const Icon(Icons.more_vert),
                );
              },
              menuChildren: [
                MenuItemButton(
                  child: const Text('Impostazioni'),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return const SettingsPage();
                    }));
                  },
                ),
              ],
            )
          ],
        ),
        body: Column(
          children: [
            Center(
              child: SegmentedButton(
                segments: const <ButtonSegment>[
                  ButtonSegment(
                    value: 2,
                    label: Text("Tutti"),
                  ),
                  ButtonSegment(
                    value: 0,
                    label: Text("Preferiti"),
                  ),
                  ButtonSegment(
                    value: 1,
                    label: Text("Non letti"),
                  )
                ],
                selected: currentFilter,
                showSelectedIcon: false,
                onSelectionChanged: (Set<dynamic> newSelection) {
                  setState(() {
                    currentFilter = newSelection;
                  });
                },
              ),
            ),
            Expanded(child: currentFilter.first == 0

            // FAVORITES
                ? FilteredView(filter: FirebaseFirestore.instance
                .collection("Data")
                .doc(FirebaseAuth.instance.currentUser!.email.toString())
                .collection("books")
                .where('rating', isGreaterThan: 4.0)
                .snapshots())
                : (currentFilter.first == 1

            // TO READ
                ? FilteredView(filter: FirebaseFirestore.instance
                .collection("Data")
                .doc(FirebaseAuth.instance.currentUser!.email.toString())
                .collection("books")
                .where('read', isEqualTo: false)
                .snapshots())

            // ALL BOOKS
                : FilteredView(filter: FirebaseFirestore.instance
                .collection("Data")
                .doc(FirebaseAuth.instance.currentUser!.email.toString())
                .collection("books")
                .snapshots())),)
          ],
        ));
  }
}
