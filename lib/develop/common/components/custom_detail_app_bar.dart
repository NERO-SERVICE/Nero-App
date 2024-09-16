import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomDetailAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  CustomDetailAppBar({required this.title});

  @override
  Widget build(BuildContext context) {
    return AppBar(
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
      leading: IconButton(
        icon: const Icon(Icons.chevron_left, color: Colors.white),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
      toolbarHeight: 56.0,
      titleSpacing: 0,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            child: Row(
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                    color: Colors.white,
                  ),
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
          ),
        ],
      ),
    );
  }

  // AppBar의 크기를 지정하는 preferredSize
  @override
  Size get preferredSize => Size.fromHeight(56.0);
}
