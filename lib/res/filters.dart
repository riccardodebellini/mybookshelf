import 'package:flutter/material.dart';
import 'package:mybookshelf/res/columnbuilder.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../pages/books/subpages/details.dart';
import '../pages/lends/subpages/details.dart';
import 'books/cards.dart';

class FilteredView extends StatefulWidget {
  final PostgrestFilterBuilder<List<Map<String, dynamic>>> filter;
  final bool isLend;

  const FilteredView({super.key, required this.filter, this.isLend = false});

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
          return Center(child: Text('Errore\n${snapshot.error.toString()}'));
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.data!.isEmpty) {
          return const Center(child: Text("Nessun dato"));
        }

        final books = snapshot.data!;

        if (MediaQuery.of(context).size.width > 840) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              DataTable(
                  showCheckboxColumn: false,
                  columns: [
                    const DataColumn(
                      label: Text("Titolo"),
                    ),
                    DataColumn(
                        label: Text(widget.isLend ? "Posizione" : "Autore")),
                    DataColumn(
                        label: Text(widget.isLend ? "Scadenza" : "Rating")),
                  ],
                  rows: List.generate(books.length, (index) {
                    final book = books[index];
                    return DataRow(
                      onSelectChanged: (_) {
                        book['due'] != null
                            ? Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LendDetails(
                                          book: book,
                                        )),
                              )
                            : Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => BooksDetails(
                                          book: book,
                                        )),
                              );
                      },
                      cells: <DataCell>[
                        DataCell(
                          Text(
                            book['title'],
                            textWidthBasis: TextWidthBasis.longestLine,
                          ),
                        ),
                        DataCell(Text(book['location'])), //book['author'] ??
                        DataCell(
                          SizedBox(
                            width: 200,
                            child: Text(book['rating']?.round().toString() ??
                                book['due']?.round().toString() ??
                                "--"),
                          ),
                        ),
                      ],
                    );
                  })),
            ],
          );
        } else {
          return ColumnBuilder(
            itemCount: books.length,
            itemBuilder: (context, index) {
              final book = books[index];
              return BooksCards(
                book: book,
              );
            },
          );
        }
      },
    );
  }
}
