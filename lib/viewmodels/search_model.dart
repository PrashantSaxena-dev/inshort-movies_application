import 'dart:async';
import 'package:flutter/material.dart';
import '../data/models/movie_model.dart';
import '../data/repository/movie_repository.dart';

class SearchModel extends ChangeNotifier {
  final MovieRepository repository;

  SearchModel(this.repository);

  final TextEditingController controller = TextEditingController();

  List<MovieModel> results = [];
  bool loading = false;
  String? error;

  Timer? _debounce;
  int _requestCounter = 0;
  int _lastHandledRequest = 0;

  void onQueryChanged(String q) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      _performSearch(q);
    });
  }

  Future<void> _performSearch(String query) async {
    final trimmed = query.trim();
    if (trimmed.isEmpty) {
      results = [];
      loading = false;
      error = null;
      notifyListeners();
      return;
    }

    loading = true;
    error = null;
    notifyListeners();

    final int requestId = ++_requestCounter;
    try {
      final list = await repository.searchMovies(trimmed);
      // ignore response if a newer request has been initiated
      if (requestId < _requestCounter) return;
      results = list;
    } catch (e) {
      if (requestId < _requestCounter) return;
      error = e.toString();
      results = [];
    } finally {
      if (requestId <= _requestCounter) {
        loading = false;
        notifyListeners();
      }
    }
  }

  @override
  void dispose() {
    _debounce?.cancel();
    controller.dispose();
    super.dispose();
  }
}
