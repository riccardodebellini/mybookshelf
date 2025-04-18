import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:mytomes/main.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

final supabase = Supabase.instance.client;

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: context.canPop()
            ? null
            : IconButton(
                onPressed: () {
                  context.go('/');
                },
                icon: const Icon(Icons.home_rounded)),
        title: const Text("Impostazioni"),
        centerTitle: false,
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
                  context.push('/settings/account');
                },
              ),
              ListTile(
                title: const Text("Creazione"),
                subtitle: const Text("Riempimento automatico campi"),
                leading: const Icon(Icons.bookmark_add_rounded),
                onTap: () {
                  context.push('/settings/creation');
                },
              ),
              ListTile(
                title: const Text("Info"),
                subtitle: const Text("Licenze e versione"),
                leading: const Icon(Icons.info_outline_rounded),
                onTap: () {
                  showAboutDialog(
                      context: context,
                      applicationName: "MyTomes",
                      applicationVersion: (isTestVersion
                          ? "Versione di test ($appVersion-test)"
                          : appVersion),
                      applicationIcon: const CircleAvatar(child: Text("My")),
                      applicationLegalese:
                          "(c) Riccardo Debellini - 2024\nLicense at github.com/riccardodebellini/mytomes");
                },
              ),
              ListTile(
                title: const Text("Condividi"),
                subtitle: const Text("Condividi il link a MyTomes"),
                leading: const Icon(Icons.share_rounded),
                onTap: () {
                  Clipboard.setData(const ClipboardData(
                      text: "https://riccardodebellini.github.io/mytomes/"));
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text("Link copiato negli appunti"),
                    behavior: SnackBarBehavior.floating,
                  ));
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
          title: const Text("Creato con il 💙 da Riccardo Debellini"),
          onTap: () {
            launchUrl(Uri.parse('https://riccardodebellini.github.io'));
          },
        )
      ]),
    );
  }
}
// Center(child: Text(user.email!))
