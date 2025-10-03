import '../models/movie_model.dart';
import '../../data/remote/tmdb_api.dart';
import '../remote/tmdb_remote_data_source.dart';
import '../local/movie_local_data_source.dart';
import 'movie_repository.dart';

class MovieRepositoryImpl implements MovieRepository {
  final TmdbApi api;
  final MovieLocalDataSource local;

  late final TmdbRemoteDataSource remote;

  MovieRepositoryImpl({required this.api, required this.local}) {
    remote = TmdbRemoteDataSource(api: api);
  }

  @override
  Future<List<MovieModel>> getTrending({int page = 1}) async {
    try {
      final list = await remote.fetchTrending(page: page);
      await local.upsertMovies(list);
      await local.saveList('trending', list.map((e) => e.id).toList());
      return list;
    } catch (e) {
      final ids = local.getListIds('trending');
      return local.getMoviesByIds(ids);
    }
  }

  @override
  Future<List<MovieModel>> getNowPlaying({int page = 1}) async {
    try {
      final list = await remote.fetchNowPlaying(page: page);
      await local.upsertMovies(list);
      await local.saveList('now_playing', list.map((e) => e.id).toList());
      return list;
    } catch (e) {
      final ids = local.getListIds('now_playing');
      return local.getMoviesByIds(ids);
    }
  }

  @override
  Future<List<MovieModel>> searchMovies(String query, {int page = 1}) async {
    final list = await remote.searchMovies(query, page: page);
    await local.upsertMovies(list);
    return list;
  }

  @override
  Future<MovieModel> getMovieDetails(int id) async {
    try {
      final m = await remote.fetchMovieDetails(id);
      await local.upsertMovie(m);
      return m;
    } catch (e) {
      final cached = local.getMovie(id);
      if (cached != null) return cached;
      rethrow;
    }
  }

  Future<void> bookmarkMovie(MovieModel m) async {
    await local.upsertMovie(m);
    await local.bookmarkMovie(m.id);
  }

  Future<void> unbookmarkMovie(int movieId) async {
    await local.unbookmarkMovie(movieId);
  }

  List<int> getBookmarkedIds() => local.getBookmarkedIds();
}
