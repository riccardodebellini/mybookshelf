import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mybookshelf/res/columnbuilder.dart';

import 'books/cards.dart';

class FilteredView extends StatefulWidget {
  final Stream<QuerySnapshot> filter;

  const FilteredView({super.key, required this.filter});

  @override
  State<FilteredView> createState() => _FilteredViewState();
}

class _FilteredViewState extends State<FilteredView> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: widget.filter,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text('Error loading books');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final bookDocs = snapshot.data!.docs;
        return MediaQuery.of(context).size.width > 840
            ? GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, mainAxisExtent: 64),
                itemBuilder: (context, index) {
                  final bookData =
                      bookDocs[index].data() as Map<String, dynamic>;
                  final bookId = bookDocs[index].reference.id;

                  return BooksCards(
                    book: bookData,
                    id: bookId,
                  );
                },
                itemCount: bookDocs.length,
                shrinkWrap: true,
              )
            : ColumnBuilder(
                itemCount: bookDocs.length,
                itemBuilder: (context, index) {
                  final bookData =
                      bookDocs[index].data() as Map<String, dynamic>;
                  final bookId = bookDocs[index].reference.id;

                  return BooksCards(
                    book: bookData,
                    id: bookId,
                  );
                },
              );
      },
    );
  }
}
