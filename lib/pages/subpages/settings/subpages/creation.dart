import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mybookshelf/res/columnBuilder.dart';

class SettingsCreationPage extends StatefulWidget {
  const SettingsCreationPage({super.key});

  @override
  State<SettingsCreationPage> createState() => _SettingsCreationPageState();
}

class _SettingsCreationPageState extends State<SettingsCreationPage> {
  TextEditingController textFieldController = TextEditingController();
  List<String> locations = [];
  List<String> genres = [];
  String? favouriteGenre;

  fetchLocations() async {
    final docRef = FirebaseFirestore.instance
        .collection("Data")
        .doc(FirebaseAuth.instance.currentUser!.email)
        .collection("settings")
        .doc("data");
    final docSnapshot = await docRef.get();
    setState(() {
      if (docSnapshot.exists) {
        final data = docSnapshot.data();
        if (data != null && data['locations'] != null) {
          locations = List<String>.from(data['locations']);
        } else {
          locations = [];
        }
      } else {
        locations = [];
      }
    });
  }

  fetchFavouriteGenre() async {
    final docRef = FirebaseFirestore.instance
        .collection("Data")
        .doc(FirebaseAuth.instance.currentUser!.email)
        .collection("settings")
        .doc("data");
    final docSnapshot = await docRef.get();
    setState(() {
      if (docSnapshot.exists) {
        final data = docSnapshot.data();
        if (data != null && data['favouriteGenre'] != null) {
          favouriteGenre = data['favouriteGenre'];
        }
      }
    });
  }

  fetchGenres() async {
    final docRef = FirebaseFirestore.instance
        .collection("Data")
        .doc(FirebaseAuth.instance.currentUser!.email)
        .collection("settings")
        .doc("data");

    final docSnapshot = await docRef.get();
    setState(() {
      if (docSnapshot.exists) {
        final data = docSnapshot.data();
        if (data != null && data['genres'] != null) {
          genres = List<String>.from(data['genres']);
        } else {
          genres = [];
        }
      } else {
        genres = [];
      }
    });
  }

  editedLocations() async {
    try {
      await FirebaseFirestore.instance
          .collection("Data")
          .doc(FirebaseAuth.instance.currentUser!.email)
          .collection("settings")
          .doc("data")
          .update({'locations': locations});
    } on FirebaseException catch (e) {
      if (e.code == "not-found") {
        await FirebaseFirestore.instance
            .collection("Data")
            .doc(FirebaseAuth.instance.currentUser!.email)
            .collection("settings")
            .doc("data")
            .set({'locations': locations});
      }
    }
    fetchLocations();
  }

  editedGenres() async {
    try {
      await FirebaseFirestore.instance
          .collection("Data")
          .doc(FirebaseAuth.instance.currentUser!.email)
          .collection("settings")
          .doc("data")
          .update({'genres': genres});
    } on FirebaseException catch (e) {
      if (e.code == "not-found") {
        await FirebaseFirestore.instance
            .collection("Data")
            .doc(FirebaseAuth.instance.currentUser!.email)
            .collection("settings")
            .doc("data")
            .set({'genres': genres});
      }
    }
    fetchGenres();
  }

  editedFavouriteGenre() async {
    try {
      await FirebaseFirestore.instance
          .collection("Data")
          .doc(FirebaseAuth.instance.currentUser!.email)
          .collection("settings")
          .doc("data")
          .update({'favouriteGenre': favouriteGenre.toString()});
    } on FirebaseException catch (e) {
      if (e.code == "not-found") {
        await FirebaseFirestore.instance
            .collection("Data")
            .doc(FirebaseAuth.instance.currentUser!.email)
            .collection("settings")
            .doc("data")
            .set({'genres': genres});
      }
    }
    fetchGenres();
  }

