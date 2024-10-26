import 'dart:io';

import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mybookshelf/pages/navigation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Color appColor = Colors.grey;
Brightness appBrightness = Brightness.light;

// RUN APP AND WAIT FOR FIREBASE
void main() async {
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
  if (!kIsWeb && Platform.isWindows) {
    doWhenWindowReady(() {
      appWindow.minSize = const Size(400, 400);
    });
  }
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
        fontFamily: GoogleFonts.ibmPlexSans().fontFamily,
        textTheme:
            const TextTheme(titleLarge: TextStyle(fontWeight: FontWeight.bold)),
        useMaterial3: true,
        filledButtonTheme: FilledButtonThemeData(
            style: ButtonStyle(
                textStyle: WidgetStatePropertyAll(TextStyle(
          fontWeight: FontWeight.bold,
          fontFamily: GoogleFonts.ibmPlexSans().fontFamily,
        )))),
        colorScheme: ColorScheme.fromSeed(
          seedColor: appColor,
          brightness: MediaQuery.of(context).platformBrightness,
        ),
      ),
      title: "MyBookshelf",
      home: const Navigation(), // Home page
    );
  }
}
