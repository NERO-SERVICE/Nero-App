import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nero_app/develop/home/main/page/home_main_content_page.dart';

class HomeMainPage extends StatelessWidget {
  const HomeMainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
            child: Container(
              color: Colors.transparent,
            ),
          ),
        ),
        toolbarHeight: 56.0,
        titleSpacing: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              child: Row(
                children: [
                  SizedBox(width: 32),
                  SvgPicture.asset(
                    'assets/develop/nero-appbar-logo.svg',
                    width: 71,
                    height: 27,
                  ),
                ],
              ),
            ),
            Container(
              child: Row(
                children: [
                  SvgPicture.asset(
                    'assets/develop/letter.svg',
                    width: 24,
                    height: 24,
                  ),
                  SizedBox(width: 40),
                  SvgPicture.asset(
                    'assets/develop/setting.svg',
                    width: 24,
                    height: 24,
                  ),
                  SizedBox(width: 24),
                ],
              ),
            )
          ],
        ),
      ),
      body: HomeMainContentPage(),
    );
  }
}
