import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app_links/app_links.dart';
import 'data/local/local_db.dart';
import 'providers/app_providers.dart';
import 'ui/screens/home_screen.dart';
import 'ui/screens/movie_details_screen.dart';
import 'ui/screens/bookmarks_screen.dart';
import 'ui/screens/search_screen.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initHive();
  runApp(const MoviesApp());
}

class MoviesApp extends StatefulWidget {
  const MoviesApp({super.key});

  @override
  State<MoviesApp> createState() => _MoviesAppState();
}

class _MoviesAppState extends State<MoviesApp> {
  late final AppLinks _appLinks;
  StreamSubscription<Uri>? _sub;

  @override
  void initState() {
    super.initState();
    _appLinks = AppLinks();
    _listenForLinks();
  }

  void _listenForLinks() {
    _sub = _appLinks.uriLinkStream.listen((uri) {
      _handleIncomingUri(uri);
    }, onError: (err) {
      // log or ignore
    });
    _initInitialUri();
  }


  Future<void> _initInitialUri() async {
    try {
      final uri = await _appLinks.getInitialLink();
      if (uri != null) {
        _handleIncomingUri(uri);
      }
    } catch (e) {
      // ignore
    }
  }

  void _handleIncomingUri(Uri uri) {
    if (uri.scheme == 'mymovies' && uri.host == 'movie') {
      final segments = uri.pathSegments;
      if (segments.isNotEmpty) {
        final idStr = segments[0];
        final id = int.tryParse(idStr);
        if (id != null) {
          // navigate to details
          WidgetsBinding.instance.addPostFrameCallback((_) {
            navigatorKey.currentState?.pushNamed(
              MovieDetailsScreen.routeName,
              arguments: id,
            );
          });
        }
      }
    }
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: AppProviders.providers(),
      child: MaterialApp(
        navigatorKey: navigatorKey,
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
