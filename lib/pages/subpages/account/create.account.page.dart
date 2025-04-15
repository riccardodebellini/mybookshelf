// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = Supabase.instance.client;

class AccountAccountCreatePageLARGE extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController nameController;
  final MainAxisAlignment align;
  final VoidCallback onSubmit;
  final VoidCallback onGoBack;

  const AccountAccountCreatePageLARGE(
      {super.key,
      required this.emailController,
      required this.passwordController,
      required this.nameController,
      required this.onSubmit,
      required this.onGoBack,
      required this.align});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: align,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.menu_book_rounded,
                    size: 50,
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Text(
                    "Crea",
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Text(
                    "Crea il tuo Account MyBookshelf",
                    style: Theme.of(context).textTheme.titleMedium,
                  )
                ],
              ),
            ),
            const SizedBox(
              width: 32,
            ),
            Expanded(
              child: AutofillGroup(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    TextField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      autofillHints: const [AutofillHints.email],
                      obscureText: false,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Indirizzo email',
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    TextField(
                      controller: nameController,
                      keyboardType: TextInputType.name,
                      obscureText: false,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Nome',
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    TextField(
                      controller: passwordController,
                      keyboardType: TextInputType.visiblePassword,
                      autofillHints: const [AutofillHints.newPassword],
                      obscureText: true,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Password',
                          helperText:
                              "Minimo 6 caratteri, una maiuscola, una minuscola e un numero",
                          helperMaxLines: 3),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                            onPressed: onGoBack, child: const Text("Indietro")),
                        const SizedBox(
                          width: 8,
                        ),
                        FilledButton(
                            onPressed: onSubmit, child: const Text("Crea")),
                      ],
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class AccountAccountCreatePageSMALL extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController nameController;
  final MainAxisAlignment align;
  final VoidCallback onSubmit;
  final VoidCallback onGoBack;

  const AccountAccountCreatePageSMALL(
      {super.key,
      required this.emailController,
      required this.passwordController,
      required this.nameController,
      required this.onSubmit,
      required this.onGoBack,
      required this.align});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.menu_book_rounded,
              size: 50,
              color: Theme.of(context).colorScheme.onPrimaryContainer,
            ),
            const SizedBox(
              height: 16,
            ),
            Text(
              "Crea",
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            const SizedBox(
              height: 8,
            ),
            Text(
              "Crea il tuo Account MyBookshelf",
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(
              height: 32,
            ),
            TextField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              autofillHints: const [AutofillHints.email],
              obscureText: false,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Indirizzo email',
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            TextField(
              controller: nameController,
              keyboardType: TextInputType.name,
              obscureText: false,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Nome',
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            TextField(
              controller: passwordController,
              keyboardType: TextInputType.visiblePassword,
              autofillHints: const [AutofillHints.newPassword],
              obscureText: true,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Password',
                  helperText:
                      "Minimo 6 caratteri, una maiuscola, una minuscola e un numero",
                  helperMaxLines: 3),
            ),
            const SizedBox(
              height: 16,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(onPressed: onGoBack, child: const Text("Indietro")),
                const SizedBox(
                  width: 8,
                ),
                FilledButton(onPressed: onSubmit, child: const Text("Crea")),
              ],
            )
          ],
        ),
      ),
    );
  }
}

// LOGIN logic and system
class AccountCreatePage extends StatefulWidget {
  const AccountCreatePage({
    super.key,
  });

  @override
  State<AccountCreatePage> createState() => _AccountCreatePageState();
}

class _AccountCreatePageState extends State<AccountCreatePage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();

  void backToLogin() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: ListView(
        shrinkWrap: true,
        children: [
          MediaQuery.of(context).size.width > 840
              ? Center(
                  child: SizedBox(
                    height: 350,
                    width: 840,
                    child: Card.filled(
                      child: AccountAccountCreatePageLARGE(
                        emailController: emailController,
                        passwordController: passwordController,
                        nameController: nameController,
                        onGoBack: backToLogin,
                        onSubmit: createUser,
                        align: MainAxisAlignment.start,
                      ),
                    ),
                  ),
                )
              : MediaQuery.of(context).size.width > 600
                  ? AccountAccountCreatePageLARGE(
                      emailController: emailController,
                      passwordController: passwordController,
                      nameController: nameController,
                      onGoBack: backToLogin,
                      onSubmit: createUser,
                      align: MainAxisAlignment.center,
                    )
                  : AccountAccountCreatePageSMALL(
                      emailController: emailController,
                      passwordController: passwordController,
                      nameController: nameController,
                      onGoBack: backToLogin,
                      onSubmit: createUser,
                      align: MainAxisAlignment.start,
                    )
        ],
      ),
    ));
  }

  void createUser() async {
    // show loading circle
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    // try sign in
    try {
      await supabase.auth.signUp(
        password: passwordController.text,
        email: emailController.text,
        data: {'name': nameController.text},
      );

      await supabase.auth.signInWithPassword(
        password: passwordController.text,
        email: emailController.text,
      );

      await supabase
          .from("profile")
          .upsert({'user_id': supabase.auth.currentUser!.id});

      // pop the loading circle
      Navigator.pop(context);
      Navigator.pop(context);
      TextInput.finishAutofillContext;
    } catch (e) {
      // pop the loading circle

      Navigator.pop(context);
      // WRONG EMAIL or PASSWORD
      errorMessage(e.toString());
    }
  }

  // wrong email message popup
  void errorMessage(String error) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'Errore:',
          ),
          icon: const Icon(Icons.error_rounded),
          content:
              Text("$error\nL'account esiste già o la password è poco sicura"),
        );
      },
    );
  }
}
