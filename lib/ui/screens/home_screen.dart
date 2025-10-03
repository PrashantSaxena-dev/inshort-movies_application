import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Movies App"),
      ),
      body: const Center(
        child: Text(
          "Movies App \nTrending & Now Playing will show here.",
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
