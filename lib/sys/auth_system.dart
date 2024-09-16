import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


class AuthSystem extends StatelessWidget {
  final Widget userLogged;
  final Widget userNotLogged;

  const AuthSystem(
      {super.key, required this.userLogged, required this.userNotLogged});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<AuthState?>(
        stream: Supabase.instance.client.auth.onAuthStateChange,
        builder: (context, snapshot) {
          if (snapshot.data?.session?.user.id != null) {
            // User is authenticated
            return userLogged;
          } else {
            // User is not authenticated
            return userNotLogged;
          }
        },
      ),
    );
  }
}