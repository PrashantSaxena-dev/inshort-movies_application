import 'package:json_annotation/json_annotation.dart';
import 'movie_model.dart';

part 'movie_list_response.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class MovieListResponse {
  final int page;
  final List<MovieModel> results;
  final int totalResults;
  final int totalPages;

  MovieListResponse({
    required this.page,
    required this.results,
    required this.totalResults,
    required this.totalPages,
  });

  factory MovieListResponse.fromJson(Map<String, dynamic> json) =>
      _$MovieListResponseFromJson(json);

  Map<String, dynamic> toJson() => _$MovieListResponseToJson(this);
}
