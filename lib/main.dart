import 'dart:async';
import 'dart:io';

import 'package:app_links/app_links.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mytomes/sys/notifications.dart';
import 'package:mytomes/sys/router.sys.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = Supabase.instance.client;

// Quick settings
Color appColor = Colors.blue;
Brightness appBrightness = Brightness.light;
bool isTestVersion = false;
String appVersion = "1.0.0-Beta";
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
    MyTomesRouter.router.refresh();
  });

  GoRouter.optionURLReflectsImperativeAPIs = true;

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _appLinks = AppLinks();
  StreamSubscription<Uri>? _linkSubscription;

  @override
  void initState() {
    super.initState();
    !kIsWeb ? initDeepLinks() : null;
  }

  @override
  void dispose() {
    _linkSubscription?.cancel();
    super.dispose();
  }

  Future<void> initDeepLinks() async {
    // --- Get initial link (when app starts from a link) ---

    try {
      final initialUri = await _appLinks.getInitialLink();
      if (initialUri != null) {
        print('Got initial link: $initialUri');
        _handleLink(initialUri);
      }
    } catch (e) {
      // Handle exception (e.g., log it)
      print('Error getting initial link: $e');
    }

    // --- Listen for further links (when app is already running) ---
    _linkSubscription = _appLinks.uriLinkStream.listen((uri) {
      print('Got link while running: $uri');
      _handleLink(uri);
    }, onError: (err) {
      // Handle stream errors (e.g., log it)
      print('Error listening to links: $err');
    });
  }

  /// Concise link handler using go_router
  void _handleLink(Uri uri) {
    // Directly try to navigate using the path and query from the URI.
    // This assumes your go_router routes match the path structure of your links
    // (after the scheme and host).
    // Example: uri = myapp://product/123?ref=home
    // We want to navigate to /product/123?ref=home in go_router
    final String path = uri.path; // Gets '/product/123'
    final String query =
        uri.hasQuery ? '?${uri.query}' : ''; // Gets '?ref=home'
    final String location =
        '$path$query'; // Combines to '/product/123?ref=home'

    print('Attempting to navigate to: $location');
    try {
      MyTomesRouter.router
          .go(location); // Use go() to clear the stack or push() to add on top
    } catch (e) {
      print('Error navigating with go_router: $e');
      // Optional: Navigate to an error page or home page if the route fails
      // _router.go('/');
    }
  }

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
      title: "MyTomes",
      routerConfig: MyTomesRouter.router, // Home page
    );
  }
}
