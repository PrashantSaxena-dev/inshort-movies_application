import 'package:flutter/material.dart';
import '../../data/models/movie_model.dart';
import 'package:provider/provider.dart';
import '../../data/local/movie_local_data_source.dart';
import 'package:share_plus/share_plus.dart';

class NowPlayingItem extends StatefulWidget {
  final MovieModel movie;
  final VoidCallback onTap;

  const NowPlayingItem({super.key, required this.movie, required this.onTap});

  @override
  State<NowPlayingItem> createState() => _NowPlayingItemState();
}

class _NowPlayingItemState extends State<NowPlayingItem>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    _fade = CurvedAnimation(parent: _ctrl, curve: Curves.easeIn);
    _ctrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final movie = widget.movie;
    final local = Provider.of<MovieLocalDataSource>(context, listen: false);

    return FadeTransition(
      opacity: _fade,
      child: GestureDetector(
        onTap: widget.onTap,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 12),
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.grey.shade900,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: SizedBox(
                  width: 90,
                  height: 130,
                  child: movie.posterUrl != null
                      ? Image.network(movie.posterUrl!, fit: BoxFit.cover)
                      : Container(color: Colors.grey[800]),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(movie.title,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w700)),
                    const SizedBox(height: 8),
                    Text(movie.releaseDate ?? '',
                        style: TextStyle(color: Colors.white70)),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        if (movie.voteAverage != null)
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.white24,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              movie.voteAverage!.toStringAsFixed(1),
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                        const Spacer(),
                        // Bookmark button
                        FutureBuilder<bool>(
                          future: Future.value(
                              local.getBookmarkedIds().contains(movie.id)),
                          builder: (context, snap) {
                            final bookmarked = snap.data ?? false;
                            return IconButton(
                              icon: Icon(
                                bookmarked
                                    ? Icons.bookmark
                                    : Icons.bookmark_border,
                                color: Colors.white,
                              ),
                              onPressed: () async {
                                if (bookmarked) {
                                  await local.unbookmarkMovie(movie.id);
                                } else {
                                  await local.upsertMovie(movie);
                                  await local.bookmarkMovie(movie.id);
                                }
                                setState(() {});
                              },
                            );
                          },
                        ),

                        // Share button (deep link)
                        IconButton(
                          icon: const Icon(Icons.share, color: Colors.white),
                          onPressed: () {
                            if (movie != null) {
                              final releaseYear = (movie.releaseDate != null &&
                                      movie.releaseDate!.isNotEmpty)
                                  ? ' (${DateTime.tryParse(movie.releaseDate!)?.year ?? ''})'
                                  : '';
                              final overview = (movie.overview != null &&
                                      movie.overview!.isNotEmpty)
                                  ? '\n${movie.overview!.substring(0, movie.overview!.length > 100 ? 100 : movie.overview!.length)}...'
                                  : '';
                              final preUrl =
                                  'https://www.themoviedb.org/movie/';
                              final shareText =
                                  '🎬 ${movie.title}$releaseYear$overview\n\nCheck it out on TMDB:\n${preUrl}${movie.id}';

                              Share.share(shareText);
                            } else {
                              Share.share('Check this app: MyMoviesApp');
                            }
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
