import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter/foundation.dart';
import '../../data/models/movie_model.dart';
import 'local_db.dart';
import 'movie_hive_model.dart';

// movies stored in boxMovies keyed by id -> Map
// lists stored in boxLists keyed by listName -> List<int> (movie ids)
// bookmarks stored in boxBookmarks keyed by movieId -> movieId (or timestamp integer)

class MovieLocalDataSource {
  Future<void> upsertMovies(List<MovieModel> movies) async {
    final box = Hive.box<Map>(boxMovies);
    final Map<dynamic, Map> batch = {};
    for (final m in movies) {
      final mh = _toHive(m).toMap();
      batch[m.id] = mh;
    }
    await box.putAll(batch);
  }

  Future<void> upsertMovie(MovieModel m) async {
    final box = Hive.box<Map>(boxMovies);
    await box.put(m.id, _toHive(m).toMap());
  }

  MovieModel? getMovie(int id) {
    final box = Hive.box<Map>(boxMovies);
    final map = box.get(id);
    if (map == null) return null;
    return _fromHiveMap(map);
  }

  List<MovieModel> getMoviesByIds(List<int> ids) {
    final box = Hive.box<Map>(boxMovies);
    final List<MovieModel> out = [];
    for (final id in ids) {
      final map = box.get(id);
      if (map != null) out.add(_fromHiveMap(map));
    }
    return out;
  }

  Future<void> saveList(String listName, List<int> ids) async {
    final box = Hive.box<List>(boxLists);
    await box.put(listName, ids);
  }

  List<int> getListIds(String listName) {
    final box = Hive.box<List>(boxLists);
    final list = box.get(listName);
    if (list == null) return [];
    return List<int>.from(list);
  }

  Future<void> bookmarkMovie(int movieId) async {
    final box = Hive.box<int>(boxBookmarks);
    await box.put(movieId, movieId);
  }

  Future<void> unbookmarkMovie(int movieId) async {
    final box = Hive.box<int>(boxBookmarks);
    await box.delete(movieId);
  }

  List<int> getBookmarkedIds() {
    final box = Hive.box<int>(boxBookmarks);
    return box.keys.cast<int>().toList();
  }

  // ValueListenable to use in UI (ValueListenableBuilder)
  ValueListenable<Box<Map>> moviesListenable() => Hive.box<Map>(boxMovies).listenable();
  ValueListenable<Box<int>> bookmarksListenable() => Hive.box<int>(boxBookmarks).listenable();
  ValueListenable<Box<List>> listsListenable() => Hive.box<List>(boxLists).listenable();

  MovieHive _toHive(MovieModel m) {
    return MovieHive(
      id: m.id,
      title: m.title,
      overview: m.overview,
      posterPath: m.posterPath,
      backdropPath: m.backdropPath,
      releaseDate: m.releaseDate,
      voteAverage: m.voteAverage,
      popularity: m.popularity,
    );
  }

  MovieModel _fromHiveMap(Map<dynamic, dynamic> map) {
    final mh = MovieHive.fromMap(map);
    return MovieModel(
      id: mh.id,
      title: mh.title,
      overview: mh.overview,
      posterPath: mh.posterPath,
      backdropPath: mh.backdropPath,
      releaseDate: mh.releaseDate,
      voteAverage: mh.voteAverage,
      popularity: mh.popularity,
    );
  }
}
