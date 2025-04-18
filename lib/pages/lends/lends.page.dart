import 'package:flutter/material.dart';
import 'package:mytomes/res/itemlist.res.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = Supabase.instance.client;

GlobalKey<LendsPageState> lendsPageKey = GlobalKey();

class LendsPage extends StatefulWidget {
  const LendsPage({required Key key}) : super(key: key);

  @override
  State<LendsPage> createState() => LendsPageState();
}

class LendsPageState extends State<LendsPage> {
  final GlobalKey<RefreshIndicatorState> isReloading =
      GlobalKey<RefreshIndicatorState>();

  reload() {
    setState(() {
      isReloading.currentState?.show();
    });
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
        onRefresh: () async {},
        key: isReloading,
        child: ListView(children: [
          ItemsList(
            filter:
                supabase.from('lends').select().order('due', ascending: true),
            isLend: true,
          )
        ]));
  }
}
