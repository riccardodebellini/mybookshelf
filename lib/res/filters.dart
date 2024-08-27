import 'package:flutter/material.dart';
import 'package:mybookshelf/res/columnbuilder.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'books/cards.dart';

class FilteredView extends StatefulWidget {
  final PostgrestFilterBuilder<List<Map<String, dynamic>>> filter;

  const FilteredView({super.key, required this.filter});

  @override
  State<FilteredView> createState() => _FilteredViewState();
}

class _FilteredViewState extends State<FilteredView> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: widget.filter,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          print(snapshot.error);
          return Center(child: const Text('Error loading books'));
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData) {
          return Center(child: Text("Nessun dato"));
        }

        final books = snapshot.data!;

        return MediaQuery.of(context).size.width > 840
            ? GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, mainAxisExtent: 64),
                itemBuilder: (context, index) {
                  final book = books[index];
                  return BooksCards(
                    book: book,
                  );
                },
                itemCount: books.length,
                shrinkWrap: true,
              )
            : ColumnBuilder(
                itemCount: books.length,
                itemBuilder: (context, index) {
                  final book = books[index];
                  return BooksCards(
                    book: book,
                  );
                },
              );
      },
    );
  }
}
