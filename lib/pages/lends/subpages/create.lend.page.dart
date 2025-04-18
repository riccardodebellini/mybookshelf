import 'package:flutter/material.dart';
import 'package:mytomes/sys/extensions.util.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = Supabase.instance.client;

class CreateLendPage extends StatefulWidget {
  const CreateLendPage({
    super.key,
  });

  @override
  State<CreateLendPage> createState() => _CreateLendPageState();
}

class _CreateLendPageState extends State<CreateLendPage> {
  final titleController = TextEditingController();
  final locationController = TextEditingController();
  late var dueController = DateTime.now().add(const Duration(days: 30));

  String? titleError;
  String? locationError;
  String? dueError;

  List locations = [];

  Future fetchLocations() async {
    final data = await supabase.from("profile").select();
    final userData = data[0];
    setState(() {
      if (userData['locations'] != null) {
        locations = List<String>.from(userData['locations']);
      } else {
        locations = ["--"];
      }
    });
  }

  @override
  void initState() {
    super.initState();

    fetchLocations();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        const ListTile(
          title: Text(
            "Registra un prestito",
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
          title: const Text("Scadenza"),
          subtitle: Text(dueController.toReadable()),
          trailing: FilledButton(
              onPressed: () {
                showDatePicker(
                        // cancelText: "Annulla",
                        currentDate: DateTime.now(),
                        initialDate: dueController,
                        locale: const Locale('it'),
                        context: context,
                        firstDate:
                            DateTime.now().add(const Duration(days: -30)),
                        lastDate: DateTime.now().add(const Duration(days: 365)))
                    .then((value) {
                  value != null
                      ? setState(() {
                          dueController = value;
                        })
                      : null;
                });
              },
              child: const Text("Cambia")),
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
      locationError = locationController.text.isEmpty
          ? "La POSIZIONE è obbligatoria"
          : null;
    });

    if (titleError == null && locationError == null) {
      // Proceed with saving the book
      final title = titleController.text;
      final location = locationController.text;

      try {
        await supabase.from('lends').insert({
          'title': title,
          'location': location,
          'user_id': supabase.auth.currentUser!.id,
          'due': dueController.toShortString()
        });

        titleController.clear();
        locationController.clear();

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
