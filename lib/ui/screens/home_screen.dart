import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/home_model.dart';
import '../widgets/movie_card.dart';
import '../../data/models/movie_model.dart';
import 'movie_details_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _openDetails(BuildContext context, int movieId) {
    Navigator.pushNamed(context, MovieDetailsScreen.routeName, arguments: movieId);
  }

  Widget _buildSection(BuildContext context, String title, List<MovieModel> movies, {required bool isLoading}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
          child: Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
        ),
        SizedBox(
          height: 260,
          child: isLoading
              ? const Center(child: CircularProgressIndicator())
              : ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    final movie = movies[index];
                    return MovieCard(
                      movie: movie,
                      onTap: () => _openDetails(context, movie.id),
                      onBookmarkTap: () {},
                    );
                  },
                  separatorBuilder: (_, __) => const SizedBox(width: 12),
                  itemCount: movies.length,
                ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final homeModel = Provider.of<HomeModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Movies App'),
        actions: [
          IconButton(
            icon: const Icon(Icons.bookmarks),
            onPressed: () {
              Navigator.pushNamed(context, '/bookmarks');
            },
          ),
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              Navigator.pushNamed(context, '/search');
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => homeModel.loadAll(),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              _buildSection(context, 'Trending', homeModel.trending, isLoading: homeModel.loadingTrending),
              const SizedBox(height: 8),
              _buildSection(context, 'Now Playing', homeModel.nowPlaying, isLoading: homeModel.loadingNowPlaying),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
