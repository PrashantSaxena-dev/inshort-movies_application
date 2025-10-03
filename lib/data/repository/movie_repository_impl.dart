import '../models/movie_model.dart';
import '../models/movie_list_response.dart';
import '../../data/remote/tmdb_api.dart';
import 'movie_repository.dart';

class MovieRepositoryImpl implements MovieRepository {
  final TmdbApi api;
  MovieRepositoryImpl({required this.api});

  @override
  Future<List<MovieModel>> getTrending({int page = 1}) async {
    final list = await api.getTrendingMovies(page: page);
    return list.results;
  }

  @override
  Future<List<MovieModel>> getNowPlaying({int page = 1}) async {
    final list = await api.getNowPlayingMovies(page: page);
    return list.results;
  }

  @override
  Future<List<MovieModel>> searchMovies(String query, {int page = 1}) async {
    final list = await api.searchMovies(query, page: page);
    return list.results;
  }

  @override
  Future<MovieModel> getMovieDetails(int id) async {
    return await api.getMovieDetails(id);
  }
}
