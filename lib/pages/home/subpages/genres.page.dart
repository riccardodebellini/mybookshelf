import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mybookshelf/sys/extensions.util.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../res/itemlist.res.dart';

final supabase = Supabase.instance.client;

class GenresPage extends StatefulWidget {
  final String genre;

  const GenresPage({
    super.key,
    required this.genre,
  });

  @override
  State<GenresPage> createState() => _GenresPageState();
}

class _GenresPageState extends State<GenresPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.genre.capitalize()),
          leading: context.canPop()
              ? null
              : IconButton(
                  onPressed: () {
                    context.go('/');
                  },
                  icon: const Icon(Icons.home_rounded)),
        ),
        body: SingleChildScrollView(
          child: ItemsList(
            filter: supabase
                .from('books')
                .select()
                .contains('genres', '{"${widget.genre.toLowerCase()}"}'),
          ),
        ));
  }
}
