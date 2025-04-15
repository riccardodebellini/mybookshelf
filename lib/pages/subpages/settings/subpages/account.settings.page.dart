// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = Supabase.instance.client;

class SettingsAccountPage extends StatefulWidget {
  const SettingsAccountPage({super.key});

  @override
  State<SettingsAccountPage> createState() => _SettingsAccountPageState();
}

class _SettingsAccountPageState extends State<SettingsAccountPage> {
  // Function to validate password (optional)

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Account"),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 32,
              child: Text(supabase.auth.currentUser!.userMetadata!['name']
                  .toString()
                  .characters
                  .first
                  .toUpperCase()),
            ),
            const SizedBox(
              height: 16,
            ),
            Wrap(
              children: [
                Text(
                  "Ciao",
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
                Text(
                  " ${supabase.auth.currentUser!.userMetadata!['name'] ?? " User"}",
                  style: Theme.of(context)
                      .textTheme
                      .headlineLarge!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(
              height: 16,
            ),
            Text(
              supabase.auth.currentUser!.email.toString(),
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(
              height: 16,
            ),
            const Divider(),
            ListTile(
              title: Card.filled(
                child: Column(
                  children: [
                    ListTile(
                      title: const Text("Cambia il nome visualizzato"),
                      leading:
                          const Icon(Icons.drive_file_rename_outline_rounded),
                      trailing: TextButton(
                        onPressed: editName,
                        child: const Text("Cambia"),
                      ),
                    ),
                    ListTile(
                      title: const Text("Cambia password"),
                      leading: const Icon(Icons.password_rounded),
                      trailing: TextButton(
                        onPressed: editPassword,
                        child: const Text("Cambia"),
                      ),
                    ),
                    ListTile(
                      title: const Text("Effettua il logout"),
                      leading: const Icon(Icons.logout_rounded),
                      trailing: FilledButton(
                        child: const Text("Esci"),
                        onPressed: () {
                          supabase.auth.signOut();

                          Navigator.pop(context);
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            ListTile(
              title: Card.filled(
                child: Column(
                  children: [
                    const ListTile(
                      title: Text("Azioni pericolose"),
                    ),
                    ListTile(
                        title: const Text("Elimina il mio Account"),
                        leading: const Icon(Icons.dangerous_rounded),
                        trailing: ElevatedButton(
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: const Text(
                                        "Funzione in app non abilitata"),
                                    content: const Text(
                                        "Per eliminare l'account, invia una richiesta via e-mail a 'riccardo.debellini@gmail.com'"),
                                    actions: [
                                      TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: const Text("Ok"))
                                    ],
                                  );
                                });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                Theme.of(context).colorScheme.error,
                          ),
                          child: Text(
                            'ELIMINA',
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.onError),
                          ),
                        )),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void editName() async {
    final newNameController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        String? error;
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              icon: const Icon(Icons.drive_file_rename_outline_rounded),
              title: const Text("Inserisci il nuovo nome"),
              content: TextField(
                controller: newNameController,
                decoration: InputDecoration(
                    label: const Text("Nome"),
                    hintText: "Mario Rossi",
                    border: const OutlineInputBorder(),
                    errorText: error),
              ),
              actions: <Widget>[
                FilledButton(
                  onPressed: () async {
                    setState(() {
                      newNameController.text == ""
                          ? error = "Inserisci un nome"
                          : error = null;
                    });

                    if (error == null) {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        },
                      );
                      try {
                        await supabase.auth.updateUser(UserAttributes(
                          data: {'name': newNameController.text},
                        ));
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();

                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const SettingsAccountPage()));

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              behavior: SnackBarBehavior.floating,
                              dismissDirection: DismissDirection.startToEnd,
                              content: Text('Nome cambiato con successo')),
                        );
                      } catch (e) {
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Errore - ${e.toString()}'),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      }
                    }
                  },
                  child: const Text("Cambia"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void editPassword() async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Funzione in app non abilitata"),
          content: const Text(
              "Per cambiare la password, invia una richiesta via e-mail a 'riccardo.debellini@gmail.com' dall'indirizzo usato per la registrazione.\n\nSappiamo che è noioso.\nStiamo lavorando a un nuovo sistema di password reset in-app, che dovrebbe arrivare con la prossima versione"),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Ok"))
          ],
        );
      },
    );
  }

}
// Center(child: Text(user.email!))
