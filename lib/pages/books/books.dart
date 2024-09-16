import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../res/filters.dart';

final supabase = Supabase.instance.client;

GlobalKey<BooksPageState> booksPageKey = GlobalKey();

class BooksPage extends StatefulWidget {
  const BooksPage({required Key key}) : super(key: key);

  @override
  State<BooksPage> createState() => BooksPageState();
}

class BooksPageState extends State<BooksPage> {
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

  final GlobalKey<RefreshIndicatorState> isReloading =
  GlobalKey<RefreshIndicatorState>();

  reloadAll() {
    setState(() {
      isReloading.currentState?.show();
    });
  }

  @override
  void initState() {
    super.initState();
    loadBooks();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        await loadBooks();
      },
      key: isReloading,
      child: ListView(
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
          currentFilter.first == 0
              ? FilteredView(filter: favBooks!)
              : (currentFilter.first == 1
                  ? FilteredView(filter: unreadBooks!)
                  : FilteredView(filter: allBooks!))
        ],
      ),
    );
  }
}
