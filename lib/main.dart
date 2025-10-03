import 'package:flutter/material.dart';
import 'package:movies_app/data/local/local_db.dart';
import 'ui/screens/movie_details_screen.dart';
import 'ui/screens/home_screen.dart';
import 'ui/screens/bookmarks_screen.dart';
import 'ui/screens/search_screen.dart';import 'core/network/dio_client.dart';
import 'data/remote/tmdb_api.dart';
import 'package:provider/provider.dart';
import 'providers/app_providers.dart';

void main() async{
  // WidgetsFlutterBinding.ensureInitialized();

  // final dio = DioClient.create();
  // final api = TmdbApi(dio);

  // // quick check
  // final trending = await api.getTrendingMovies();
  // print(trending.data);

  WidgetsFlutterBinding.ensureInitialized();
  await initHive();
  runApp(const MoviesApp());
}

class MoviesApp extends StatelessWidget {
  const MoviesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: AppProviders.providers(),
      child: MaterialApp(
        title: 'Movies App',
        theme: ThemeData(useMaterial3: true),
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        routes: {
          '/': (context) => const HomeScreen(),
          MovieDetailsScreen.routeName: (context) => const MovieDetailsScreen(),
          '/bookmarks': (context) => const BookmarksScreen(),
          '/search': (context) => const SearchScreen(),
        },
      ),
    );
  }
}
