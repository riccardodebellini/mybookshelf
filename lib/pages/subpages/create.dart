
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'search.dart';

class CreateBookArea extends StatefulWidget {
  final TextEditingController titleController;
  final TextEditingController authorController;
  final TextEditingController locationController;
  final TextEditingController yearController;
  final TextEditingController abstractController;
  bool readController;
  final WidgetStateProperty<Icon?> thumbIcon;
  double ratingController;
  final String? titleError;
  final String? authorError;
  final String? locationError;
  final String? yearError;
  final String? abstractError;
  final void Function() saveBook;

  CreateBookArea(
      {super.key,
      required this.titleController,
      required this.authorController,
      required this.locationController,
      required this.yearController,
      required this.abstractController,
      this.titleError,
      this.authorError,
      this.locationError,
      this.yearError,
      this.abstractError,
      required this.readController,
      required this.ratingController,
      required this.thumbIcon,
      required this.saveBook});

  @override
  State<CreateBookArea> createState() => _CreateBookAreaState();
}

class _CreateBookAreaState extends State<CreateBookArea> {
  @override
  Widget build(BuildContext context) {
    return ListView(children: [
      ListTile(
        title: TextField(
            controller: widget.titleController,
            decoration: InputDecoration(
              labelText: 'Titolo',
              border: const OutlineInputBorder(),
              errorText: widget.titleError,
            )),
      ),
      ListTile(
        title: TextField(
            controller: widget.authorController,
            decoration: InputDecoration(
                labelText: 'Autore',
                border: const OutlineInputBorder(),
                errorText: widget.authorError)),
      ),
      ListTile(
        title: TextField(
            controller: widget.locationController,
            decoration: InputDecoration(
                labelText: 'Posizione',
                border: const OutlineInputBorder(),
                errorText: widget.locationError)),
      ),
      ListTile(
        title: TextField(
            maxLines: null,
            minLines: 1,
            controller: widget.abstractController,
            decoration: InputDecoration(
                labelText: 'Abstract',
                border: const OutlineInputBorder(),
                errorText: widget.abstractError)),
      ),
      ListTile(
        title: TextField(
            controller: widget.yearController,
            decoration: InputDecoration(
                labelText: 'Anno',
                border: const OutlineInputBorder(),
                errorText: widget.yearError)),
      ),
      ListTile(
        title: const Text("Questo libro è stato letto?"),
        trailing: Switch(
          value: widget.readController,
          onChanged: (bool value) {
            // This is called when the user toggles the switch.
            setState(() {
              widget.readController = value;
            });
          },
          thumbIcon: widget.thumbIcon,
        ),
      ),
      ListTile(
        title: Row(
          children: [
            const Text("Voto:"),
            const VerticalDivider(
              width: 16,
            ),
            Expanded(
                child: widget.readController == true
                    ? Slider(
                        value: widget.ratingController,
                        min: 1,
                        max: 5,
                        divisions: 4,
                        label: "⭐" * widget.ratingController.round(),
                        onChanged: (double value) {
                          setState(() {
                            widget.ratingController = value;
                          });
                        },
                      )
                    : Slider(
                        value: widget.ratingController,
                        min: 1,
                        max: 5,
                        divisions: 4,
                        onChanged: null))
          ],
        ),
      ),
      ListTile(
        title: FilledButton.icon(
          onPressed: widget.saveBook,
          label: const Text("Salva"),
          icon: const Icon(Icons.check_rounded),
        ),
      ),
    ]);
  }
}

class CreateBookPage extends StatefulWidget {
  final Book? data;
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

  bool readController = false;

  double ratingController = 1;
  final WidgetStateProperty<Icon?> thumbIcon =
      WidgetStateProperty.resolveWith<Icon?>(
    (Set<WidgetState> states) {
      if (states.contains(WidgetState.selected)) {
        return const Icon(Icons.check_rounded);
      }
      return const Icon(Icons.close_rounded);
    },
  );

  String? titleError;

  String? authorError;
  String? locationError;
  String? yearError;
  String? abstractError;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CreateBookArea(
                  thumbIcon: thumbIcon,
                  abstractController: abstractController,
                  authorController: authorController,
                  locationController: locationController,
                  ratingController: ratingController,
                  readController: readController,
                  titleController: titleController,
                  yearController: yearController,
                  abstractError: abstractError,
                  authorError: authorError,
                  locationError: locationError,
                  saveBook: saveBook,
                  titleError: titleError,
                  yearError: yearError,
                ),
              );
  }

  @override
  void initState() {
    super.initState();

    if (widget.data != null) {
      // Set initial values only if data is provided
      titleController.text = widget.data!.title.toString();
      authorController.text = widget.data!.author.toString();
      yearController.text = widget.data!.year.characters.take(4).toString();
      abstractController.text = widget.data!.abstract.toString();
      // ... (set other controllers based on data properties)
    }
  }

  // Implement logic to save book data to Firebase
  void saveBook() async {
    setState(() {
      titleError =
          titleController.text.isEmpty ? "Il TITLO è obbligatorio" : null;
      authorError =
          authorController.text.isEmpty ? "L'AUTORE è obbligatorio" : null;
      locationError = locationController.text.isEmpty
          ? "La POSIZIONE è obbligatoria"
          : null;
      yearError = yearController.text.isEmpty ? "L'ANNO è obbligatorio" : null;
      abstractError =
          abstractController.text.isEmpty ? "L'ABSTRACT è obbligatorio" : null;
      readController = readController;
      ratingController = ratingController;
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
      final year = int.tryParse(yearController.text) ??
          0; // Handle potential parsing error
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
        });

        titleController.clear();
        authorController.clear();
        locationController.clear();
        yearController.clear();
        abstractController.clear();
        Navigator.pop(context);

        widget.data != null ? Navigator.pop(context) : null;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Libro creato con successo!'),
            behavior: SnackBarBehavior.floating,
            dismissDirection: DismissDirection.startToEnd,
          ),
        );
      } catch (e) {
        Navigator.pop(context);

        widget.data != null ? Navigator.pop(context) : null;

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
