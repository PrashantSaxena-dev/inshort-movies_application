import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import '../../data/local/movie_local_data_source.dart';
import '../../data/repository/movie_repository.dart';
import '../../data/models/movie_model.dart';
import '../../viewmodels/details_model.dart';

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
        backgroundColor: Colors.black,
        body: Consumer<DetailsModel>(
          builder: (context, model, _) {
            if (model.loading) {
              return const Center(
                child: CircularProgressIndicator(color: Colors.white),
              );
            }
            if (model.error != null) {
              return Center(
                child: Text('Error: ${model.error}',
                    style: const TextStyle(color: Colors.white)),
              );
            }

            final m = model.movie;
            if (m == null) {
              return const Center(
                child: Text('No details available',
                    style: TextStyle(color: Colors.white70)),
              );
            }

            return Stack(
              children: [
                // Backdrop Image
                Hero(
                  tag: 'poster-${m.id}',
                  child: m.backdropUrl != null
                      ? Image.network(
                          m.backdropUrl!,
                          width: double.infinity,
                          height: MediaQuery.of(context).size.height * 0.45,
                          fit: BoxFit.cover,
                        )
                      : Container(
                          height: MediaQuery.of(context).size.height * 0.45,
                          color: Colors.grey[900],
                        ),
                ),

                // Overlay Gradient
                Container(
                  height: MediaQuery.of(context).size.height * 0.45,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withOpacity(0.1),
                        Colors.black.withOpacity(0.8),
                      ],
                    ),
                  ),
                ),

                // Content below poster
                SingleChildScrollView(
                  padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.42,
                  ),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10),
                        Text(
                          m.title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            if (m.voteAverage != null)
                              Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              // color: Colors.white24,
                              border: Border.all(
                                color: Colors.deepPurple, // Color of the border
                                width: 1.0, // Width of the border
                              ),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              m.voteAverage!.toStringAsFixed(1),
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                            const SizedBox(width: 12),
                            if (m.releaseDate != null)
                              Text(
                                '(${m.releaseDate!.split('-')[0]})',
                                style: const TextStyle(color: Colors.white70),
                              ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        if (m.overview != null && m.overview!.isNotEmpty)
                          Text(
                            m.overview!,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 16,
                              height: 1.4,
                            ),
                          ),
                        const SizedBox(height: 60),
                      ],
                    ),
                  ),
                ),

                // Floating top-right icons (bookmark + share)
                Positioned(
                  top: 40,
                  right: 16,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Bookmark toggle
                      Consumer<DetailsModel>(
                        builder: (context, model, _) {
                          return _buildTopCircleButton(
                            icon: model.isBookmarked
                                ? Icons.bookmark
                                : Icons.bookmark_border,
                            onTap: () async {
                              if (model.movie != null) {
                                final local = Provider.of<MovieLocalDataSource>(
                                    context,
                                    listen: false);
                                if (model.isBookmarked) {
                                  await local.unbookmarkMovie(model.movie!.id);
                                } else {
                                  await local.bookmarkMovie(model.movie!.id);
                                  await local.upsertMovie(model.movie!);
                                }
                                model.toggleBookmark();
                                final snack = model.isBookmarked
                                    ? 'Bookmarked'
                                    : 'Removed bookmark';
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(snack)),
                                );
                              }
                            },
                          );
                        },
                      ),
                      const SizedBox(width: 10),
                      // Share button
                      Consumer<DetailsModel>(
                        builder: (context, model, _) {
                          return _buildTopCircleButton(
                            icon: Icons.share,
                            onTap: () {
                              if (model.movie != null) {
                                final MovieModel m = model.movie!;
                                final releaseYear = (m.releaseDate != null &&
                                        m.releaseDate!.isNotEmpty)
                                    ? ' (${DateTime.tryParse(m.releaseDate!)?.year ?? ''})'
                                    : '';
                                final overview = (m.overview != null &&
                                        m.overview!.isNotEmpty)
                                    ? '\n${m.overview!.substring(0, m.overview!.length > 100 ? 100 : m.overview!.length)}...'
                                    : '';
                                final preUrl =
                                    'https://www.themoviedb.org/movie/';
                                final shareText =
                                    '🎬 ${m.title}$releaseYear$overview\n\nCheck it out on TMDB:\n${preUrl}${m.id}';
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
                ),
                // Back button floating on top-left
                Positioned(
                  top: 40,
                  left: 16,
                  child: _buildTopCircleButton(
                    icon: Icons.arrow_back,
                    onTap: () => Navigator.pop(context),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildTopCircleButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(40),
      child: Container(
        width: 46,
        height: 46,
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.45),
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white24, width: 1),
        ),
        child: Icon(icon, color: Colors.white, size: 24),
      ),
    );
  }
}
