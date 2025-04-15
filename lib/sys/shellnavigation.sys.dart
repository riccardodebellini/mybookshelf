import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// --- Data Structures ---

class ShellNavigationDest {
  /// The text displayed in the NavBar or in the NavRail
  final String text;

  /// The icon displayed in the NavBar or in the NavRail
  final Icon icon;

  /// The unique route path for this destination (e.g., '/home', '/settings').
  /// This is used by GoRouter to navigate to the correct page.
  /// Must start with '/'.
  final String route;

  /// The title of the appbar of the page this ShellNavigationDest points to
  final Widget appBarTitle;

  /// The actions displayed in the AppBar, relative only to the page this ShellNavigationDest points to
  final List<Widget>? appBarActions;

  /// Wether to center the title in the AppBar or not
  final bool? centerTitle;

  /// The FAB displayed in the NavBar or in the NavRail when this page is selected
  final ShellNavigationFAB? fab;

  const ShellNavigationDest({
    required this.route,
    this.fab,
    required this.appBarTitle,
    this.appBarActions = const [],
    this.centerTitle,
    required this.text,
    required this.icon,
  });
}

class ShellNavigationFAB {
  ///The callback that is called when the button is tapped or otherwise activated.
  ///
  /// If this is set to null, the button will be disabled.
  final void Function()? onPressed;

  /// The Icon displayed on the FAB
  final Icon icon;

  /// The text displayed on the FAB (used in extended FAB for portrait mode)
  final String label;

  const ShellNavigationFAB({
    this.onPressed,
    required this.icon,
    required this.label,
  });
}

// --- Navigation Shell Widget ---

/// This widget acts as the shell for the main navigation structure (Scaffold, AppBar, Nav Elements).
/// It builds different Scaffold layouts based on screen size and integrates with GoRouter.
/// It's intended to be used within a GoRouter ShellRoute.
class ShellNavigation extends StatelessWidget {
  /// The child widget (the current page content) provided by GoRouter based on the active route.
  final Widget child;

  /// The list of navigation destinations data.
  final List<ShellNavigationDest> pageData;

  /// Actions always displayed in the AppBar, appended after page-specific actions.
  final List<Widget>? fixedActions;

  /// The screen width breakpoint for switching between portrait (NavigationBar) and landscape (NavigationRail).
  final int smallBreakpoint;

  const ShellNavigation({
    super.key,
    required this.child,
    required this.pageData,
    this.fixedActions = const [],
    this.smallBreakpoint = 600,
  });

  // Helper method to find the index of the current route based on GoRouter state
  int _calculateSelectedIndex(BuildContext context) {
    // Use GoRouterState.of(context) for robustness inside ShellRoute builder context
    final String location = GoRouterState.of(context).uri.toString();
    final int index = pageData.indexWhere((page) => location == page.route);
    // Default to 0 if no match is found
    return index < 0 ? 0 : index;
  }

  // Helper method to navigate using GoRouter when a destination is selected
  void _onDestinationSelected(int index, BuildContext context) {
    if (index >= 0 && index < pageData.length) {
      // Use context.go for navigation within the GoRouter context
      context.go(pageData[index].route);
    }
  }

  @override
  Widget build(BuildContext context) {
    final int currentIndex = _calculateSelectedIndex(context);
    // Handle potential index out of bounds during transitions or misconfiguration
    if (currentIndex < 0 || currentIndex >= pageData.length) {
      return Scaffold(
        body: Center(
            child: Text("Error: Invalid navigation state ($currentIndex)")),
      );
    }
    final ShellNavigationDest currentPage = pageData[currentIndex];

    // Build different Scaffolds based on screen width
    return MediaQuery.of(context).size.width < smallBreakpoint
        // --- Portrait Scaffold (NavigationBar) ---
        ? Scaffold(
            appBar: AppBar(
              title: currentPage.appBarTitle,
              centerTitle: currentPage.centerTitle,
              actions: currentPage.appBarActions! + fixedActions!,
            ),
            floatingActionButton: currentPage.fab != null
                ? FloatingActionButton.extended(
                    // Use unique keys if FABs change significantly between routes
                    heroTag: UniqueKey(),
                    onPressed: currentPage.fab?.onPressed,
                    icon: currentPage.fab?.icon,
                    label: Text(currentPage.fab!.label),
                  )
                : null,
            // The body is the actual page content passed by GoRouter
            body: child,
            bottomNavigationBar: NavigationBar(
              destinations: List.generate(pageData.length, (index) {
                return NavigationDestination(
                  icon: pageData[index].icon,
                  label: pageData[index].text,
                );
              }),
              selectedIndex: currentIndex,
              onDestinationSelected: (index) =>
                  _onDestinationSelected(index, context),
            ),
          )
        // --- Landscape Scaffold (NavigationRail) ---
        : Scaffold(
            appBar: AppBar(
              title: currentPage.appBarTitle,
              centerTitle: currentPage.centerTitle,
              actions: currentPage.appBarActions! + fixedActions!,
            ),
            // No FAB here (it's in the NavigationRail's leading)
            body: Row(
              children: [
                NavigationRail(
                  leading: currentPage.fab != null
                      ? FloatingActionButton(
                          heroTag: UniqueKey(), // Ensure unique hero tags
                          onPressed: currentPage.fab?.onPressed,
                          // Landscape typically uses icon-only FAB
                          child: currentPage.fab?.icon,
                        )
                      : const SizedBox
                          .shrink(), // Or SizedBox() if no leading needed
                  selectedIndex: currentIndex,
                  labelType: NavigationRailLabelType.all, // Or selected/none
                  onDestinationSelected: (index) =>
                      _onDestinationSelected(index, context),
                  destinations: List.generate(pageData.length, (index) {
                    return NavigationRailDestination(
                      icon: pageData[index].icon,
                      label: Text(pageData[index].text),
                    );
                  }),
                ),

                Expanded(
                  // The actual page content is placed here
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    // Optional: Wrap in Card for visual separation
                    child: Theme.of(context).brightness == Brightness.light
                        ? Card.outlined(

                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: child, // Page content inside card
                            ))
                        : Card(
                           elevation: 0,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: child, // Page content inside card
                            )),
                    // Or just display the child directly:
                    // child: child,
                  ),
                ),
              ],
            ),
          );
  }
}
