import 'package:flutter/material.dart';

class MainNavigationDest {
  /// The text displayed in the NavBar or in the NavRail
  final String text;

  /// The icon displayed in the NavBar or in the NavRail
  final Icon icon;

  /// The page this MainNavigationDest points to
  final Widget destination;

  /// The title of the appbar of the page this MainNavigationDest points to
  final Widget appBarTitle;

  /// The actions displayed in the AppBar, relative only to the page this MainNavigationDest points to
  final List<Widget>? appBarActions;

  /// Wether to center the title in the AppBar or not
  final bool? centerTitle;

  /// The FAB displayed in the NavBar or in the NavRail when this page is selected
  final MainNavigationFAB? fab;

  const MainNavigationDest({
    this.fab,
    required this.appBarTitle,
    this.appBarActions = const [],
    this.centerTitle,
    required this.text,
    required this.icon,
    required this.destination,
  });
}

class MainNavigationFAB {
  ///The callback that is called when the button is tapped or otherwise activated.
  ///
  /// If this is set to null, the button will be disabled.
  final void Function()? onPressed;

  /// The Icon displayed on the FAB
  final Icon icon;

  /// The text displayed on the FAB
  ///
  /// **Works only in landscape mode**
  final String label;

  const MainNavigationFAB(
      {this.onPressed, required this.icon, required this.label});
}

class MainNavigation extends StatefulWidget {
  /// The pages of the App
  final List<MainNavigationDest> pageData;

  /// The actions **always** displayed in the AppBar, no matter what the actual page is. They come after the single page's relative appBarActions
  ///
  /// If you want the actions to be spaced from the left edge of the application, add [SizedBox(width: 16)] at the end of the list to make sure adequate spacing is provided
  final List<Widget>? fixedActions;

  /// The screen width above what landscape mode is used.
  ///
  /// To use only **landscape mode _(NavRail)_**, set this to a small value, such as [0]
  ///
  /// To use only **portrait mode _(NavBar)_**, set this to a very big value, such as [9999]
  ///
  /// Defaults to [600]
  final int? breakpoint;

  const MainNavigation({
    super.key,
    required this.pageData,
    this.fixedActions = const [],
    this.breakpoint = 600,
  });

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return MediaQuery.of(context).size.width > widget.breakpoint!
        ? Scaffold(
            appBar: AppBar(
                title: widget.pageData[_currentIndex].appBarTitle,
                centerTitle: widget.pageData[_currentIndex].centerTitle,
                actions: widget.pageData[_currentIndex].appBarActions! +
                    widget.fixedActions!),
            body: Row(children: [
              NavigationRail(
                leading: widget.pageData[_currentIndex].fab != null
                    ? FloatingActionButton(
                        heroTag: null,
                        onPressed:
                            widget.pageData[_currentIndex].fab?.onPressed,
                        child: widget.pageData[_currentIndex].fab?.icon,
                      )
                    : null,
                selectedIndex: _currentIndex,
                labelType: NavigationRailLabelType.all,
                onDestinationSelected: (int index) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
                destinations: List.generate(widget.pageData.length, (index) {
                  return NavigationRailDestination(
                      icon: widget.pageData[index].icon,
                      label: Text(widget.pageData[index].text));
                }),
              ),
              Expanded(child: widget.pageData[_currentIndex].destination),
            ]))
        : Scaffold(
            appBar: AppBar(
                title: widget.pageData[_currentIndex].appBarTitle,
                centerTitle: widget.pageData[_currentIndex].centerTitle,
                actions: widget.pageData[_currentIndex].appBarActions! +
                    widget.fixedActions!),
            floatingActionButton: widget.pageData[_currentIndex].fab != null
                ? FloatingActionButton.extended(
                    heroTag: null,
                    onPressed: widget.pageData[_currentIndex].fab?.onPressed,
                    icon: widget.pageData[_currentIndex].fab?.icon,
                    label: Text(widget.pageData[_currentIndex].fab!.label),
                  )
                : null,
            body: widget.pageData[_currentIndex].destination,
            bottomNavigationBar: NavigationBar(
              destinations: List.generate(widget.pageData.length, (index) {
                return NavigationDestination(
                    icon: widget.pageData[index].icon,
                    label: widget.pageData[index].text);
              }),
              selectedIndex: _currentIndex,
              onDestinationSelected: (int index) {
                setState(() {
                  _currentIndex = index;
                });
              },
            ),
          );
  }
}
