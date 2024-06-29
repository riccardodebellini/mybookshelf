import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../pages/subpages/account/login.dart';
import 'main_navigation.dart';

class AuthSystem extends StatelessWidget {
  const AuthSystem({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Scaffold(
        body: StreamBuilder<User?>(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return const MainNavigation();
              } else {
                return const AccountLogInPage();
              }
            }),
      ),
    );
  }
}
