import 'package:flutter/material.dart';
import 'package:mybookshelf/pages/lends/subpages/details.dart';

import '../../pages/books/subpages/details.dart';

class BooksCards extends StatelessWidget {
  // ignore: prefer_typing_uninitialized_variables
  final book;
  final String? id;

  const BooksCards({super.key, required this.book, this.id});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        book['title'].toString().toUpperCase(),
      ),
      subtitle: Text(
        '${book['author'] ?? book['location']} - ${book['rating']?.round() ?? book['due']}',
      ),
      onTap: () {
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
    );
  }
}
