import '../models/movie_model.dart';

abstract class MovieRepository {
  Future<List<MovieModel>> getTrending({int page = 1});
  Future<List<MovieModel>> getNowPlaying({int page = 1});
  Future<List<MovieModel>> searchMovies(String query, {int page = 1});
  Future<MovieModel> getMovieDetails(int id);
}
