import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:nero_app/app_colors.dart';

class CustomDetailAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final String title;

  CustomDetailAppBar({required this.title});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
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
      leading: IconButton(
        icon: const Icon(Icons.chevron_left, color: AppColors.titleColor),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
      actions: [
        SizedBox(width: kToolbarHeight),
      ],
      toolbarHeight: 56.0,
      titleSpacing: 0,
      title: Text(
        title,
        style: TextStyle(
          fontFamily: 'Pretendard',
          fontWeight: FontWeight.w600,
          fontSize: 18,
          color: AppColors.titleColor,
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(56.0);
}
