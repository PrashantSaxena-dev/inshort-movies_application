import 'package:flutter/material.dart';
import '../data/models/movie_model.dart';
import '../data/repository/movie_repository.dart';

class HomeModel extends ChangeNotifier {
  final MovieRepository repository;

  HomeModel(this.repository) {
    loadAll();
  }

  List<MovieModel> trending = [];
  List<MovieModel> nowPlaying = [];

  bool loadingTrending = false;
  bool loadingNowPlaying = false;

  String? errorTrending;
  String? errorNowPlaying;

  Future<void> loadAll() async {
    await Future.wait([
      loadTrending(),
      loadNowPlaying(),
    ]);
  }

  Future<void> loadTrending() async {
    loadingTrending = true;
    errorTrending = null;
    notifyListeners();
    try {
      final list = await repository.getTrending();
      trending = list;
    } catch (e) {
      errorTrending = e.toString();
    } finally {
      loadingTrending = false;
      notifyListeners();
    }
  }

  Future<void> loadNowPlaying() async {
    loadingNowPlaying = true;
    errorNowPlaying = null;
    notifyListeners();
    try {
      final list = await repository.getNowPlaying();
      nowPlaying = list;
    } catch (e) {
      errorNowPlaying = e.toString();
    } finally {
      loadingNowPlaying = false;
      notifyListeners();
    }
  }
}
