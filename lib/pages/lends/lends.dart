import 'package:flutter/material.dart';
import 'package:mybookshelf/res/filters.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = Supabase.instance.client;

GlobalKey<LendsPageState> lendsPageKey = GlobalKey();

class LendsPage extends StatefulWidget {
  const LendsPage({required Key key}) : super(key: key);

  @override
  State<LendsPage> createState() => LendsPageState();
}

class LendsPageState extends State<LendsPage> {
  PostgrestFilterBuilder<List<Map<String, dynamic>>>? lends;

  loadBooks() async {
    final lendList = supabase.from('lends').select();

    setState(() {
      lends = lendList as PostgrestFilterBuilder<List<Map<String, dynamic>>>?;
    });
  }

  final GlobalKey<RefreshIndicatorState> isReloading =
      GlobalKey<RefreshIndicatorState>();

  reloadAll() {
    setState(() {
      isReloading.currentState?.show();
    });
  }

  @override
  void initState() {
    super.initState();
    loadBooks();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
        onRefresh: () async {
          await loadBooks();
        },
        key: isReloading,
        child: ListView(children: [FilteredView(filter: lends!)]));
  }
}