  @override
  void initState() {
    super.initState();
    fetchLocations();
    fetchGenres();
    fetchFavouriteGenre();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Creazione"),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          ListTile(
            title: Card.filled(
              child: Column(
                children: [
                  const ListTile(
                    title: Text("Posizioni"),
                    subtitle: Text(
                        "Aggiungi ed elimina le posizioni disponibili per i tuoi libri"),
                  ),
                  locations.isEmpty
                      ? ListTile(
                          title: const Text("Nessuna posizione trovata"),
                          leading: CircleAvatar(
                            backgroundColor:
                                Theme.of(context).colorScheme.error,
                            foregroundColor:
                                Theme.of(context).colorScheme.onError,
                            child: const Icon(Icons.error_rounded),
                          ),
                        )
                      : ColumnBuilder(
                          itemBuilder: (context, index) {
                            return ListTile(
                              title: Text(locations[index]),
                              leading: IconButton(
                                icon: const Icon(Icons.remove_rounded),
                                onPressed: () {
                                  locations.removeAt(index);
                                  editedLocations();
                                },
                              ),
                            );
                          },
                          itemCount: locations.length,
                        ),
                  ListTile(
                    leading: FilledButton.icon(
                      icon: const Icon(Icons.add_rounded),
                      label: const Text("Aggiungi"),
                      onPressed: () {
                        showModalBottomSheet<void>(
                            showDragHandle: true,
                            context: context,
                            constraints: const BoxConstraints(maxWidth: 600),
                            builder: (context) {
                              return Padding(
                                padding: EdgeInsets.only(
                                    bottom: MediaQuery.of(context)
                                        .viewInsets
                                        .bottom),
                                child: ListView(
                                  children: [
                                    const ListTile(
                                      title:
                                          Text("Aggiungi una nuova posizione"),
                                    ),
                                    ListTile(
                                      title: TextField(
                                        decoration: const InputDecoration(
                                          labelText: 'Posizione',
                                          border: OutlineInputBorder(),
                                        ),
                                        controller: textFieldController,
                                      ),
                                    ),
                                    ListTile(
                                      title: FilledButton.icon(
                                        label: const Text("Salva"),
                                        icon: const Icon(Icons.check_rounded),
                                        onPressed: () {
                                          locations
                                              .add(textFieldController.text);
                                          editedLocations();
                                          Navigator.pop(context);
                                          textFieldController.clear();
                                        },
                                      ),
                                    )
                                  ],
                                ),
                              );
                            });
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
          const Divider(),
          ListTile(
            title: Card.filled(
              child: Column(
                children: [
                  const ListTile(
                    title: Text("Generi"),
                    subtitle: Text(
                        "Aggiungi ed elimina i generi disponibili per i tuoi libri"),
                  ),
                  genres.isEmpty
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
                      : ColumnBuilder(
                          itemBuilder: (context, index) {
                            return ListTile(
                              title: Text(genres[index]),
                              leading: IconButton(
                                icon: const Icon(Icons.remove_rounded),
                                onPressed: () {
                                  genres.removeAt(index);
                                  editedGenres();
                                },
                              ),
                              trailing: IconButton(
                                icon: favouriteGenre == genres[index]
                                    ? const Icon(Icons.star_rounded)
                                    : const Icon(Icons.star_border_rounded),
                                onPressed: () {
                                  favouriteGenre == genres[index]
                                      ? favouriteGenre = null
                                      : favouriteGenre = genres[index];
                                  editedFavouriteGenre();
                                },
                              ),
                            );
                          },
                          itemCount: genres.length,
                        ),
                  ListTile(
                    leading: FilledButton.icon(
                      icon: const Icon(Icons.add_rounded),
                      label: const Text("Aggiungi"),
                      onPressed: () {
                        showModalBottomSheet<void>(
                            showDragHandle: true,
                            context: context,
                            builder: (context) {
                              return Padding(
                                padding: EdgeInsets.only(
                                    bottom: MediaQuery.of(context)
                                        .viewInsets
                                        .bottom),
                                child: ListView(
                                  children: [
                                    const ListTile(
                                      title: Text("Aggiungi un nuovo genere"),
                                    ),
                                    ListTile(
                                      title: TextField(
                                        decoration: const InputDecoration(
                                          labelText: 'Genere',
                                          border: OutlineInputBorder(),
                                        ),
                                        controller: textFieldController,
                                      ),
                                    ),
                                    ListTile(
                                      title: FilledButton.icon(
                                        label: const Text("Salva"),
                                        icon: const Icon(Icons.check_rounded),
                                        onPressed: () {
                                          genres.add(textFieldController.text);
                                          editedGenres();
                                          Navigator.pop(context);
                                          textFieldController.clear();
                                        },
                                      ),
                                    )
                                  ],
                                ),
                              );
                            });
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
