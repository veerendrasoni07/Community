import 'dart:async';
import 'package:codingera2/controllers/banner_controller.dart';
import 'package:codingera2/models/banner.dart';
import 'package:codingera2/provider/banner_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class BannerWidget extends ConsumerStatefulWidget {
  const BannerWidget({super.key});

  @override
  ConsumerState<BannerWidget> createState() => _BannerWidgetState();
}

class _BannerWidgetState extends ConsumerState<BannerWidget> {
  final PageController _pageController = PageController();
  Timer? _autoScrollTimer;
  int _currentPage = 0;
  List<BannerModel> banners = [];

  @override
  void initState() {
    super.initState();
    ref.read(bannerProvider.notifier).setBanner(context: context, ref: ref);
  }


  void _startAutoScroll(int length) {
    if (_autoScrollTimer != null || length <= 1) return;

    _autoScrollTimer = Timer.periodic(const Duration(seconds: 3), (_) {
      if (_pageController.hasClients) {
        _currentPage = (_currentPage + 1) % length;
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _autoScrollTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final banners = ref.watch(bannerProvider);
    _startAutoScroll(banners.length);
    return SizedBox(
      height: 250,
      width: MediaQuery.of(context).size.width,
      child:
          banners.isEmpty
              ? Center(child: CircularProgressIndicator())
              : Column(
                children: [
                  Expanded(
                    child: PageView.builder(
                      controller: _pageController,
                      itemCount: banners.length,
                      onPageChanged: (index) => _currentPage = index,
                      itemBuilder: (context, index) {
                        final banner = banners[index];
                        return Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.white),
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.blueAccent.shade100,
                                  blurRadius: 5,
                                  spreadRadius: 2
                                )
                              ]
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Image.network(
                                banner.url,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  SmoothPageIndicator(
                    controller: _pageController,
                    count: banners.length,
                    effect: JumpingDotEffect(
                      offset: 25,
                      verticalOffset: 5,
                      jumpScale: 1.4,
                      activeDotColor: Colors.blueAccent
                    ),
                  ),
                ],
              ),
    );
  }
}
