import 'dart:io';

import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mybookshelf/sys/notifications.dart';
import 'package:mybookshelf/sys/router.sys.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


final supabase = Supabase.instance.client;

// Quick settings
Color appColor = Colors.blue;
Brightness appBrightness = Brightness.light;
bool isTestVersion = true;
String appVersion = "0.3";
//Run
void main() async {
  //Supabase init
  await Supabase.initialize(
    url: 'https://wmztgdkplkomzdwileqx.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6IndtenRnZGtwbGtvbXpkd2lsZXF4Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MjMwMzEzMzMsImV4cCI6MjAzODYwNzMzM30.eWwZMt4qe7JyuUMubB9gCxDQMKnKPGuQp-k1Y1U5NpI',
  );

  // Android EtE config.
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    systemNavigationBarContrastEnforced: false,
    statusBarColor: Colors.transparent,
    systemNavigationBarColor: Colors.transparent,
    systemStatusBarContrastEnforced: false,
  ));

  if (!kIsWeb) {
    // Windows window SetUp
    if (Platform.isWindows) {
      doWhenWindowReady(() {
        appWindow.minSize = const Size(400, 400);
      });
    }

    // Android nofications init
    if (Platform.isAndroid) {
      NotificationService.init();
    }
  }

  supabase.auth.onAuthStateChange.listen((state) {
    MyBookshelfRouter.router.refresh();
  });

  GoRouter.optionURLReflectsImperativeAPIs = true;

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('it'),
      ],
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
      routerConfig: MyBookshelfRouter.router, // Home page
    );
  }
}
