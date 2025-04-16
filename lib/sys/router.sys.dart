import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mybookshelf/pages/books/subpages/details.book.page.dart';
import 'package:mybookshelf/pages/home/subpages/genres.page.dart';
import 'package:mybookshelf/pages/home/subpages/searchresults.page.dart';
import 'package:mybookshelf/pages/lends/subpages/details.lend.page.dart';
import 'package:mybookshelf/pages/playground/playground.page.dart';
import 'package:mybookshelf/pages/subpages/settings/subpages/account.settings.page.dart';
import 'package:mybookshelf/pages/subpages/settings/subpages/creation.settings.page.dart';
import 'package:mybookshelf/sys/shellnavigation.sys.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../main.dart';
import '../pages/books/books.page.dart';
import '../pages/books/subpages/create.book.page.dart';
import '../pages/books/subpages/search.create.book.page.dart';
import '../pages/home/home.page.dart';
import '../pages/lends/lends.page.dart';
import '../pages/lends/subpages/create.lend.page.dart';
import '../pages/subpages/account/login.account.page.dart';
import '../pages/subpages/settings/settings.page.dart';
import '../res/bottomsheet.util.dart';

final supabase = Supabase.instance.client;

class MyBookshelfRouter {
  static final GlobalKey<NavigatorState> _rootNavigatorKey =
      GlobalKey<NavigatorState>();
  static final GlobalKey<NavigatorState> _shellNavigatorKey =
      GlobalKey<NavigatorState>();

  BuildContext context;

  MyBookshelfRouter({required this.context});

  static GoRouter router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/',
    onException: (context, state, router) {
      router.go(
        '/404',
      );
    },
    routes: _routes,
    redirect: (BuildContext context, GoRouterState state) async {
      final bool isLoggedIn = supabase.auth.currentUser != null;
      final bool isLogInOrSignUp = (state.matchedLocation == '/login' ||
          state.matchedLocation == '/signup');

      if (isLoggedIn) {
        if (!isLogInOrSignUp) {
          return null;
        } else {
          return '/';
        }
      }
      if (isLogInOrSignUp) {
        return state.path;
      } else {
        return '/login';
      }
    },
  );

  static final List<RouteBase> _routes = [
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (context, state, child) {
        return ShellNavigation(
            pageData: _pages(context),
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
                      context.push('/settings');
                    },
                  ),
                ],
              ),
            ],
            child: child);
      },
      routes: [
        // This screen is displayed on the ShellRoute's Navigator.
        GoRoute(
          path: '/',
          builder: (context, state) {
            return HomePage(
              key: homePageKey,
            );
          },
        ),
        // Displayed ShellRoute's Navigator.
        GoRoute(
          path: '/books',
          builder: (BuildContext context, GoRouterState state) {
            return BooksPage(
              key: booksPageKey,
            );
          },
        ),
        GoRoute(
          path: '/lends',
          builder: (BuildContext context, GoRouterState state) {
            return LendsPage(
              key: lendsPageKey,
            );
          },
        ),
        GoRoute(
          path: '/playground',
          builder: (BuildContext context, GoRouterState state) {
            return const PlaygroundPage();
          },
        ),
      ],
    ),
    GoRoute(
      path: '/settings',
      builder: (BuildContext context, GoRouterState state) {
        return const SettingsPage();
      },
    ),
    GoRoute(
      path: '/login',
      builder: (BuildContext context, GoRouterState state) {
        return const AccountLogInPage();
      },
    ),
    GoRoute(
      path: '/books/genres/:genre',
      builder: (BuildContext context, GoRouterState state) {
        return GenresPage(genre: state.pathParameters["genre"].toString());
      },
    ),
    GoRoute(
      path: '/search',
      builder: (BuildContext context, GoRouterState state) {
        return SearchResultsPage(
            input: state.uri.queryParameters["q"].toString());
      },
    ),
    GoRoute(
        path: '/settings',
        builder: (BuildContext context, GoRouterState state) {
          return const SettingsPage();
        },
        routes: [
          GoRoute(
            path: '/account',
            builder: (BuildContext context, GoRouterState state) {
              return const SettingsAccountPage();
            },
          ),
          GoRoute(
            path: '/creation',
            builder: (BuildContext context, GoRouterState state) {
              return const SettingsCreationPage();
            },
          )
        ]),
    GoRoute(
      path: '/404',
      builder: (BuildContext context, GoRouterState state) {
        return const Scaffold(
          body: Center(
            child: Text('404 - Not found'),
          ),
        );
      },
    ),
    GoRoute(
      path: '/400',
      builder: (BuildContext context, GoRouterState state) {
        return const Scaffold(
          body: Center(
            child: Text('400 - Parametri mancanti'),
          ),
        );
      },
    ),
    GoRoute(
      path: '/lends/details/:id',
      redirect: (context, state) {
        if ((state.extra) is Map) {
          return null;
        }
        return '/400';
      },
      builder: (BuildContext context, GoRouterState state) {
        return LendDetails(book: (state.extra as Map));
      },
    ),
    GoRoute(
      path: '/books/details/:id',
      redirect: (context, state) {
        if ((state.extra) is Map) {
          return null;
        }
        return '/400';
      },
      builder: (BuildContext context, GoRouterState state) {
        return BooksDetails(book: (state.extra as Map));
      },
    )
  ];

  static List<ShellNavigationDest> _pages(BuildContext context) {
    return [
          ShellNavigationDest(
              appBarTitle: const Text("Home"),
              text: 'Home',
              icon: const Icon(Icons.home_rounded),
              route: '/',
              fab: ShellNavigationFAB(
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
          ShellNavigationDest(
              appBarTitle: const Text("Libri"),
              text: 'Libri',
              icon: const Icon(Icons.bookmark_rounded),
              route: '/books',
              fab: ShellNavigationFAB(
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
          ShellNavigationDest(
              appBarTitle: const Text("Prestiti"),
              text: 'Prestiti',
              icon: const Icon(Icons.schedule_rounded),
              route: '/lends',
              fab: ShellNavigationFAB(
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
                const ShellNavigationDest(
                    appBarTitle: Text("Playground"),
                    text: "Playground",
                    icon: Icon(Icons.bug_report_rounded),
                    route: '/playground')
              ]
            : []);
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

              showAdaptiveSheet(context, child: const CreateBookPage());
            },
            child: const Text("Crea da zero"),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              showAdaptiveSheet(context, child: const BookSearchPage());
            },
            child: const Text("Cerca su Google Books"),
          )
        ],
      );
    },
  );
}

void navigateToAddLend(context) {
  showAdaptiveSheet(context, child: const CreateLendPage());
}
