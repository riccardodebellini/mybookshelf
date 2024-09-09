import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mybookshelf/sys/auth_system.dart';
import 'package:mybookshelf/sys/firebase_options.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Color appColor = Colors.teal;
Brightness appBrightness = Brightness.light;

// RUN APP AND WAIT FOR FIREBASE
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await Supabase.initialize(
    url: 'https://wmztgdkplkomzdwileqx.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6IndtenRnZGtwbGtvbXpkd2lsZXF4Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MjMwMzEzMzMsImV4cCI6MjAzODYwNzMzM30.eWwZMt4qe7JyuUMubB9gCxDQMKnKPGuQp-k1Y1U5NpI',
  );

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    systemNavigationBarContrastEnforced: false,
    statusBarColor: Colors.transparent,
    systemNavigationBarColor: Colors.transparent,
    systemStatusBarContrastEnforced: false,
  ));
  runApp(const MyApp());
}

// APP
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      // Theming
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: appColor,
          brightness: MediaQuery.of(context).platformBrightness,
        ),
      ),
      title: "MyBookshelf",
      home: const AuthSystem(), // Home page
    );
  }
}
