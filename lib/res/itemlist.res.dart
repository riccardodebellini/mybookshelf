import 'package:flutter/material.dart';
import 'package:mybookshelf/res/columnbuilder.dart';
import 'package:mybookshelf/sys/extensions.util.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../pages/books/subpages/details.dart';
import '../pages/lends/subpages/details.dart';
import 'books/cards.dart';

class ItemsList extends StatefulWidget {
  final dynamic filter;

  final bool isLend;

  final int reloadPlaceholders;

  const ItemsList(
      {super.key,
      required this.filter,
      this.isLend = false,
      this.reloadPlaceholders = 5});

  @override
  State<ItemsList> createState() => _ItemsListState();
}

class _ItemsListState extends State<ItemsList> {
  Future getBooks() async {
    final responseBody = widget.filter;
    return responseBody;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getBooks(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Errore:\n${snapshot.error.toString()}'));
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return ListView.builder(
            itemBuilder: (context, index) {
              return Skeletonizer(
                  child: ListTile(
                title: Text("Titolo libro ${index.toString()}"),
                subtitle: Text(
                    "${index.toString()} - Autore del libro molto molto molto moltissimo lungo"),
              ));
            },
            itemCount: widget.reloadPlaceholders,
            shrinkWrap: true,
          );
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
                  columnSpacing: 0,
                  showCheckboxColumn: false,
                  columns: [
                    const DataColumn(
                      label: Text("Titolo"),
                    ),
                    DataColumn(
                        label: Text(widget.isLend ? "Scadenza" : "Autore")),
                    DataColumn(
                        label: Text(widget.isLend ? "Posizione" : "Rating")),
                  ],
                  rows: List.generate(books.length, (index) {
                    final book = books[index];
                    final String title = book['title'];
                    final String? due =
                        book['due']?.toString().toDateTime().toReadable();
                    final String? author = book['author'];
                    final String? location = book['location'];
                    final bool? read = book['read'];
                    final String? rating = book['rating']?.round().toString();
                    final double width =
                        ((MediaQuery.of(context).size.width - 121.5) / 3)
                            .floorToDouble();

                    return DataRow(
                      onSelectChanged: (_) {
                        due != null
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
                          SizedBox(
                            width: width,
                            child: Text(
                              title,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                        DataCell(SizedBox(
                            width: width,
                            child: author != null
                                ? Text(
                                    author,
                                    overflow: TextOverflow.ellipsis,
                                  )
                                : Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(due ?? "--"),
                                      const SizedBox(
                                        width: 8,
                                      ),
                                      (book['due']
                                                      ?.toString()
                                                      .toDateTime()
                                                      .difference(
                                                          DateTime.now())
                                                      .inDays ??
                                                  4) <
                                              3
                                          ? Tooltip(
                                              message:
                                                  "Libro scaduto o prossimo alla scadenza",
                                              waitDuration:
                                                  Duration(seconds: 1),
                                              child: Icon(
                                                Icons.error_rounded,
                                                color: Colors.yellow,
                                              ))
                                          : Container()
                                    ],
                                  ))),
                        DataCell(
                          SizedBox(
                              width: width,
                              child: Text(due != null
                                  ? (location ?? "--")
                                  : ((read! ? rating! : "Non letto")))),
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
