import 'package:flutter/material.dart';
import 'package:mybookshelf/pages/subpages/create.dart';
import 'package:mybookshelf/pages/subpages/settings/settings.dart';

class CategoriesPage extends StatelessWidget {
  const CategoriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Categorie"),
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
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return const SettingsPage();
                  }));
                },
              ),
            ],
          )
        ],
      ),
      body: Center(
        child: FilledButton(
          onPressed: () {
            showModalBottomSheet<void>(
              showDragHandle: true,
              context: context,
              constraints: const BoxConstraints(maxWidth: 600),
              builder: (context) {
                return CreateBookPage();
          });},
          child: Text("test"),

      ),
    ));
  }
}
