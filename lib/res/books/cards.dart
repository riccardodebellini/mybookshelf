import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mytomes/sys/extensions.util.dart';

class BooksCards extends StatelessWidget {
  // ignore: prefer_typing_uninitialized_variables
  final book;
  final String? id;

  const BooksCards({super.key, required this.book, this.id});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        overflow: TextOverflow.ellipsis,
        book['title'].toString().toUpperCase(),
      ),
      subtitle: Text(
        '${book['due']?.toString().toDateTime().toReadable() ?? (book['read'] ? book['rating'].round().toString() : "Non letto")} - ${book['author'] ?? book['location']}',
        overflow: TextOverflow.ellipsis,
      ),
      trailing: (book['due']
                      ?.toString()
                      .toDateTime()
                      .difference(DateTime.now())
                      .inDays ??
                  4) <
              3
          ? const Icon(
              Icons.error_rounded,
              color: Colors.yellow,
            )
          : null,
      onTap: () {
        book['due'] != null
            ? context.push('/lends/details/${book['id']}', extra: book)
            : context.push('/books/details/${book['id']}', extra: book);
      },
    );
  }
}
