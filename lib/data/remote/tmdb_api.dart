import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';
import '../../core/constants.dart';
import '../models/movie_list_response.dart';
import '../models/movie_model.dart';

part 'tmdb_api.g.dart';

@RestApi(baseUrl: TMDB_BASE_URL)
abstract class TmdbApi {
  factory TmdbApi(Dio dio, {String baseUrl}) = _TmdbApi;

  @GET('/trending/movie/day')
  Future<MovieListResponse> getTrendingMovies({@Query('page') int page = 1});

  @GET('/movie/now_playing')
  Future<MovieListResponse> getNowPlayingMovies({@Query('page') int page = 1});

  @GET('/search/movie')
  Future<MovieListResponse> searchMovies(@Query('query') String query, {@Query('page') int page = 1});

  @GET('/movie/{id}')
  Future<MovieModel> getMovieDetails(@Path('id') int movieId);
}
