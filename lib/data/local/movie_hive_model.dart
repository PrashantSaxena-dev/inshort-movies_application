import 'package:hive/hive.dart';

class MovieHive {
  final int id;
  final String title;
  final String? overview;
  final String? posterPath;
  final String? backdropPath;
  final String? releaseDate;
  final double? voteAverage;
  final double? popularity;

  MovieHive({
    required this.id,
    required this.title,
    this.overview,
    this.posterPath,
    this.backdropPath,
    this.releaseDate,
    this.voteAverage,
    this.popularity,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'overview': overview,
      'posterPath': posterPath,
      'backdropPath': backdropPath,
      'releaseDate': releaseDate,
      'voteAverage': voteAverage,
      'popularity': popularity,
    };
  }

  factory MovieHive.fromMap(Map<dynamic, dynamic> map) {
    final vote = map['voteAverage'];
    final pop = map['popularity'];
    double? toDouble(dynamic v) {
      if (v == null) return null;
      if (v is int) return v.toDouble();
      if (v is double) return v;
      return double.tryParse(v.toString());
    }

    return MovieHive(
      id: map['id'] as int,
      title: map['title'] as String,
      overview: map['overview'] as String?,
      posterPath: map['posterPath'] as String?,
      backdropPath: map['backdropPath'] as String?,
      releaseDate: map['releaseDate'] as String?,
      voteAverage: toDouble(vote),
      popularity: toDouble(pop),
    );
  }
}

class MovieHiveAdapter extends TypeAdapter<MovieHive> {
  @override
  final int typeId = 0;

  @override
  MovieHive read(BinaryReader reader) {
    final len = reader.readByte();
    final map = <dynamic, dynamic>{};
    for (var i = 0; i < len; i++) {
      final key = reader.read();
      final value = reader.read();
      map[key] = value;
    }
    return MovieHive.fromMap(map);
  }

  @override
  void write(BinaryWriter writer, MovieHive obj) {
    final map = obj.toMap();
    writer.writeByte(map.length);
    map.forEach((key, value) {
      writer.write(key);
      writer.write(value);
    });
  }
}
