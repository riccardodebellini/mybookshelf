import 'package:flex_list/flex_list.dart';
import 'package:flutter/material.dart';
import 'package:mybookshelf/pages/home/subpages/genres.dart';
import 'package:mybookshelf/res/filters.dart';
import 'package:mybookshelf/sys/capitalize.util.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = Supabase.instance.client;

GlobalKey<HomePageState> homePageKey = GlobalKey();

class HomePage extends StatefulWidget {
  const HomePage({required Key key}) : super(key: key);

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  String favGenre = "";
  List genres = [];
  final GlobalKey<RefreshIndicatorState> isReloading =
      GlobalKey<RefreshIndicatorState>();

  fetchGenres() async {
    final data = await supabase.from("profile").select();
    final userData = data[0];
    setState(() {
      if (userData['genres'] != null) {
        genres = List<String>.from(userData['genres']);
      } else {
        genres = [];
      }
    });
  }

  fetchFavouriteGenre() async {
    final data = await supabase.from("profile").select();
    final userData = data[0];
    setState(() {
      if (userData['genres'] != null) {
        favGenre = userData['favouriteGenre'];
      } else {
        favGenre = "";
      }
    });
  }

  reloadAll() {
    setState(() {
      isReloading.currentState?.show();
    });
  }

  @override
  void initState() {
    super.initState();
    fetchGenres();
    fetchFavouriteGenre();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        await fetchFavouriteGenre();
        await fetchGenres();
      },
      key: isReloading,
      child: ListView(
        physics: const BouncingScrollPhysics(),
        children: [
          const SizedBox(
            height: 16,
          ),
          Center(
            child: Text(
              "Benvenuto in My.Bookshelf",
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          SearchBar(
            elevation: WidgetStateProperty.all(0),
            hintText: "Cerca tra i tuoi libri",
            leading: const Icon(Icons.search_rounded),
          ),
          const SizedBox(
            height: 16,
          ),
          const ListTile(
            leading: Icon(Icons.interests_rounded),
            title: Text(
              "Generi",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          genres.isEmpty
              ? const ListTile(
                  title: Text("Nessun genere trovato"),
                  leading: CircleAvatar(
                    child: Icon(Icons.info_outline_rounded),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: FlexList(
                    verticalSpacing: 8,
                    horizontalSpacing: 8,
                    children: List<Widget>.generate(genres.length, (index) {
                      return ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 150),
                        child: Card.filled(
                          clipBehavior: Clip.hardEdge,
                          child: ListTile(
                            onTap: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return GenresPage(
                                    genre:
                                        genres[index].toString().toLowerCase());
                              }));
                            },
                            title: Text(genres[index]
                                .toString()
                                .toLowerCase()
                                .capitalize()),
                          ),
                        ),
                      );
                    }),
                  ),
                ),
          const ListTile(
            leading: Icon(Icons.auto_awesome_rounded),
            title: Text("Suggeriti"),
          ),
          FilteredView(
            filter: supabase
                .from('books')
                .select()
                .contains('genres', [favGenre.toLowerCase()]),
          ),
          const ListTile(
            title: Text("Prestiti in scadenza"),
            leading: Icon(Icons.notifications_active_rounded),
          ),
          FilteredView(
            filter: supabase.from('lends').select(),
          ),
        ],
      ),
    );
  }
}
