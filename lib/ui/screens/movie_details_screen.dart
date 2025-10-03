import 'package:flutter/material.dart';
import 'package:movies_app/data/local/movie_local_data_source.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import '../../data/repository/movie_repository.dart';
import '../../viewmodels/details_model.dart';
import '../../data/models/movie_model.dart';

class MovieDetailsScreen extends StatelessWidget {
  static const routeName = '/details';

  const MovieDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments;
    final int movieId = args is int ? args : int.parse(args.toString());
    final repo = Provider.of<MovieRepository>(context, listen: false);

    return ChangeNotifierProvider<DetailsModel>(
      create: (_) => DetailsModel(repository: repo, movieId: movieId),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Movie Details'),
          actions: [
            Consumer<DetailsModel>(
              builder: (context, model, _) {
                return IconButton(
                  icon: Icon(model.isBookmarked ? Icons.bookmark : Icons.bookmark_border),
                  onPressed: () async {
                    if (model.movie != null) {
                      final local = Provider.of<MovieLocalDataSource>(context, listen: false);
                      if (model.isBookmarked) {
                        await local.unbookmarkMovie(model.movie!.id);
                      } else {
                        await local.bookmarkMovie(model.movie!.id);
                        await local.upsertMovie(model.movie!);
                      }
                      model.toggleBookmark();
                      final snack = model.isBookmarked ? 'Bookmarked' : 'Removed bookmark';
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(snack)));
                    }
                  },
                );
              },
            ),
            Consumer<DetailsModel>(
              builder: (context, model, _) {
                return IconButton(
                  icon: const Icon(Icons.share),
                  onPressed: () {
                    if (model.movie != null) {
                      final MovieModel m = model.movie!;
                      final releaseYear = (m.releaseDate != null && m.releaseDate!.isNotEmpty) 
                          ? ' (${DateTime.tryParse(m.releaseDate!)?.year ?? ''})' 
                          : '';
                      final overview = (m.overview != null && m.overview!.isNotEmpty) 
                          ? '\n${m.overview!.substring(0, m.overview!.length > 100 ? 100 : m.overview!.length)}...' 
                          : '';
                      final preUrl = 'https://www.themoviedb.org/movie/';
                      final shareText = '🎬 ${m.title}$releaseYear${overview}\n\nCheck it out on TMDB:\n${preUrl}${m.id}';

                      Share.share(shareText);
                    } else {
                      Share.share('Check this app: MyMoviesApp');
                    }
                  },
                );
              },
            ),
          ],
        ),
        body: Consumer<DetailsModel>(
          builder: (context, model, _) {
            if (model.loading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (model.error != null) {
              return Center(child: Text('Error: ${model.error}'));
            }
            final m = model.movie;
            if (m == null) {
              return const Center(child: Text('No details available'));
            }
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (m.backdropUrl != null)
                    AspectRatio(
                      aspectRatio: 16 / 9,
                      child: Image.network(m.backdropUrl!, fit: BoxFit.cover, width: double.infinity),
                    ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(m.title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            if (m.voteAverage != null)
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade200,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(m.voteAverage!.toStringAsFixed(1)),
                              ),
                            const SizedBox(width: 12),
                            if (m.releaseDate != null) Text(m.releaseDate!),
                          ],
                        ),
                        const SizedBox(height: 12),
                        if (m.overview != null && m.overview!.isNotEmpty)
                          Text(m.overview!, style: const TextStyle(fontSize: 16)),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
