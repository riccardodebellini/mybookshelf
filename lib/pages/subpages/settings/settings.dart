import 'package:flutter/material.dart';
import 'package:mybookshelf/pages/subpages/settings/subpages/account.dart';
import 'package:mybookshelf/pages/subpages/settings/subpages/creation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

final supabase = Supabase.instance.client;

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Impostazioni"),
        centerTitle: true,
      ),
      body: Column(children: [
        Expanded(
          child: ListView(
            children: [
              ListTile(
                leading: CircleAvatar(
                    child: Text(supabase.auth.currentUser!.userMetadata!['name']
                        .toString()
                        .characters
                        .first
                        .toUpperCase())),
                title: Text(
                    supabase.auth.currentUser!.userMetadata!['name'] ?? "User")

                /* FutureBuilder(
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final userName = snapshot.data![0]["display_name"];
                      if (userName != null) {
                        return Text("Ciao ${userName.toString()}");
                      }
                    }
          
                    return Text("Ciao Utente");
                  },
                  future: supabase.from("profile").select(),
                ),*/
                ,
                subtitle: Text(supabase.auth.currentUser!.email.toString()),
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

              /*ListTile(
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
              )*/
            ],
          ),
        ),
        ListTile(
          title: Text("Creato con il 💙 da Riccardo Debellini"),
          onTap: () {
            launchUrl(Uri.parse('https://riccardodebellini.github.io'));
          },
        )
      ]),
    );
  }
}
// Center(child: Text(user.email!))
