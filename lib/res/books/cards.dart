import 'package:flutter/material.dart';

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
        '${book['author']} - ${book['rating'].round()}',
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => BooksDetails(
                    book: book,
                    id: id,
                  )),
        );
      },
    );
  }
}
