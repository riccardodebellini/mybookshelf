import 'package:flutter/material.dart';
import 'package:mybookshelf/pages/subpages/settings/settings.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = Supabase.instance.client;

class LendsPage extends StatefulWidget {
  const LendsPage({super.key});

  @override
  State<LendsPage> createState() => _LendsPageState();
}

class _LendsPageState extends State<LendsPage> {
  final _future = supabase.from('books').select();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Prestiti"),
          centerTitle: true,
          actions: [
            MenuAnchor(
              builder: (context, controller, child) {
                return IconButton(
                  onPressed: () {
                    if (controller.isOpen) {
                      controller.close();
                    } else {
                      controller.open();
                    }
                  },
                  icon: const Icon(Icons.more_vert),
                );
              },
              menuChildren: [
                MenuItemButton(
                  child: const Text('Impostazioni'),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return const SettingsPage();
                    }));
                  },
                ),
              ],
            )
          ],
        ),
        body: Column(
          children: [
            FilledButton(
                onPressed: () async {
                  final res = await supabase.auth.signInWithPassword(
                      email: 'dev@example.com', password: 'Dev1234');
                  print(res.toString());
                },
                child: Text("Login")),
            FilledButton(
                onPressed: () async {
                  await supabase.from('books').upsert({
                    'title': 'test authenticated',
                    'author': "author",
                    'location': "location",
                    'abstract': 'abstract',
                    'read': true,
                    'rating': 5,
                    'year': 2024,
                    'genres': ['genre1', 'genre2'],
                    'user_id': supabase.auth.currentUser!.id.toString()
                  });
                },
                child: const Text("Create")),
            // FilledButton(onPressed: () {}, child: Text("Login")),
            FutureBuilder(
              future: _future,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Text("data");
                }
                final books = snapshot.data!;
                return ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: books.length,
                  itemBuilder: ((context, index) {
                    final book = books[index];
                    return ListTile(
                      title: Text(book['title']),
                    );
                  }),
                );
              },
            ),
          ],
        ));
  }
}

/* const Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.do_not_disturb_alt_rounded,
            ),
            SizedBox(
              height: 8,
            ),
            Text("Questa sezione non è ancora disponibile, "),
          ],
        ))
*/