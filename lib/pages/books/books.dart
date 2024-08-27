import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../res/filters.dart';
import '../subpages/settings/settings.dart';

final supabase = Supabase.instance.client;

class BooksPage extends StatefulWidget {
  const BooksPage({super.key});

  @override
  State<BooksPage> createState() => _BooksPageState();
}

class _BooksPageState extends State<BooksPage> {
  Set<dynamic> currentFilter = {2};

  PostgrestFilterBuilder<List<Map<String, dynamic>>>? favBooks;
  PostgrestFilterBuilder<List<Map<String, dynamic>>>? unreadBooks;
  PostgrestFilterBuilder<List<Map<String, dynamic>>>? allBooks;

  loadBooks() async {
    final fav = supabase.from('books').select().gt('rating', 4);
    final unread = supabase.from('books').select().eq('read', false);
    final all = supabase.from('books').select();
    setState(() {
      favBooks = fav as PostgrestFilterBuilder<List<Map<String, dynamic>>>?;
      unreadBooks =
          unread as PostgrestFilterBuilder<List<Map<String, dynamic>>>?;
      allBooks = all as PostgrestFilterBuilder<List<Map<String, dynamic>>>?;
    });
  }

  @override
  void initState() {
    super.initState();
    loadBooks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text("Libri"),
          actions: [
            Tooltip(
                message: "Ricarica",
                child: IconButton(
                    onPressed: () {
                      loadBooks();
                    },
                    icon: const Icon(Icons.sync_rounded))),
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
            const SizedBox(
              height: 8,
            ),
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
            const SizedBox(
              height: 8,
            ),
            Expanded(
                child: SingleChildScrollView(
                    child: currentFilter.first == 0

                        // FAVORITES
                        ? FilteredView(filter: favBooks!)
                        : (currentFilter.first == 1

                            // TO READ
                            ? FilteredView(filter: unreadBooks!)

                            // ALL BOOKS
                        : FilteredView(filter: allBooks!))))
          ],
        ));
  }
}
