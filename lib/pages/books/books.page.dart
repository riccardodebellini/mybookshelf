import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../res/itemlist.res.dart';

final supabase = Supabase.instance.client;

GlobalKey<BooksPageState> booksPageKey = GlobalKey();

class BooksPage extends StatefulWidget {
  const BooksPage({required Key key}) : super(key: key);

  @override
  State<BooksPage> createState() => BooksPageState();
}

class BooksPageState extends State<BooksPage> {
  Set<dynamic> currentFilter = {2};

  final GlobalKey<RefreshIndicatorState> isReloading =
      GlobalKey<RefreshIndicatorState>();

  reload() {
    setState(() {
      isReloading.currentState?.show();
    });
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {},
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
              ? ItemsList(
                  filter: supabase.from('books').select().gt('rating', 4))
              : (currentFilter.first == 1
                  ? ItemsList(
                      filter: supabase.from('books').select().eq('read', false))
                  : ItemsList(filter: supabase.from('books').select()))
        ],
      ),
    );
  }
}
