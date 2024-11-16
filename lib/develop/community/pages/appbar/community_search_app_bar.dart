import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:nero_app/app_colors.dart';

class CommunitySearchAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final TextEditingController searchController;
  final VoidCallback onSearch;
  final VoidCallback onBack;

  CommunitySearchAppBar({
    required this.searchController,
    required this.onSearch,
    required this.onBack,
  });

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
      title: TextField(
        controller: searchController,
        onSubmitted: (_) => onSearch(),
        decoration: InputDecoration(
          hintText: '검색어를 입력하세요',
          border: InputBorder.none,
          hintStyle: TextStyle(
            fontFamily: 'Pretendard',
            fontWeight: FontWeight.w400,
            fontSize: 14,
            color: AppColors.hintTextColor,
          ),
        ),
        style: TextStyle(color: Colors.white),
        cursorColor: Color(0xffd9d9d9),
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.search, color: Colors.white),
          onPressed: onSearch,
        ),
      ],
      leading: IconButton(
        icon: const Icon(Icons.chevron_left, color: Colors.white),
        onPressed: onBack, // 뒤로 가기 버튼에 onBack 콜백 할당
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(56.0);
}
