import 'package:hive_flutter/hive_flutter.dart';
import 'movie_hive_model.dart';

const String boxMovies = 'movies_box';
const String boxLists = 'lists_box';
const String boxBookmarks = 'bookmarks_box';

Future<void> initHive() async {
  await Hive.initFlutter();
  Hive.registerAdapter(MovieHiveAdapter());
  await Hive.openBox<Map>(boxMovies);
  await Hive.openBox<List>(boxLists);
  await Hive.openBox<int>(boxBookmarks);
}
