import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'search.dart';

class CreateBookPage extends StatefulWidget {
  final Book? data; // Optional book data for editing existing book
  const CreateBookPage({super.key, this.data});

  @override
  State<CreateBookPage> createState() => _CreateBookPageState();
}

class _CreateBookPageState extends State<CreateBookPage> {
  final titleController = TextEditingController();
  final authorController = TextEditingController();
  final locationController = TextEditingController();
  final yearController = TextEditingController();
  final abstractController = TextEditingController();
  final textFieldController = TextEditingController();

  bool readController = false;
  double ratingController = 1;

  List genresSelected = [];

  String? titleError;
  String? authorError;
  String? locationError;
  String? yearError;
  String? abstractError;

  // Logic for setting initial values based on provided data
  void _setInitialValues() {
    if (widget.data != null) {
      titleController.text = widget.data!.title.toString();
      authorController.text = widget.data!.author.toString();
      yearController.text = widget.data!.year.characters.take(4).toString();
      abstractController.text = widget.data!.abstract.toString();
      // ... (set other controllers based on data properties)
    }
  }

  final WidgetStateProperty<Icon?> thumbIcon =
      WidgetStateProperty.resolveWith<Icon?>(
    (Set<WidgetState> states) {
      if (states.contains(WidgetState.selected)) {
        return const Icon(Icons.check_rounded);
      }
      return const Icon(Icons.close_rounded);
    },
  );

  List locations = [];
  List genres = [];

  Future fetchLocations() async {
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
          locations = [
            "--"
          ]; // Set locations to an empty list if data is missing
        }
      } else {
        locations = [
          "--"
        ]; // Set locations to an empty list if doc doesn't exist
      }
    });
  }

