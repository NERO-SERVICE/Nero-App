import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:nero_app/app_colors.dart';
import 'package:nero_app/develop/community/controllers/community_controller.dart';
import 'package:nero_app/develop/community/pages/community_search_page.dart';
import 'package:nero_app/develop/community/pages/community_write_page.dart';

class CommunityAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String title;

  CommunityAppBar({required this.title});

  @override
  _CommunityAppBarState createState() => _CommunityAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(56.0);
}

class _CommunityAppBarState extends State<CommunityAppBar> {
  final CommunityController _controller = Get.find<CommunityController>();

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
              Container(
                child: Row(
                  children: [
                    SizedBox(width: 32),
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        SvgPicture.asset(
                          'assets/develop/nero-appbar-logo.svg',
                          width: 71,
                          height: 27,
                        ),
                        Positioned(
                          left: 71 + 8,
                          top: 8,
                          child: Text(
                            "Community",
                            style: TextStyle(
                              fontFamily: 'Pretendard',
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                              color: AppColors.secondaryTextColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
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
                  color: AppColors.titleColor,
                  size: 24,
                ),
              ),
              SizedBox(width: 16),
              GestureDetector(
                onTap: () async {
                  await Get.to(() => CommunityWritePage());
                  _controller.fetchAllPosts(refresh: true);
                },
                child: Icon(
                  Icons.add,
                  color: AppColors.titleColor,
                  size: 24,
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
