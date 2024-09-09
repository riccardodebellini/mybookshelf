import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'create.dart';

class Book {
  final String title;
  final String year;
  final String author;
  final String abstract;

  Book(
      {required this.title,
      required this.year,
      required this.author,
      required this.abstract});

  factory Book.fromJson(Map<String, dynamic> json) {
    final volumeInfo = json['volumeInfo'];
    return Book(
      title: volumeInfo['title'],
      year: volumeInfo['publishedDate'] ?? '--',
      author: volumeInfo['authors']?.join(', ') ?? '--',
      abstract: volumeInfo['description'] ?? '--',
    );
  }
}

class BookListTile extends StatelessWidget {
  final Book book;

  const BookListTile({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(book.title),
      subtitle: Text('${book.year} - ${book.author}'),
      onTap: () {
        Navigator.pop(context);
        showModalBottomSheet<void>(
            showDragHandle: true,
            context: context,
            constraints: BoxConstraints(
              maxWidth: 600,
              maxHeight: MediaQuery.of(context).size.height * 0.7,
            ),
            builder: (context) {
              return Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: CreateBookPage(
                  data: book,
                ),
              );
            });
      },
    );
  }
}

class BookSearchPage extends StatefulWidget {
  const BookSearchPage({super.key});

  @override
  State<BookSearchPage> createState() => _BookSearchPageState();
}

class _BookSearchPageState extends State<BookSearchPage> {
  final TextEditingController _queryController = TextEditingController();
  List<Book> _books = [];

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        ListTile(
          title: TextField(
            controller: _queryController,
            onChanged: (query) {
              _searchBooks(query);
            },
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: "Cerca con Google Books",
            ),
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          itemCount: _books.length,
          itemBuilder: (context, index) {
            return BookListTile(book: _books[index]);
          },
        ),
      ],
    );
  }

  void _searchBooks(String query) async {
    final response = await http.get(Uri.parse(
        'https://www.googleapis.com/books/v1/volumes?q=$query&maxResults=30'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final items = data['items'] as List;

      setState(() {
        _books = items.map((item) => Book.fromJson(item)).toList();
      });
    } else {
      // Handle error
    }
  }
}
