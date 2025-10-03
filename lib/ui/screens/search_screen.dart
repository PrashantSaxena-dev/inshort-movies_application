import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/search_model.dart';
import '../../data/models/movie_model.dart';
import '../widgets/movie_card.dart';
import 'movie_details_screen.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  void _openDetails(BuildContext context, int movieId) {
    Navigator.pushNamed(context, MovieDetailsScreen.routeName, arguments: movieId);
  }

  @override
  Widget build(BuildContext context) {
    final searchModel = Provider.of<SearchModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Movies'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              controller: searchModel.controller,
              onChanged: searchModel.onQueryChanged,
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                hintText: 'Search movies...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: searchModel.controller.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          searchModel.controller.clear();
                          searchModel.onQueryChanged('');
                        },
                      )
                    : null,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ),
          Expanded(
            child: Builder(builder: (context) {
              if (searchModel.loading) {
                return const Center(child: CircularProgressIndicator());
              }
              if (searchModel.error != null) {
                return Center(child: Text('Error: ${searchModel.error}'));
              }
              if (searchModel.results.isEmpty) {
                return const Center(child: Text('No results'));
              }
              return ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                itemBuilder: (context, index) {
                  final MovieModel m = searchModel.results[index];
                  return MovieCard(
                    movie: m,
                    onTap: () => _openDetails(context, m.id),
                    onBookmarkTap: () {},
                  );
                },
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemCount: searchModel.results.length,
              );
            }),
          ),
        ],
      ),
    );
  }
}
