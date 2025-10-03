import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';
import '../../core/constants.dart';

part 'tmdb_api.g.dart';

@RestApi(baseUrl: TMDB_BASE_URL)
abstract class TmdbApi {
  factory TmdbApi(Dio dio, {String baseUrl}) = _TmdbApi;

  // Get trending movies
  @GET("/trending/movie/day")
  Future<HttpResponse<dynamic>> getTrendingMovies({@Query("page") int page = 1});

  // Get now playing movies
  @GET("/movie/now_playing")
  Future<HttpResponse<dynamic>> getNowPlayingMovies({@Query("page") int page = 1});

  // Search movies
  @GET("/search/movie")
  Future<HttpResponse<dynamic>> searchMovies(@Query("query") String query, {@Query("page") int page = 1});

  // Get movie details
  @GET("/movie/{id}")
  Future<HttpResponse<dynamic>> getMovieDetails(@Path("id") int movieId);
}
