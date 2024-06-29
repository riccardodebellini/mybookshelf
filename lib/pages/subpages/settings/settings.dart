import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mybookshelf/pages/subpages/settings/subpages/account.dart';
import 'package:mybookshelf/pages/subpages/settings/subpages/creation.dart';
import 'package:mybookshelf/pages/subpages/settings/subpages/sharing.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Impostazioni"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ListTile(
              leading: CircleAvatar(
                child: Text(
                    FirebaseAuth.instance.currentUser!.displayName != null
                        ? FirebaseAuth.instance.currentUser!.displayName
                            .toString()
                            .characters
                            .first
                            .toUpperCase()
                        : FirebaseAuth.instance.currentUser!.email
                            .toString()
                            .characters
                            .first
                            .toUpperCase()),
              ),
              title: Text(
                  "Ciao ${FirebaseAuth.instance.currentUser!.displayName.toString()}"),
              subtitle:
                  Text(FirebaseAuth.instance.currentUser!.email.toString()),
              // leading: CircleAvatar(
              // child: Text(FirebaseAuth.instance.currentUser!.displayName.toString().characters.first.toUpperCase()),
              // ),
            ),
            const Divider(),
            ListTile(
              title: const Text("Account"),
              subtitle: const Text("Nome, password..."),
              leading: const Icon(Icons.key_rounded),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SettingsAccountPage()));
              },
            ),
            ListTile(
              title: const Text("Creazione"),
              subtitle: const Text("Riempimento automatico campi"),
              leading: const Icon(Icons.bookmark_add_rounded),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SettingsCreationPage()));
              },
            ),
            ListTile(
              title: const Text("Condivisione"),
              subtitle: const Text("Riempimento automatico campi"),
              leading: const Icon(Icons.share_rounded),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => SettingsSharingPage()));
              },
            ),
            const ListTile(
              title: Text("Archiviazione"),
              subtitle: Text("Riempimento automatico campi"),
              leading: Icon(Icons.donut_large_rounded),
              onTap: null,
            )
          ],
        ),
      ),
    );
  }
}
// Center(child: Text(user.email!))
