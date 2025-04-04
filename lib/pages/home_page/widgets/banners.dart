import 'dart:async';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:ussd/models/banner.dart';

class Banners extends StatefulWidget {
  const Banners({super.key, required this.banners});

  final List<BannerModel> banners;
  @override
  State<Banners> createState() => _BannersState();
}

class _BannersState extends State<Banners> {
  late final PageController controller;
  @override
  void initState() {
    super.initState();
    controller = PageController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Timer.periodic(
        const Duration(seconds: 5),
        (timer) async {
          if (!mounted) {
            timer.cancel();
            return;
          }
          if (controller.page == widget.banners.length - 1) {
            await controller.animateToPage(
              0,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeIn,
            );
          } else {
            await controller.nextPage(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeIn,
            );
          }
          final page = controller.page?.round();
          if (page == null) return;
          final banner = widget.banners[page];
          FirebaseAnalytics.instance.logEvent(
            name: 'banner_impression',
            parameters: {
              'banner_id': banner.id,
            },
          );
        },
      );
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: PageView(
        allowImplicitScrolling: false,
        physics: const NeverScrollableScrollPhysics(),
        controller: controller,
        children: widget.banners.map((banner) {
          return Card(
            child: GestureDetector(
              onTap: banner.link == null
                  ? null
                  : () {
                      FirebaseAnalytics.instance.logEvent(
                        name: 'banner_click',
                        parameters: {
                          'banner_id': banner.id,
                        },
                      );
                      launchUrl(Uri.parse(banner.link!));
                    },
              child: ListTile(
                title: Text(
                  banner.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: banner.description != null
                    ? Text(
                        banner.description!,
                        style: const TextStyle(fontSize: 14),
                      )
                    : null,
                trailing: banner.link != null
                    ? const TextButton(
                        onPressed: null,
                        child: Text(
                          'تفاصيل',
                          style: TextStyle(color: Colors.blue),
                        ),
                      )
                    : null,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
