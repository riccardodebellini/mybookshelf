
import 'package:flutter/material.dart';
import 'package:mybookshelf/pages/home/subpages/genres.dart';
import 'package:mybookshelf/pages/subpages/settings/settings.dart';
import 'package:mybookshelf/res/filters.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = Supabase.instance.client;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String favGenre = "";
  List genres = [];
  bool isGenresLoading = true; // Flag for loading state
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
      isGenresLoading = false;
      if (userData['genres'] != null) {
        favGenre = userData['favouriteGenre'];
      } else {
        favGenre = "";
      }
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
    return Scaffold(
        appBar: AppBar(
          title: const Text("Home"),
          centerTitle: true,
          actions: [
            Tooltip(
                message: "Ricarica",
                child: IconButton(
                    onPressed: () {
                      setState(() {
                        isGenresLoading = true;
                        isReloading.currentState?.show();
                      });
                    },
                    icon: const Icon(Icons.sync_rounded))),
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
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return const SettingsPage();
                    }));
                  },
                ),
              ],
            )
          ],
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            setState(() {
              isGenresLoading = true;
            });
            fetchFavouriteGenre();
            fetchGenres();
          },
          key: isReloading,
          child: ListView(
            physics: const BouncingScrollPhysics(),
            children: [
              const ListTile(
                title: Text("Generi"),
                subtitle: Text("Esplora i tuoi libri divisi per genere"),
              ),
              SizedBox(
                height: 200,
                child: isGenresLoading
                    ? const Center(
                        child: CircularProgressIndicator()) // Loading indicator
                    : genres.isEmpty
                        ? ListTile(
                            title: const Text("Nessun genere trovato"),
                            leading: CircleAvatar(
                              backgroundColor:
                                  Theme.of(context).colorScheme.error,
                              foregroundColor:
                                  Theme.of(context).colorScheme.onError,
                              child: const Icon(Icons.error_rounded),
                            ),
                          )
                        : ConstrainedBox(
                            constraints:
                                const BoxConstraints.tightFor(height: 200),
                            child: CarouselView.weighted(
                              flexWeights: const [2, 1],
                              shrinkExtent: 100,
                              onTap: (index) {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return GenresPage(
                                      genre: genres[index]
                                          .toString()
                                          .toLowerCase());
                                }));
                              },
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                                side: BorderSide(
                                    color:
                                        Theme.of(context).colorScheme.outline),
                              ),
                              children:
                                  List<Widget>.generate(genres.length, (index) {
                                return Center(
                                  child: Text(
                                      genres[index].toString().toUpperCase()),
                                );
                              }),
                            ),
                          ),
              ),
              const Divider(),
              const ListTile(
                title: Text("Suggeriti"),
                subtitle: Text(
                    "Ottieni suggerimenti di lettura basati sulle tue preferenze"),
              ),
              FilteredView(
                filter: supabase
                    .from('books')
                    .select()
                    .contains('genres', '{"$favGenre"}'),
              ),
              const Divider(),
              const ListTile(
                title: Text("Prestiti in scadenza"),
                subtitle: Text("Tieni d'occhio i libri prossimi alla scadenza"),
              ),
              const ListTile(
                leading: CircleAvatar(
                  child: Icon(
                    Icons.do_not_disturb_alt_rounded,
                  ),
                ),
                title: Text("Questa sezione non è ancora disponibile, "),
              )
            ],
          ),
        ));
  }
}
