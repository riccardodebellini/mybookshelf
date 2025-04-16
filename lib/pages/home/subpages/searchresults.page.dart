import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../res/itemlist.res.dart';

final supabase = Supabase.instance.client;

class SearchResultsPage extends StatefulWidget {
  final String input;

  const SearchResultsPage({super.key, required this.input});

  @override
  State<SearchResultsPage> createState() => SearchResultsPageState();
}

class SearchResultsPageState extends State<SearchResultsPage> {
  Set<dynamic> currentFilter = {0};
  late TextEditingController queryController = TextEditingController();
  Field queryType = Field.title;
  final books = supabase.from('books').select();
  final lends = supabase.from('lends').select();

  void parseQuery() {
    if (queryType == Field.year || queryType == Field.rating) {
      setState(() {
        query = int.tryParse(queryController.text) ?? 2024;
      });
    } else if (queryType == Field.read) {
      setState(() {
        query = bool.tryParse(queryController.text) ?? false;
      });
    } else {
      setState(() {
        query = queryController.text;
      });
    }
  }

  dynamic query;

  @override
  void initState() {
    setState(() {
      queryController = TextEditingController(text: widget.input);
      parseQuery();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ricerca"),
        leading: context.canPop()
            ? null
            : IconButton(
                onPressed: () {
                  context.go('/');
                },
                icon: const Icon(Icons.home_rounded)),
      ),
      body: ListView(
        children: [
          const SizedBox(
            height: 8,
          ),
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width / 8),
            child: SearchBar(
              padding: const WidgetStatePropertyAll(
                  EdgeInsets.symmetric(horizontal: 16)),
              elevation: WidgetStateProperty.all(0),
              hintText: "Cerca tra i tuoi libri",
              leading: const Icon(Icons.search_rounded),
              controller: queryController,
              onSubmitted: (value) {
                parseQuery();
              },
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SegmentedButton(
                  segments: <ButtonSegment>[
                    const ButtonSegment(
                      value: 0,
                      label: Text("Libri"),
                    ),
                    ButtonSegment(
                        value: 1,
                        label: const Text("Prestiti"),
                        enabled: queryType.canLend),
                  ],
                  selected: currentFilter,
                  showSelectedIcon: false,
                  onSelectionChanged: (Set<dynamic> newSelection) {
                    setState(() {
                      currentFilter = newSelection;
                    });
                  },
                ),
                MenuAnchor(
                  builder: (context, controller, child) {
                    return OutlinedButton.icon(
                      onPressed: () {
                        if (controller.isOpen) {
                          controller.close();
                        } else {
                          controller.open();
                        }
                      },
                      icon: Icon(
                        Icons.expand_more_rounded,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                      label: Text(queryType.displayValue,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onSurface,
                          )),
                    );
                  },
                  menuChildren: List.generate(Field.values.length, (index) {
                    final value = Field.values[index];
                    return MenuItemButton(
                      child: Text(value.displayValue),
                      onPressed: () {
                        setState(() {
                          queryType = value;
                          if (currentFilter.first == 1 && !value.canLend) {
                            setState(() {
                              currentFilter = {0};
                            });
                          }
                        });
                        parseQuery();
                      },
                    );
                  }),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          (queryType != Field.read &&
                  queryType != Field.rating &&
                  queryType != Field.year)
              ? (currentFilter.first == 0
                  ? ItemsList(
                      filter: books.textSearch(queryType.string, '"$query"',
                          type: TextSearchType.websearch))
                  : ItemsList(
                      filter: lends.textSearch(queryType.string, '"$query"',
                          type: TextSearchType.phrase),
                      isLend: true,
                    ))
              : currentFilter.first == 0
                  ? ItemsList(
                      filter: books.eq(
                      queryType.string,
                      '$query',
                    ))
                  : ItemsList(
                      filter: lends.eq(
                        queryType.string,
                        '$query',
                      ),
                      isLend: true,
                    )
        ],
      ),
    );
  }
}

enum Field {
  title("title", displayValue: "Titolo"),
  author("author", canLend: false, displayValue: "Autore"),
  year("year", canLend: false, displayValue: "Anno"),
  location("location", displayValue: "Posizione"),
  abstract("abstract", canLend: false, displayValue: "Abstract"),
  read("read", canLend: false, displayValue: "Letto"),
  rating("rating", canLend: false, displayValue: "Voto");

  final String string;
  final String displayValue;
  final bool canLend;

  const Field(this.string, {this.canLend = true, required this.displayValue});
}
