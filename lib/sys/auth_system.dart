import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../pages/subpages/account/login.dart';
import 'main_navigation.dart';

class AuthSystem extends StatelessWidget {
  const AuthSystem({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<AuthState?>(
        stream: Supabase.instance.client.auth.onAuthStateChange,
        builder: (context, snapshot) {
          if (snapshot.data?.session?.user.id != null) {
            // User is authenticated
            return const MainNavigation();
          } else {
            // User is not authenticated
            return const AccountLogInPage();
          }
        },
      ),
    );
  }
}