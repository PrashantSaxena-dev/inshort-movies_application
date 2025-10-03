import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../data/models/movie_model.dart';

class MovieCard extends StatelessWidget {
  final MovieModel movie;
  final VoidCallback onTap;
  final VoidCallback? onBookmarkTap;
  final bool showBookmark;

  const MovieCard({
    super.key,
    required this.movie,
    required this.onTap,
    this.onBookmarkTap,
    this.showBookmark = true,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: SizedBox(
        width: 140,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 2 / 3,
              child: CachedNetworkImage(
                imageUrl: movie.posterUrl ?? '',
                fit: BoxFit.cover,
                errorWidget: (c, s, e) => Container(
                  color: Colors.grey[300],
                  child: const Icon(Icons.movie, size: 48),
                ),
                placeholder: (c, s) => Container(
                  color: Colors.grey[200],
                ),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              movie.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                if (showBookmark && onBookmarkTap != null)
                  GestureDetector(
                    onTap: onBookmarkTap,
                    child: const Padding(
                      padding: EdgeInsets.only(right: 8.0),
                      child: Icon(Icons.bookmark_border, size: 18),
                    ),
                  ),
                if (movie.voteAverage != null)
                  Text(
                    movie.voteAverage!.toStringAsFixed(1),
                    style: const TextStyle(fontSize: 12),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
