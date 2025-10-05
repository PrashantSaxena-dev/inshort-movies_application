import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/local/movie_local_data_source.dart';
import '../widgets/now_playing_item.dart';
import 'movie_details_screen.dart';

class BookmarksScreen extends StatelessWidget {
  const BookmarksScreen({super.key});

  void _openDetails(BuildContext context, int movieId) {
    Navigator.pushNamed(context, MovieDetailsScreen.routeName,
        arguments: movieId);
  }

  @override
  Widget build(BuildContext context) {
    final local = Provider.of<MovieLocalDataSource>(context, listen: false);

    return Scaffold(
      appBar: AppBar(title: const Text('Saved Movies')),
      body: ValueListenableBuilder(
        valueListenable: local.bookmarksListenable(),
        builder: (context, box, _) {
          final ids = local.getBookmarkedIds();
          final movies = local.getMoviesByIds(ids);

          if (movies.isEmpty) {
            return const Center(child: Text('No saved movies yet.'));
          }

          return ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            itemCount: movies.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final m = movies[index];
              return NowPlayingItem(
                movie: m,
                onTap: () => _openDetails(context, m.id),
              );
            },
          );
        },
      ),
    );
  }
}
