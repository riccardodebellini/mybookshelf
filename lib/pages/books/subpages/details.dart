import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = Supabase.instance.client;

class BooksDetails extends StatelessWidget {
  // ignore: prefer_typing_uninitialized_variables
  final Map book;

  const BooksDetails({
    super.key,
    required this.book,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(book['title']),
          actions: [
            IconButton(
                onPressed: () async {
                  Navigator.pop(context);

                  await supabase
                      .from('countries')
                      .delete()
                      .eq('id', book['id']);
                },
                icon: const Icon(Icons.delete_rounded))
          ],
        ),
        body: ListView(
          children: [
            ListTile(
              title: const Text("Titolo"),
              subtitle: Text(book['title'].toString()),
              leading: const Icon(Icons.abc_rounded),
            ),
            ListTile(
              title: const Text("Autore"),
              subtitle: Text(book['author'].toString()),
              leading: const Icon(Icons.edit_rounded),
            ),
            ListTile(
              title: const Text("Anno"),
              subtitle: Text(book['year'].toString()),
              leading: const Icon(Icons.calendar_month_rounded),
            ),
            ListTile(
              title: const Text("Rating"),
              subtitle: book['read'] == false
                  ? const Text("Il libro non è ancora stato letto")
                  : Row(
                      children: List.generate(book['rating'], (int index) {
                        return const Icon(Icons.star_rounded);
                      }),
                    ),
              leading: const Icon(Icons.thumbs_up_down_rounded),
            ),
            ListTile(
              title: const Text("Posizione"),
              subtitle: Text(book['location']),
              leading: const Icon(
                Icons.location_pin,
              ),
            ),
            ListTile(
              title: const Text("Genere"),
              subtitle: Text(book['genres']
                  .toString()
                  .replaceAll("[", "")
                  .replaceAll("]", "")),
              leading: const Icon(
                Icons.category_rounded,
              ),
            ),
            ListTile(
              title: const Text("Abstract"),
              subtitle: Text(book['abstract'].toString()),
              leading: const Icon(Icons.text_snippet_rounded),
            ),
          ],
        ));
  }
}
