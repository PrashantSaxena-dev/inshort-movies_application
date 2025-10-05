import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/home_model.dart';
import '../../data/models/movie_model.dart';
import 'movie_details_screen.dart';
import '../../data/local/movie_local_data_source.dart';
import '../widgets/now_playing_item.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final PageController _pageController;
  Timer? _autoTimer;
  int _current = 0;
  double? _carouselHeight;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 1.0);
    _startAutoScroll();
  }

  void _startAutoScroll() {
    _autoTimer?.cancel();
    _autoTimer = Timer.periodic(const Duration(seconds: 5), (_) {
      final home = Provider.of<HomeModel>(context, listen: false);
      final len = home.trending.length;
      if (len == 0) return;
      _current = (_current + 1) % len;
      _pageController.animateToPage(
        _current,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOut,
      );
    });
  }

  void _stopAutoScroll() {
    _autoTimer?.cancel();
    _autoTimer = null;
  }

  @override
  void dispose() {
    _autoTimer?.cancel();
    _pageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _openDetails(BuildContext context, MovieModel m) {
    Navigator.pushNamed(context, MovieDetailsScreen.routeName, arguments: m.id);
  }

  @override
  Widget build(BuildContext context) {
    final homeModel = Provider.of<HomeModel>(context);

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          RefreshIndicator(
            onRefresh: () => homeModel.loadAll(),
            child: SingleChildScrollView(
              controller: _scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Carousel (extends to top)
                  SizedBox(
                    height: _carouselHeight ??=
                        MediaQuery.of(context).size.height * 0.65,
                    child: Stack(
                      children: [
                        PageView.builder(
                          controller: _pageController,
                          itemCount: homeModel.trending.length,
                          onPageChanged: (idx) =>
                              setState(() => _current = idx),
                          itemBuilder: (context, index) {
                            final m = homeModel.trending[index];
                            return GestureDetector(
                              onTap: () => _openDetails(context, m),
                              onPanDown: (_) => _stopAutoScroll(),
                              onPanCancel: () => _startAutoScroll(),
                              child: Hero(
                                tag: 'poster-${m.id}',
                                child: Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    image: m.posterUrl != null
                                        ? DecorationImage(
                                            image: NetworkImage(m.posterUrl!),
                                            fit: BoxFit.cover,
                                          )
                                        : null,
                                  ),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          Colors.black.withOpacity(0.1),
                                          Colors.black.withOpacity(0.8)
                                        ],
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                      ),
                                    ),
                                    child: Align(
                                      alignment: Alignment.bottomLeft,
                                      child: Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              m.title,
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 24,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              '(${m.releaseDate!})',
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 15,
                                                // fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(height: 8),
                                            // ElevatedButton(
                                            //   onPressed: () => _openDetails(context, m),
                                            //   style: ElevatedButton.styleFrom(
                                            //     backgroundColor: Colors.white24,
                                            //     shape: RoundedRectangleBorder(
                                            //       borderRadius: BorderRadius.circular(8),
                                            //     ),
                                            //   ),
                                            //   child: const Text('Details'),
                                            // ),
                                            const SizedBox(height: 12),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),

                        // Left/right arrows
                        Positioned(
                          left: 8,
                          top: 0,
                          bottom: 0,
                          child: Center(
                            child: IconButton(
                              icon: const Icon(Icons.chevron_left,
                                  size: 42, color: Colors.white70),
                              onPressed: () {
                                _stopAutoScroll();
                                final prev = (_current - 1) < 0
                                    ? (homeModel.trending.length - 1)
                                    : _current - 1;
                                _pageController.animateToPage(prev,
                                    duration: const Duration(milliseconds: 400),
                                    curve: Curves.easeInOut);
                                _startAutoScroll();
                              },
                            ),
                          ),
                        ),
                        Positioned(
                          right: 8,
                          top: 0,
                          bottom: 0,
                          child: Center(
                            child: IconButton(
                              icon: const Icon(Icons.chevron_right,
                                  size: 42, color: Colors.white70),
                              onPressed: () {
                                _stopAutoScroll();
                                final next = (_current + 1) %
                                    (homeModel.trending.isEmpty
                                        ? 1
                                        : homeModel.trending.length);
                                _pageController.animateToPage(next,
                                    duration: const Duration(milliseconds: 400),
                                    curve: Curves.easeInOut);
                                _startAutoScroll();
                              },
                            ),
                          ),
                        ),

                        // Modern line-based page indicator
                        Positioned(
                          left: 20,
                          right: 20,
                          bottom: 18,
                          child: LayoutBuilder(
                            builder: (context, constraints) {
                              final total = homeModel.trending.length;
                              final double segmentWidth =
                                  total > 0 ? constraints.maxWidth / total : 0;

                              return Stack(
                                children: [
                                  // Base line
                                  Container(
                                    height: 4,
                                    decoration: BoxDecoration(
                                      color: Colors.white10,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                  ),
                                  // Active segment
                                  AnimatedPositioned(
                                    duration: const Duration(milliseconds: 400),
                                    left: segmentWidth * _current,
                                    child: AnimatedContainer(
                                      duration:
                                          const Duration(milliseconds: 400),
                                      width: segmentWidth,
                                      height: 4,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(4),
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                Colors.white.withOpacity(0.4),
                                            blurRadius: 6,
                                            spreadRadius: 1,
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 18),

                  // Now Playing header
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12.0),
                    child: Text(
                      'Now Playing',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Now Playing list
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: homeModel.nowPlaying.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final m = homeModel.nowPlaying[index];
                      return NowPlayingItem(
                        movie: m,
                        onTap: () => _openDetails(context, m),
                      );
                    },
                  ),

                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),

          // Floating Search + Bookmark (next to each other)
          Positioned(
            top: 40,
            right: 16,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildTopCircleButton(
                  icon: Icons.search,
                  onTap: () => Navigator.pushNamed(context, '/search'),
                ),
                const SizedBox(width: 12),
                _buildTopCircleButton(
                  icon: Icons.bookmarks,
                  onTap: () => Navigator.pushNamed(context, '/bookmarks'),
                ),
              ],
            ),
          ),

          // Scroll-to-top FAB
          Positioned(
            right: 16,
            bottom: 16,
            child: FloatingActionButton(
              backgroundColor: Colors.white12,
              onPressed: () {
                _scrollController.animateTo(0,
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeInOut);
              },
              child: const Icon(Icons.arrow_upward, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopCircleButton(
      {required IconData icon, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(40),
      child: Container(
        width: 46,
        height: 46,
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.45),
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white24, width: 1),
        ),
        child: Icon(icon, color: Colors.white, size: 24),
      ),
    );
  }
}