// TODO genres fetching
  Future fetchGenres() async {
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
          genres = ["Nessun genere"];
        }
      } else {
        genres = ["Nessun genere"];
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _setInitialValues();
    fetchLocations(); // Call fetchLocations here
    fetchGenres();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        const ListTile(
          title: Text(
            "Registra un libro",
            textAlign: TextAlign.center,
          ),
        ),
        ListTile(
          title: TextField(
            controller: titleController,
            autofocus: true,
            decoration: InputDecoration(
              labelText: 'Titolo',
              border: const OutlineInputBorder(),
              errorText: titleError,
            ),
          ),
        ),
        ListTile(
          title: TextField(
            autofocus: true,
            controller: authorController,
            decoration: InputDecoration(
              labelText: 'Autore',
              border: const OutlineInputBorder(),
              errorText: authorError,
            ),
          ),
        ),
        ListTile(
          title: DropdownMenu(
            label: const Text("Posizione"),
            // Set the currently selected value (optional)
            dropdownMenuEntries: List.generate(locations.length, (int index) {
              return DropdownMenuEntry(
                value: locations[index].toString(),
                label: locations[index].toString(),
              );
            }),

            expandedInsets: EdgeInsets.zero,
            enableFilter: true,
            enableSearch: true,
            requestFocusOnTap: true,
            errorText: locationError,
            trailingIcon: const Icon(Icons.expand_more_rounded),
            selectedTrailingIcon: const Icon(Icons.expand_less_rounded),
            controller: locationController,
          ),
        ),
        ListTile(
          title: TextField(
            autofocus: true,
            maxLines: null,
            minLines: 1,
            controller: abstractController,
            decoration: InputDecoration(
              labelText: 'Abstract',
              border: const OutlineInputBorder(),
              errorText: abstractError,
            ),
          ),
        ),
        ListTile(
          title: TextField(
            autofocus: true,
            controller: yearController,
            decoration: InputDecoration(
              labelText: 'Anno',
              border: const OutlineInputBorder(),
              errorText: yearError,
            ),
          ),
        ),
        const ListTile(
          title: Text("Genere:"),
        ),
        ListTile(
            title: Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              runSpacing: 8,
              spacing: 8,
              children: List.generate(genres.length, (int index) {
                String genre = genres[index];
                return InputChip(
                    label: Text(genre.toString()),
                    selected:
                        genresSelected.contains(genre.toString().toLowerCase()),
                    onSelected: (bool selected) {
                      setState(() {
                        selected
                            ? genresSelected.add(genre.toString().toLowerCase())
                            : genresSelected
                                .remove(genre.toString().toLowerCase());
                      });
                    });
              }),
            ),
            trailing: Tooltip(
                message: "Altro",
                child: IconButton(
                    icon: const Icon(Icons.add_rounded),
                    onPressed: () {
                      showModalBottomSheet<void>(
                        showDragHandle: true,
                        context: context,
                        builder: (context) {
                          return Padding(
                            padding: EdgeInsets.only(
                                bottom:
                                    MediaQuery.of(context).viewInsets.bottom),
                            child: ListView(
                              children: [
                                const ListTile(
                                  title: Text("Altro genere"),
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
                                      setState(() {
                                        genres.add(textFieldController.text);
                                      });

                                      Navigator.pop(context);
                                      textFieldController.clear();
                                    },
                                  ),
                                )
                              ],
                            ),
                          );
                        },
                      );
                    }))),
        SwitchListTile(
          value: readController,
          onChanged: (bool selected) {
            setState(() {
              readController = !readController;
            });
          },
          title: const Text("Questo libro è stato letto?"),
          thumbIcon: thumbIcon,
        ),
        ListTile(
          title: Row(
            children: [
              const Text("Voto:"),
              const VerticalDivider(
                width: 16,
              ),
              Expanded(
                  child: readController == true
                      ? Slider(
                          value: ratingController,
                          min: 1,
                          max: 5,
                          divisions: 4,
                          label: "⭐" * ratingController.round(),
                          onChanged: (double value) {
                            setState(() {
                              ratingController = value;
                            });
                          },
                        )
                      : Slider(
                          value: ratingController,
                          min: 1,
                          max: 5,
                          divisions: 4,
                          onChanged: null))
            ],
          ),
        ),
        ListTile(
          title: FilledButton.icon(
            onPressed: () => _saveBook(),
            label: const Text("Salva"),
            icon: const Icon(Icons.check_rounded),
          ),
        ),
      ],
    );
  }

  // Implement logic to save book data to Firebase
  // Implement logic to save book data to Firebase
  void _saveBook() async {
    setState(() {
      titleError =
          titleController.text.isEmpty ? "Il TITOLO è obbligatorio" : null;
      authorError =
          authorController.text.isEmpty ? "L'AUTORE è obbligatorio" : null;
      locationError = locationController.text.isEmpty
          ? "La POSIZIONE è obbligatoria"
          : null;
      yearError = yearController.text.isEmpty ? "L'ANNO è obbligatorio" : null;
      abstractError =
          abstractController.text.isEmpty ? "L'ABSTRACT è obbligatorio" : null;
    });

    if (titleError == null &&
        authorError == null &&
        locationError == null &&
        yearError == null &&
        abstractError == null) {
      // Proceed with saving the book
      final title = titleController.text;
      final author = authorController.text;
      final location = locationController.text;
      final bool read = readController;
      final abstract = abstractController.text;
      final year = int.tryParse(yearController.text) ?? 0000;
      final int rating = ratingController.round();

      // Create a reference to the books collection
      final booksRef = FirebaseFirestore.instance
          .collection("Data")
          .doc(FirebaseAuth.instance.currentUser!.email.toString())
          .collection("books");

      // Add the book data to the collection
      try {
        await booksRef.add({
          'title': title,
          'author': author,
          'location': location,
          'year': year,
          'rating': read == true ? rating : 0,
          'read': read,
          'abstract': abstract,
          'genres': genresSelected,
        });

        titleController.clear();
        authorController.clear();
        locationController.clear();
        yearController.clear();
        abstractController.clear();
        genres = [];

        Navigator.pop(context);

        // Handle edit scenario (pop twice if editing)

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Libro creato con successo!'),
            behavior: SnackBarBehavior.floating,
            dismissDirection: DismissDirection.startToEnd,
          ),
        );
      } catch (e) {
        Navigator.pop(context);

        // Handle edit scenario (pop twice if editing)

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            behavior: SnackBarBehavior.floating,
            dismissDirection: DismissDirection.startToEnd,
          ),
        );
      }

      // Clear the text fields for the next book
    }
  }
}
