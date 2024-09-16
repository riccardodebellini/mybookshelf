import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';

import '../res/windowbuttons.dart';
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

class Navigation extends StatelessWidget {
  const Navigation({super.key});

  @override
  Widget build(BuildContext context) {
    return AuthSystem(
      userLogged: MainNavigation(
        pageData: [
          MainNavigationDest(
              appBarTitle: const Text("Home"),
              text: 'Home',
              icon: const Icon(Icons.interests_rounded),
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
                      homePageKey.currentState?.reloadAll();
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
                Expanded(child: MoveWindow(),),
                IconButton(
                    onPressed: () {
                      booksPageKey.currentState?.reloadAll();
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
                      lendsPageKey.currentState?.reloadAll();
                    },
                    icon: const Icon(Icons.cloud_sync_rounded))
              ]),
        ],
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
          ButtonsCard(),
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

              showModalBottomSheet(
                  showDragHandle: true,
                  constraints: BoxConstraints(
                    maxWidth: 600,
                    maxHeight: MediaQuery
                        .of(context)
                        .size
                        .height * 0.7,
                  ),
                  context: context,
                  builder: (context) {
                    return Padding(
                      padding: EdgeInsets.only(
                          bottom: MediaQuery
                              .of(context)
                              .viewInsets
                              .bottom),
                      child: const CreateBookPage(),
                    );
                  });
            },
            child: const Text("Crea da zero"),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              showModalBottomSheet<void>(
                  constraints: BoxConstraints(
                    maxWidth: 600,
                    maxHeight: MediaQuery
                        .of(context)
                        .size
                        .height * 0.7,
                  ),
                  useSafeArea: true,
                  showDragHandle: true,
                  context: context,
                  builder: (context) {
                    return Padding(
                        padding: EdgeInsets.only(
                            bottom: MediaQuery
                                .of(context)
                                .viewInsets
                                .bottom),
                        child: const BookSearchPage());
                  });
            },
            child: const Text("Cerca su Google Books"),
          )
        ],
      );
    },
  );
}

void navigateToAddLend(context) {
  showModalBottomSheet(
      showDragHandle: true,
      constraints: BoxConstraints(
        maxWidth: 600,
        maxHeight: MediaQuery
            .of(context)
            .size
            .height * 0.7,
      ),
      context: context,
      builder: (context) {
        return Padding(
          padding:
          EdgeInsets.only(bottom: MediaQuery
              .of(context)
              .viewInsets
              .bottom),
          child: const CreateLendPage(),
        );
      });
}