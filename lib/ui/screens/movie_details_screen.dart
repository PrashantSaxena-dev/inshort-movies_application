import 'package:flutter/material.dart';

class MovieDetailsScreen extends StatelessWidget {
  static const routeName = '/details';

  const MovieDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments;
    final int movieId = args is int ? args : int.parse(args.toString());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Movie Details'),
      ),
      body: Center(
        child: Text('Movie details for id: $movieId'),
      ),
    );
  }
}
