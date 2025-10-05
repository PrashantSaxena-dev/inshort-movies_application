import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/search_model.dart';
import '../widgets/now_playing_item.dart';
import 'movie_details_screen.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  void _openDetails(BuildContext context, int movieId) {
    Navigator.pushNamed(context, MovieDetailsScreen.routeName,
        arguments: movieId);
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
                     focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(
        color: Colors.deepPurple, // Your desired color when focused
        width: 2.0,
      ),
      borderRadius: BorderRadius.circular(10.0),
    ),
                border:
                    OutlineInputBorder(
                      
                      borderRadius: BorderRadius.circular(8), borderSide: BorderSide(
        color: Colors.green, // Your desired color
        width: 2.0, // Optional: customize border width
      ),),
              ),
            ),
          ),
          Expanded(
            child: Builder(builder: (context) {
              final query = searchModel.controller.text.trim();

              if (query.isEmpty) {
                return const Center(
                  child: Text(
                    'Start typing to search movies...',
                    style: TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                );
              }
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
                shrinkWrap: true,
                physics: const AlwaysScrollableScrollPhysics(),
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                itemCount: searchModel.results.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final m = searchModel.results[index];
                  return NowPlayingItem(
                    movie: m,
                    onTap: () => _openDetails(context, m.id),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
