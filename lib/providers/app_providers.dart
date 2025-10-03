import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:dio/dio.dart';

import '../core/network/dio_client.dart';
import '../data/remote/tmdb_api.dart';
import '../data/local/movie_local_data_source.dart';
import '../data/repository/movie_repository.dart';
import '../data/repository/movie_repository_impl.dart';
import '../viewmodels/home_model.dart';

class AppProviders {
  static List<SingleChildWidget> providers() {
    final dio = DioClient.create();
    final api = TmdbApi(dio);
    final local = MovieLocalDataSource();
    final movieRepository = MovieRepositoryImpl(api: api, local: local);

    return [
      Provider<Dio>.value(value: dio),
      Provider<TmdbApi>.value(value: api),
      Provider<MovieLocalDataSource>.value(value: local),
      Provider<MovieRepository>.value(value: movieRepository),
      ChangeNotifierProvider<HomeModel>(create: (_) => HomeModel(movieRepository)),
    ];
  }
}
