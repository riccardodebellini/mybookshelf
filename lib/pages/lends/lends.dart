import 'package:flutter/material.dart';
import 'package:mybookshelf/pages/subpages/settings/settings.dart';

class LendsPage extends StatelessWidget {
  const LendsPage({super.key});

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
        body: const Center(
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
        )));
  }
}
