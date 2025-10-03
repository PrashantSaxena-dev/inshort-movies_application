import '../models/movie_list_response.dart';
import '../models/movie_model.dart';
import 'tmdb_api.dart';

class TmdbRemoteDataSource {
  final TmdbApi api;

  TmdbRemoteDataSource({required this.api});

  Future<List<MovieModel>> fetchTrending({int page = 1}) async {
    final MovieListResponse resp = await api.getTrendingMovies(page: page);
    return resp.results;
  }

  Future<List<MovieModel>> fetchNowPlaying({int page = 1}) async {
    final MovieListResponse resp = await api.getNowPlayingMovies(page: page);
    return resp.results;
  }

  Future<List<MovieModel>> searchMovies(String query, {int page = 1}) async {
    final MovieListResponse resp = await api.searchMovies(query, page: page);
    return resp.results;
  }

  Future<MovieModel> fetchMovieDetails(int id) async {
    return await api.getMovieDetails(id);
  }
}
