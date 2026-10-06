import 'dart:async';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class _BannerData {
  final String url;
  final String title;
  final String subtitle;
  final Color color;
  final Color textColor;
  final Duration duration;

  const _BannerData({
    required this.url,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.duration,
    required this.textColor,
  });
}

const _banners = [
  _BannerData(
    url: 'https://play.google.com/store/apps/details?id=com.radiantglow',
    title: 'Discover Your Natural Glow',
    subtitle: 'Stay healthy, save hospital costs with smart dieting',
    color: Color.fromARGB(255, 255, 215, 0), // Golden Yellow
    textColor: Colors.black,
    duration: Duration(seconds: 12),
  ),

  _BannerData(
    url:
        'https://play.google.com/store/apps/details?id=com.notebook_bms.notebook_bms',
    title: 'Ace Your Biomedical Research and Studies',
    subtitle: 'With Notebook BMS',
    color: Color.fromARGB(255, 21, 146, 168),
    textColor: Colors.white,
    duration: Duration(seconds: 5),
  ),
];

class AppBanner extends StatefulWidget {
  const AppBanner({super.key});

  @override
  State<AppBanner> createState() => _AppBannerState();
}

class _AppBannerState extends State<AppBanner> {
  int _index = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _scheduleNext();
  }

  void _scheduleNext() {
    _timer = Timer(_banners[_index].duration, () {
      if (!mounted) return;
      setState(() => _index = (_index + 1) % _banners.length);
      _scheduleNext();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final banner = _banners[_index];
    return GestureDetector(
      onTap: () async {
        final uri = Uri.parse(banner.url);
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        color: banner.color,
        child: Row(
          children: [
            const Icon(Icons.download, color: Colors.white, size: 28),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    banner.title,
                    style: TextStyle(
                      color: banner.textColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 11,
                    ),
                  ),
                  Text(
                    banner.subtitle,
                    style: TextStyle(
                      color: banner.textColor.withOpacity(0.8),
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                'Download',
                style: TextStyle(
                  color: banner.color,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
