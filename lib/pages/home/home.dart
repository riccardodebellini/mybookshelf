import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mybookshelf/pages/subpages/settings/settings.dart';
import 'package:mybookshelf/res/books/filters.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<String> genres = [];
  bool isGenresLoading = true; // Flag for loading state

  fetchGenres() async {
    final docRef = FirebaseFirestore.instance
        .collection("Data")
        .doc(FirebaseAuth.instance.currentUser!.email)
        .collection("settings")
        .doc("data");

    final docSnapshot = await docRef.get();
    setState(() {
      isGenresLoading = false;
      if (docSnapshot.exists) {
        final data = docSnapshot.data();
        if (data != null && data['genres'] != null) {
          genres = List<String>.from(data['genres']);
        } else {
          genres = []; // Empty list if data is missing
        }
      } else {
        genres = []; // Empty list if doc doesn't exist
      }
    });
  }

  @override
  void initState() {
    super.initState();
    fetchGenres();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Home"),
          centerTitle: true,
          actions: [
            Tooltip(message: "Ricarica", child: IconButton(onPressed: () {fetchGenres();}, icon: Icon(Icons.sync_rounded))),
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
        body: ListView(
          children: [
            SizedBox(
              height: 268,
              child: Column(
                              children: [
              const ListTile(
                title: Text("Generi"),
                subtitle: Text("Esplora i tuoi libri divisi per genere"),
              ),
              Expanded(
                child: Tooltip(
                  message: (Platform.isLinux ||
                          Platform.isMacOS ||
                          Platform.isWindows)
                      ? "Usa SHIFT per scrollare"
                      : "",
                  child: isGenresLoading
                      ? const Center(
                          child:
                              CircularProgressIndicator()) // Loading indicator
                      : genres.isEmpty
                          ? ListTile(
                              title: const Text("Nessun genere trovato"),
                              leading: CircleAvatar(
                                backgroundColor:
                                    Theme.of(context).colorScheme.error,
                                foregroundColor:
                                    Theme.of(context).colorScheme.onError,
                                child: const Icon(Icons.error_rounded),
                              ),
                            )
                          : ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                return SizedBox(
                                  width: 200,
                                  child: Card.filled(
                                    child: Center(
                                        child: Text(
                                      genres[index]
                                          .toString()
                                          .toUpperCase(),
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium,
                                    )),
                                  ),
                                );
                              },
                              itemCount: genres.length,
                              // shrinkWrap: true,
                            ),
                ),
              ),
                              ],
                            ),
            ),
            const Divider(),
            ListTile(
              title: Text("Suggeriti"),
              subtitle: Text(
                  "Ottieni suggerimenti di lettura basati sulle tue preferenze"),
            ),
            FilteredView(filter: FirebaseFirestore.instance
                .collection("Data")
                .doc(FirebaseAuth.instance.currentUser!.email.toString())
                .collection("books")
                .where('genres', arrayContains: "gialli").limit(6)
                .snapshots()),
            const Divider(),
            ListTile(
              title: Text("Prestiti in scadenza"),
              subtitle: Text("Tieni d'occhio i libri prossimi alla scadenza"),
            ),
            ListTile(
              title: Text("Suggeriti"),
              subtitle: Text(
                  "Ottieni suggerimenti di lettura basati sulle tue preferenze"),
            ),
            ListTile(
              title: Text("Suggeriti"),
              subtitle: Text(
                  "Ottieni suggerimenti di lettura basati sulle tue preferenze"),
            ),
            ListTile(
              title: Text("Suggeriti"),
              subtitle: Text(
                  "Ottieni suggerimenti di lettura basati sulle tue preferenze"),
            ),
          ],
        ));
  }
}
