// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 32,
              child: Text(FirebaseAuth.instance.currentUser!.displayName != null
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
            const SizedBox(
              height: 16,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Ciao",
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
                Text(
                  " ${FirebaseAuth.instance.currentUser!.displayName.toString()}",
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
              FirebaseAuth.instance.currentUser!.email.toString(),
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(
              height: 16,
            ),
            const Divider(),
            ListTile(
              title: const Text("Cambia il nome visualizzato"),
              leading: const Icon(Icons.drive_file_rename_outline_rounded),
              trailing: FilledButton.tonal(
                onPressed: editName,
                child: const Text("Cambia"),
              ),
            ),
            ListTile(
              title: const Text("Cambia password"),
              leading: const Icon(Icons.password_rounded),
              trailing: FilledButton.tonal(
                onPressed: editPassword,
                child: const Text("Cambia"),
              ),
            ),
            ListTile(
              title: const Text("Effettua il logout"),
              leading: const Icon(Icons.logout_rounded),
              trailing: FilledButton.tonal(
                child: const Text("Esci"),
                onPressed: () {
                  FirebaseAuth.instance.signOut();
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
              ),
            ),
            const Divider(),
            const ListTile(
              title: Text("Azioni pericolose"),
            ),
            ListTile(
                title: const Text("Elimina il mio Account"),
                leading: const Icon(Icons.dangerous_rounded),
                trailing: ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          behavior: SnackBarBehavior.floating,
                          dismissDirection: DismissDirection.startToEnd,
                          content: Text('Funzione non abilitata')),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.error,
                  ),
                  child: Text(
                    'ELIMINA',
                    style:
                        TextStyle(color: Theme.of(context).colorScheme.onError),
                  ),
                )),
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
                    hintText:
                        FirebaseAuth.instance.currentUser!.displayName ?? "",
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
                        await FirebaseAuth.instance.currentUser
                            ?.updateDisplayName(newNameController.text);

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
                      } on FirebaseAuthException {
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Errore'),
                            clipBehavior: Clip.hardEdge,
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
          title: const Text("Cambia password"),
          content: const Text(
              "Per reimpostare la password, ti invieremo un'email all'indirizzo indicato al momento della registrazione"),
          actions: [
            FilledButton(
                onPressed: () {
                  FirebaseAuth.instance.sendPasswordResetEmail(
                      email: FirebaseAuth.instance.currentUser!.email!);
                  Navigator.of(context).pop();
                },
                child: const Text("Procedi"))
          ],
        );
      },
    );
  }

void signUserOut() {
    FirebaseAuth.instance.signOut();
  }
}
// Center(child: Text(user.email!))
