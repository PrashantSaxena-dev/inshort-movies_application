import 'package:json_annotation/json_annotation.dart';

part 'movie_model.g.dart';

// Domain/data model for a movie returned by TMDB.
@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class MovieModel {
  final int id;
  final String title;
  final String? overview;
  final String? posterPath;
  final String? backdropPath;
  final String? releaseDate;
  final double? voteAverage;
  final double? popularity;

  // final Map<String, dynamic>? rawJson; //to persist entire payload

  MovieModel({
    required this.id,
    required this.title,
    this.overview,
    this.posterPath,
    this.backdropPath,
    this.releaseDate,
    this.voteAverage,
    this.popularity,
    // this.rawJson,
  });

  // Factory to create MovieModel from JSON (generated)
  factory MovieModel.fromJson(Map<String, dynamic> json) =>
      _$MovieModelFromJson(json);

  // Convert to JSON (generated)
  Map<String, dynamic> toJson() => _$MovieModelToJson(this);

  // Helper: full poster URL (null-safe)
  String? get posterUrl =>
      posterPath != null ? 'https://image.tmdb.org/t/p/w500$posterPath' : null;

  String? get backdropUrl =>
      backdropPath != null ? 'https://image.tmdb.org/t/p/w780$backdropPath' : null;
}
