import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nero_app/develop/home/community/pages/community_search_page.dart';
import 'package:nero_app/develop/settings/page/setting_page.dart';

class CommunityAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String title;

  CommunityAppBar({required this.title});

  @override
  _CommunityAppBarState createState() => _CommunityAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(56.0);
}

class _CommunityAppBarState extends State<CommunityAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
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
          Row(
            children: [
              SizedBox(width: 32),
              Text(
                widget.title,
                style: TextStyle(
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CommunitySearchPage()),
                  );
                },
                child: Icon(
                  Icons.search,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              SizedBox(width: 40),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SettingPage()),
                  );
                },
                child: SvgPicture.asset(
                  'assets/develop/setting.svg',
                  width: 24,
                  height: 24,
                ),
              ),
              SizedBox(width: 24),
            ],
          ),
        ],
      ),
    );
  }
}
