import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:mybookshelf/main.dart';
import 'package:mybookshelf/pages/playground/playground.page.dart';
import 'package:mybookshelf/res/bottomsheet.util.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../sys/auth_system.dart';
import '../sys/material_main_navigation.dart';
import 'books/books.dart';
import 'books/subpages/create.dart';
import 'books/subpages/search.dart';
import 'home/home.dart';
import 'lends/lends.dart';
import 'lends/subpages/create.dart';
import 'subpages/account/login.dart';
import 'subpages/settings/settings.dart';

final supabase = Supabase.instance.client;

class Navigation extends StatefulWidget {
  const Navigation({super.key});

  @override
  State<Navigation> createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  @override
  void initState() {
    super.initState();

    supabase.auth.onAuthStateChange.listen((event) async {
      if (event.event == AuthChangeEvent.signedIn &&
          !kIsWeb &&
          Platform.isAndroid) {
        FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
            FlutterLocalNotificationsPlugin();
        flutterLocalNotificationsPlugin
            .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin>()
            ?.requestNotificationsPermission();
        await Permission.scheduleExactAlarm.request();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AuthSystem(
      userLogged: MainNavigation(
        pageData: [
          MainNavigationDest(
              appBarTitle: const Text("Home"),
              text: 'Home',
                  icon: const Icon(Icons.home_rounded),
                  destination: HomePage(
                key: homePageKey,
              ),
              fab: MainNavigationFAB(
                  icon: const Icon(Icons.bookmark_add_rounded),
                  label: "Nuovo libro",
                  onPressed: () {
                    navigateToAddBook(context);
                  }),
              appBarActions: [
                IconButton(
                    onPressed: () {
                          homePageKey.currentState?.reload();
                        },
                    icon: const Icon(Icons.cloud_sync_rounded))
              ]),
          MainNavigationDest(
              appBarTitle: const Text("Libri"),
              text: 'Libri',
              icon: const Icon(Icons.bookmark_rounded),
              destination: BooksPage(
                key: booksPageKey,
              ),
              fab: MainNavigationFAB(
                  icon: const Icon(Icons.bookmark_add_rounded),
                  label: "Nuovo libro",
                  onPressed: () {
                    navigateToAddBook(context);
                  }),
              appBarActions: [
                IconButton(
                    onPressed: () {
                          booksPageKey.currentState?.reload();
                        },
                    icon: const Icon(Icons.cloud_sync_rounded))
              ]),
          MainNavigationDest(
              appBarTitle: const Text("Prestiti"),
              text: 'Prestiti',
              icon: const Icon(Icons.schedule_rounded),
              destination: LendsPage(
                key: lendsPageKey,
              ),
              fab: MainNavigationFAB(
                  icon: const Icon(Icons.notification_add_rounded),
                  label: "Nuovo prestito",
                  onPressed: () {
                    navigateToAddLend(context);
                  }),
              appBarActions: [
                IconButton(
                    onPressed: () {
                          lendsPageKey.currentState?.reload();
                        },
                    icon: const Icon(Icons.cloud_sync_rounded))
              ]),
            ] +
            (isTestVersion
                ? [
                    const MainNavigationDest(
                        appBarTitle: Text("Playground"),
                        text: "Playground",
                        icon: Icon(Icons.bug_report_rounded),
                        destination: PlaygroundPage())
                  ]
                : []),
        fixedActions: [
          MenuAnchor(
            builder: (context, controller, child) {
              return IconButton(
                onPressed: () {
                  if (controller.isOpen) {
                    controller.close();
                  } else {
                    controller.open();
                  }
                },
                icon: const Icon(Icons.more_vert),
              );
            },
            menuChildren: [
              MenuItemButton(
                child: const Text('Impostazioni'),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return const SettingsPage();
                  }));
                },
              ),
            ],
          ),
        ],
      ),
      userNotLogged: const AccountLogInPage(),
    );
  }
}

void navigateToAddBook(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text(
          'Crea nuovo libro:',
        ),
        icon: const Icon(Icons.add_rounded),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);

              showAdaptiveSheet(context, child: CreateBookPage());
            },
            child: const Text("Crea da zero"),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              showAdaptiveSheet(context, child: BookSearchPage());
            },
            child: const Text("Cerca su Google Books"),
          )
        ],
      );
    },
  );
}

void navigateToAddLend(context) {
  showAdaptiveSheet(context, child: CreateLendPage());
}
