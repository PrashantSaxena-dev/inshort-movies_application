import '../models/movie_model.dart';
import '../models/movie_list_response.dart';
import '../../data/remote/tmdb_api.dart';
import '../remote/tmdb_remote_data_source.dart';
import 'movie_repository.dart';

class MovieRepositoryImpl implements MovieRepository {
  final TmdbApi api;
  late final TmdbRemoteDataSource remote;

  MovieRepositoryImpl({required this.api}) {
    remote = TmdbRemoteDataSource(api: api);
  }

  @override
  Future<List<MovieModel>> getTrending({int page = 1}) async {
    return await remote.fetchTrending(page: page);
  }

  @override
  Future<List<MovieModel>> getNowPlaying({int page = 1}) async {
    return await remote.fetchNowPlaying(page: page);
  }

  @override
  Future<List<MovieModel>> searchMovies(String query, {int page = 1}) async {
    return await remote.searchMovies(query, page: page);
  }

  @override
  Future<MovieModel> getMovieDetails(int id) async {
    return await remote.fetchMovieDetails(id);
  }
}
