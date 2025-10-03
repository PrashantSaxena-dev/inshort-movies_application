import 'package:flutter/material.dart';
import '../data/models/movie_model.dart';
import '../data/repository/movie_repository.dart';

class DetailsModel extends ChangeNotifier {
  final MovieRepository repository;
  final int movieId;

  DetailsModel({required this.repository, required this.movieId}) {
    load();
  }

  MovieModel? movie;
  bool loading = false;
  String? error;
  bool isBookmarked = false;

  Future<void> load() async {
    loading = true;
    error = null;
    notifyListeners();
    try {
      final m = await repository.getMovieDetails(movieId);
      movie = m;
    } catch (e) {
      error = e.toString();
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  void toggleBookmark() {
    isBookmarked = !isBookmarked;
    notifyListeners();
  }
}
