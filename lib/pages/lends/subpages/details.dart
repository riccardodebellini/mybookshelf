import 'package:flutter/material.dart';
import 'package:mybookshelf/sys/extensions.util.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = Supabase.instance.client;

class LendDetails extends StatelessWidget {
  // ignore: prefer_typing_uninitialized_variables
  final Map book;

  const LendDetails({
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

                  await supabase.from('lends').delete().eq('id', book['id']);
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
              title: const Text("Posizione"),
              subtitle: Text(book['location']),
              leading: const Icon(
                Icons.location_pin,
              ),
            ),
            ListTile(
              title: const Text("Scadenza"),
              subtitle: Text(book['due'].toString().toDateTime().toReadable()),
              leading: const Icon(Icons.notification_important_rounded),
            ),
          ],
        ));
  }
}
