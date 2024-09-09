import 'package:flutter/material.dart';
import 'package:mybookshelf/res/columnBuilder.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = Supabase.instance.client;

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
    final data = await supabase.from("profile").select();
    final userData = data[0];
    setState(() {
      if (userData['locations'] != null) {
        locations = List<String>.from(userData['locations']);
      } else {
        locations = [];
      }
    });
  }

  fetchFavouriteGenre() async {
    final data = await supabase.from("profile").select();
    final userData = data[0];
    setState(() {
      if (userData['genres'] != null) {
        favouriteGenre = userData['favouriteGenre'];
      } else {
        favouriteGenre = "";
      }
    });
  }
  fetchGenres() async {
    final data = await supabase.from("profile").select();
    final userData = data[0];
    setState(() {
      if (userData['genres'] != null) {
        genres = List<String>.from(userData['genres']);
      } else {
        genres = [];
      }
    });
  }

  editedLocations() async {
    await supabase.from('profile').upsert({
      'user_id': supabase.auth.currentUser!.id,
      'locations': locations
    }).select();

    fetchLocations();
  }

  editedGenres() async {
    await supabase.from('profile').upsert(
        {'user_id': supabase.auth.currentUser!.id, 'genres': genres}).select();

    fetchGenres();
  }

  editedFavouriteGenre() async {
    await supabase.from('profile').upsert({
      'user_id': supabase.auth.currentUser!.id,
      'favouriteGenre': favouriteGenre
    }).select();

    fetchFavouriteGenre();
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
                            constraints: BoxConstraints(
                              maxWidth: 600,
                              maxHeight:
                                  MediaQuery.of(context).size.height * 0.7,
                            ),
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
          ListTile(
            title: Card.filled(
              child: Column(
                children: [
                  const ListTile(
                    title: Text("Generi"),
                    subtitle: Text(
                        "Aggiungi ed elimina i generi disponibili per i tuoi libri \nContrassegna con la stellina il tuo genere preferito, lo useremo per fornirti suggerimenti di lettura!"),
                    isThreeLine: true,
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
                            constraints: BoxConstraints(
                              maxWidth: 600,
                              maxHeight:
                                  MediaQuery.of(context).size.height * 0.7,
                            ),
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
