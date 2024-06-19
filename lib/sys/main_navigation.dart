// IMPORT
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../pages/books/books.dart';
import '../pages/categories/categories.dart';
import '../pages/subpages/create.dart';
import '../pages/subpages/search.dart';

// Container
class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _ResponsiveScaffoldState();
}

class _ResponsiveScaffoldState extends State<MainNavigation> {
  // List of Pages
  final pages = [const BooksPage(), const CategoriesPage(), const Placeholder()];

  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return MediaQuery.of(context).size.width > 600
        ? Scaffold(
            body: Row(children: [
            NavigationRail(
              leading: FloatingActionButton(
                heroTag: null,
                onPressed: navigateToAddBook,
                child: const Icon(Icons.add_rounded),
              ),
              selectedIndex: currentIndex,
              labelType: NavigationRailLabelType.all,
              onDestinationSelected: (int index) {
                setState(() {
                  currentIndex = index;
                });
              },
              destinations: const [
                NavigationRailDestination(
                  icon: Icon(Icons.bookmark_rounded),
                  label: Text('Libri'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.interests_rounded),
                  label: Text('Categorie'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.schedule_rounded),
                  label: Text('Prestiti'),
                ),
              ],
            ),
            Expanded(child: pages[currentIndex]),
          ]))
        : Scaffold(
            floatingActionButton: FloatingActionButton.extended(
              heroTag: null,
              label: const Text("Nuovo libro"),
              onPressed: navigateToAddBook,
              icon: const Icon(Icons.add_rounded),
            ),
            body: pages[currentIndex],
            bottomNavigationBar: NavigationBar(
              destinations: const [
                NavigationDestination(
                  icon: Icon(Icons.bookmark_rounded),
                  label: 'Libri',
                ),
                NavigationDestination(
                  icon: Icon(Icons.interests_rounded),
                  label: 'Categorie',
                ),
                NavigationDestination(
                  icon: Icon(Icons.schedule_rounded),
                  label: 'Prestiti',
                ),
              ],
              selectedIndex: currentIndex,
              onDestinationSelected: (int index) {
                setState(() {
                  currentIndex = index;
                });
              },
            ),
          );
  }

  // Aks and navigate to the book adding page
  void navigateToAddBook() {
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
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const CreateBookPage()));
              },
              child: const Text("Crea da zero"),
            ),
            FilledButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const BookSearchPage()));
              },
              child: const Text("Cerca su Google Books"),
            )
          ],
        );
      },
    );
  }

  // Sign OUT
  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }
}
